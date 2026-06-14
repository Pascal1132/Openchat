import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/conversation.dart';
import '../../domain/models/message.dart';
import 'core_providers.dart';

/// Handles sending a message, including cancellation and error handling.
class ChatController {
  ChatController(this._ref);

  final Ref _ref;

  StreamSubscription<void>? _streamSubscription;

  bool get isSending => _streamSubscription != null;

  Future<void> sendMessage({
    required Conversation conversation,
    required String content,
  }) async {
    if (content.trim().isEmpty) return;

    final apiKey = _ref.read(apiKeyProvider).valueOrNull;
    if (apiKey == null || apiKey.isEmpty) return;

    final settings = _ref.read(settingsProvider).valueOrNull;
    if (settings == null) return;

    final historyAsync = _ref.read(currentMessagesProvider);
    final history = historyAsync.valueOrNull ?? <Message>[];

    final tools = settings.toolsEnabled ? _ref.read(toolRegistryProvider).all : null;

    _ref.read(chatSendStateProvider.notifier).state = true;
    _ref.read(chatGenerationControllerProvider).reset();

    final stream = _ref.read(sendMessageUseCaseProvider).call(
          apiKey: apiKey,
          conversation: conversation,
          content: content,
          settings: settings,
          history: history,
          tools: tools,
        );

    _streamSubscription = stream.listen(
      (update) {
        _ref.read(streamingMessageProvider.notifier).state = update.message;
        // Refresh messages so the history list stays in sync.
        _ref.invalidate(messagesProvider(conversation.id));
        _ref.invalidate(artifactsProvider(conversation.id));
      },
      onError: (Object error) {
        _ref.read(streamingMessageProvider.notifier).state = null;
        _ref.read(chatSendStateProvider.notifier).state = false;
      },
      onDone: () {
        _ref.read(streamingMessageProvider.notifier).state = null;
        _ref.read(chatSendStateProvider.notifier).state = false;
        _ref.invalidate(messagesProvider(conversation.id));
        _ref.invalidate(artifactsProvider(conversation.id));
        _ref.invalidate(conversationsProvider);
        _streamSubscription = null;
      },
    );
  }

  Future<void> regenerate(Message message) async {
    final conversationId = message.conversationId;
    final conversation = await _ref.read(conversationRepositoryProvider).getConversationById(conversationId);
    if (conversation == null) return;

    // Delete the existing assistant message and re-send the previous user message.
    final messages = await _ref.read(messageRepositoryProvider).getMessagesForConversation(conversationId);
    final assistantIndex = messages.indexWhere((m) => m.id == message.id);
    if (assistantIndex <= 0) return;

    final userMessage = messages[assistantIndex - 1];
    if (userMessage.role != MessageRole.user) return;

    await _ref.read(messageRepositoryProvider).deleteMessage(message.id);
    await sendMessage(conversation: conversation, content: userMessage.content);
  }

  void stopGeneration() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _ref.read(chatGenerationControllerProvider).cancel();
    _ref.read(chatSendStateProvider.notifier).state = false;
    _ref.read(streamingMessageProvider.notifier).state = null;
  }
}

final chatControllerProvider = Provider<ChatController>((ref) => ChatController(ref));
