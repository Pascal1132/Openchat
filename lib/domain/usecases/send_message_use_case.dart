import 'dart:async';
import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../artifacts/artifact_parser.dart';
import '../../services/openrouter/openrouter_api.dart';
import '../models/app_settings.dart';
import '../models/artifact.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../models/tool.dart';
import '../repositories/artifact_repository.dart';
import '../repositories/conversation_repository.dart';
import '../repositories/message_repository.dart';

class StreamingUpdate {
  const StreamingUpdate({
    required this.message,
    this.artifacts = const <Artifact>[],
    this.toolCalls,
    this.isDone = false,
  });

  final Message message;
  final List<Artifact> artifacts;
  final List<ToolCall>? toolCalls;
  final bool isDone;
}

class SendMessageUseCase {
  SendMessageUseCase({
    required OpenRouterApi api,
    required MessageRepository messageRepository,
    required ConversationRepository conversationRepository,
    required ArtifactRepository artifactRepository,
    required ArtifactParser artifactParser,
  })  : _api = api,
        _messageRepository = messageRepository,
        _conversationRepository = conversationRepository,
        _artifactRepository = artifactRepository,
        _artifactParser = artifactParser;

  final OpenRouterApi _api;
  final MessageRepository _messageRepository;
  final ConversationRepository _conversationRepository;
  final ArtifactRepository _artifactRepository;
  final ArtifactParser _artifactParser;

  Stream<StreamingUpdate> call({
    required String apiKey,
    required Conversation conversation,
    required String content,
    required AppSettings settings,
    required List<Message> history,
    List<Tool>? tools,
  }) async* {
    if (content.trim().isEmpty) return;

    final userMessage = await _persistUserMessage(conversation, content);
    await _conversationRepository.updateConversation(
      conversation.copyWith(
        updatedAt: DateTime.now().toUtc(),
        lastMessagePreview: _previewFor(content.trim()),
      ),
    );

    final modelId =
        conversation.modelId ?? settings.defaultModelId ?? 'openai/gpt-4o';
    final modelName = conversation.modelName ?? modelId;

    final requestMessages = _buildRequestMessages(history, userMessage);
    final request = ChatCompletionRequest(
      model: modelId,
      messages: requestMessages,
      temperature: settings.temperature,
      topP: settings.topP,
      maxTokens: settings.maxTokens,
      stream: settings.streamingEnabled,
      tools: tools != null && settings.toolsEnabled ? tools : null,
    );

    var assistantMessage = Message(
      id: const Uuid().v4(),
      conversationId: conversation.id,
      role: MessageRole.assistant,
      content: '',
      isStreaming: true,
      createdAt: DateTime.now().toUtc(),
      modelId: modelId,
      modelName: modelName,
    );
    await _messageRepository.addMessage(assistantMessage);

    final buffer = StringBuffer();
    final artifacts = <Artifact>[];

    await for (final chunk in _api.streamChatCompletion(
      apiKey: apiKey,
      request: request,
    )) {
      if (chunk.startsWith('__TOOL_CALLS__:')) {
        assistantMessage = assistantMessage.copyWith(
          toolCalls: {'raw': chunk.substring('__TOOL_CALLS__:'.length)},
        );
        continue;
      }
      buffer.write(chunk);
      assistantMessage = assistantMessage.copyWith(content: buffer.toString());
      await _messageRepository.updateMessage(assistantMessage);
      await _extractAndSaveArtifacts(
        buffer.toString(),
        conversation.id,
        artifacts,
        assistantMessage.id,
      );
      yield StreamingUpdate(message: assistantMessage, artifacts: artifacts);
    }

    final (displayContent, finalArtifacts) = await _finalizeArtifacts(
      buffer.toString(),
      conversation.id,
      assistantMessage.id,
    );
    artifacts
      ..clear()
      ..addAll(finalArtifacts);

    assistantMessage = assistantMessage.copyWith(
      content: displayContent,
      isStreaming: false,
      artifactIds: finalArtifacts.map((a) => a.id).toList(),
    );
    await _messageRepository.updateMessage(assistantMessage);

    final toolCalls = assistantMessage.toolCalls != null
        ? _extractToolCalls(assistantMessage.toolCalls!['raw'] as String? ?? '')
        : null;

    if (toolCalls != null && toolCalls.isNotEmpty) {
      assistantMessage = assistantMessage.copyWith(
        toolCalls: {'tool_calls': toolCalls},
      );
      await _messageRepository.updateMessage(assistantMessage);
    }

    await _conversationRepository.updateConversation(
      conversation.copyWith(
        updatedAt: DateTime.now().toUtc(),
        lastMessagePreview: _previewFor(displayContent),
      ),
    );

    yield StreamingUpdate(
      message: assistantMessage,
      artifacts: artifacts,
      toolCalls: toolCalls,
      isDone: true,
    );
  }

  Future<Message> _persistUserMessage(
    Conversation conversation,
    String content,
  ) async {
    final message = Message(
      id: const Uuid().v4(),
      conversationId: conversation.id,
      role: MessageRole.user,
      content: content.trim(),
      createdAt: DateTime.now().toUtc(),
    );
    await _messageRepository.addMessage(message);
    return message;
  }

  List<Message> _buildRequestMessages(List<Message> history, Message userMessage) {
    final messages = <Message>[
      const Message(
        id: 'system',
        conversationId: '',
        role: MessageRole.system,
        content:
            'You are OpenChat, a helpful AI assistant. Wrap code, markdown, HTML, JSON, tables, or documents in <artifact type="..." title="...">...</artifact> tags to display them in a dedicated panel.',
      ),
      ...history.where((m) => !m.isStreaming && m.content.isNotEmpty),
      userMessage,
    ];
    return messages;
  }

  Future<void> _extractAndSaveArtifacts(
    String text,
    String conversationId,
    List<Artifact> artifacts,
    String idSeed,
  ) async {
    final parsed = _artifactParser.parse(text, idSeed: idSeed);
    for (final artifact in parsed) {
      final existing = artifacts.where((a) => a.id == artifact.id).firstOrNull;
      if (existing == null) {
        final saved = await _artifactRepository.saveArtifact(
          artifact.copyWith(conversationId: conversationId),
        );
        artifacts.add(saved);
      } else if (existing.content != artifact.content) {
        final index = artifacts.indexOf(existing);
        // Overwrite in place (same id) instead of versioning every token.
        final updated = existing.copyWith(
          content: artifact.content,
          title: artifact.title,
          type: artifact.type,
          language: artifact.language,
          updatedAt: DateTime.now().toUtc(),
        );
        await _artifactRepository.updateArtifact(updated);
        artifacts[index] = updated;
      }
    }
  }

  Future<(String, List<Artifact>)> _finalizeArtifacts(
    String text,
    String conversationId,
    String idSeed,
  ) async {
    final parsed = _artifactParser.parse(text, idSeed: idSeed);
    final artifacts = <Artifact>[];
    for (final artifact in parsed) {
      final saved = await _artifactRepository.saveArtifact(
        artifact.copyWith(conversationId: conversationId),
      );
      artifacts.add(saved);
    }
    final content = _artifactParser.stripArtifacts(text);
    return (content, artifacts);
  }

  List<ToolCall> _extractToolCalls(String payload) {
    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      final choices = decoded['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) return <ToolCall>[];
      final delta = (choices.first as Map<String, dynamic>)['delta']
          as Map<String, dynamic>?;
      final calls = delta?['tool_calls'] as List<dynamic>?;
      if (calls == null) return <ToolCall>[];
      return calls.map((call) {
        final c = call as Map<String, dynamic>;
        final function = c['function'] as Map<String, dynamic>?;
        return ToolCall(
          id: c['id'] as String? ?? const Uuid().v4(),
          name: function?['name'] as String? ?? '',
          arguments: jsonDecode(function?['arguments'] as String? ?? '{}')
              as Map<String, dynamic>,
        );
      }).toList();
    } on Exception {
      return <ToolCall>[];
    }
  }

  String _previewFor(String content) {
    final stripped = content.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (stripped.length <= 80) return stripped;
    return '${stripped.substring(0, 77)}...';
  }
}
