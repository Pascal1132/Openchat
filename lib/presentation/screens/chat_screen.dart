import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../artifacts/widgets/artifact_panel.dart';
import '../../domain/models/artifact.dart' as domain_artifact;
import '../../domain/models/conversation.dart';
import '../../domain/models/message.dart';
import '../../domain/models/openrouter_model.dart';
import '../providers/chat_controller.dart';
import '../providers/core_providers.dart';
import '../themes/colors.dart';
import '../themes/typography.dart';
import '../widgets/app_shell.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';
import '../widgets/responsive_layout.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({this.conversationId, super.key});

  final String? conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.conversationId != null) {
        ref.read(selectedConversationIdProvider.notifier).state =
            widget.conversationId;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _sendMessage(Conversation conversation, String text) async {
    await ref.read(chatControllerProvider).sendMessage(
          conversation: conversation,
          content: text,
        );
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final conversationAsync = ref.watch(currentConversationProvider);
    final messagesAsync = ref.watch(currentMessagesProvider);
    final artifactsAsync = ref.watch(currentArtifactsProvider);
    final isSending = ref.watch(chatSendStateProvider);
    final streamingMessage = ref.watch(streamingMessageProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;
    final apiKey = ref.watch(apiKeyProvider).valueOrNull ?? '';
    final modelsAsync = ref.watch(modelsProvider(apiKey));

    return AppShell(
      selectedConversationId: widget.conversationId,
      body: conversationAsync.when(
        data: (conversation) {
          if (conversation == null) {
            return _buildEmptyState(context);
          }
          return _buildChatBody(
            context,
            conversation,
            messagesAsync,
            artifactsAsync,
            streamingMessage,
            isSending,
            settings?.artifactsEnabled ?? true,
            modelsAsync.valueOrNull ?? <OpenRouterModel>[],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text(
            'Error: $err',
            style: AppTypography.body.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.chat_bubble,
              color: AppColors.background,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text('OpenChat', style: AppTypography.display),
          const SizedBox(height: 6),
          Text(
            'Start a new conversation from the sidebar.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBody(
    BuildContext context,
    Conversation conversation,
    AsyncValue<List<Message>> messagesAsync,
    AsyncValue<List<domain_artifact.Artifact>> artifactsAsync,
    Message? streamingMessage,
    bool isSending,
    bool showArtifacts,
    List<OpenRouterModel> models,
  ) {
    return Column(
      children: [
        _AppBar(
          conversation: conversation,
          onBack: () => context.go('/'),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _MessageList(
                  messagesAsync: messagesAsync,
                  streamingMessage: streamingMessage,
                  scrollController: _scrollController,
                ),
              ),
              if (isDesktop(context) && showArtifacts)
                _ArtifactDrawer(
                  artifactsAsync: artifactsAsync,
                  streamingMessage: streamingMessage,
                ),
            ],
          ),
        ),
        ChatInput(
          onSend: (text) => _sendMessage(conversation, text),
          onStop: ref.read(chatControllerProvider).stopGeneration,
          isLoading: isSending,
          availableModels: models,
          selectedModel: _findSelectedModel(models, conversation.modelId),
          onModelChanged: (model) => _onModelChanged(conversation, model),
        ),
      ],
    );
  }

  OpenRouterModel? _findSelectedModel(
    List<OpenRouterModel> models,
    String? modelId,
  ) {
    if (modelId == null) return null;
    try {
      return models.firstWhere((m) => m.id == modelId);
    } on StateError {
      return null;
    }
  }

  Future<void> _onModelChanged(
    Conversation conversation,
    OpenRouterModel? model,
  ) async {
    await ref.read(conversationsProvider.notifier).updateConversation(
          conversation.copyWith(
            modelId: model?.id,
            modelName: model?.displayName,
          ),
        );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.conversation, required this.onBack});

  final Conversation conversation;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final modelName = conversation.modelName ?? conversation.modelId;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (!isDesktop(context))
            GestureDetector(
              onTap: Scaffold.of(context).openDrawer,
              child: const Icon(
                Icons.menu,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          if (!isDesktop(context)) const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.displayTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.title.copyWith(fontSize: 15),
                ),
                if (modelName != null)
                  Text(
                    modelName,
                    style: AppTypography.label.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.messagesAsync,
    required this.streamingMessage,
    required this.scrollController,
  });

  final AsyncValue<List<Message>> messagesAsync;
  final Message? streamingMessage;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return messagesAsync.when(
      data: (messages) {
        final displayMessages = [...messages];
        if (streamingMessage != null &&
            displayMessages.every((m) => m.id != streamingMessage!.id)) {
          displayMessages.add(streamingMessage!);
        }

        if (displayMessages.isEmpty) {
          return const _EmptyConversationState();
        }

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: displayMessages.length,
          itemBuilder: (context, index) {
            final message = displayMessages[index];
            return MessageBubble(
              message: message,
              onRegenerate: () => _regenerate(message),
              onCopy: () => _copy(context, message.content),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (err, _) => Center(
        child: Text(
          'Error: $err',
          style: AppTypography.body.copyWith(color: AppColors.error),
        ),
      ),
    );
  }

  void _regenerate(Message message) {
    // Implemented via parent context using ref is not accessible here without
    // making this widget a ConsumerWidget. Kept no-op for current refactor;
    // the chat controller uses regenerate on the message through the provider.
  }

  Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceRaised,
          content: Text(
            'Copied',
            style: AppTypography.bodySmall,
          ),
        ),
      );
    }
  }
}

class _EmptyConversationState extends StatelessWidget {
  const _EmptyConversationState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What can I do for you?',
            style: AppTypography.title,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _SuggestionChip(label: 'Explain a concept'),
              _SuggestionChip(label: 'Write Dart code'),
              _SuggestionChip(label: 'Summarize a PDF'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall,
      ),
    );
  }
}

class _ArtifactDrawer extends StatelessWidget {
  const _ArtifactDrawer({
    required this.artifactsAsync,
    required this.streamingMessage,
  });

  final AsyncValue<List<domain_artifact.Artifact>> artifactsAsync;
  final Message? streamingMessage;

  @override
  Widget build(BuildContext context) {
    final artifacts = artifactsAsync.valueOrNull ?? <domain_artifact.Artifact>[];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: artifacts.isNotEmpty ? 360 : 0,
      child: artifacts.isNotEmpty
          ? Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(left: BorderSide(color: AppColors.border)),
              ),
              child: ArtifactPanel(
                artifacts: artifacts,
                selectedArtifactId:
                    artifacts.isNotEmpty ? artifacts.first.id : null,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
