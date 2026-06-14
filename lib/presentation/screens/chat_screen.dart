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
import '../widgets/common/icon_button_custom.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureConversation());
  }

  /// Makes sure the user always lands inside a usable conversation:
  /// honours an explicit route id, otherwise selects the most recent chat,
  /// or creates a fresh one when none exist yet.
  Future<void> _ensureConversation() async {
    if (widget.conversationId != null) {
      ref.read(selectedConversationIdProvider.notifier).state =
          widget.conversationId;
      return;
    }

    if (ref.read(selectedConversationIdProvider) != null) return;

    final conversations =
        await ref.read(conversationRepositoryProvider).getAllConversations();
    final active = conversations.where((c) => !c.archived).toList();

    if (!mounted) return;

    if (active.isNotEmpty) {
      ref.read(selectedConversationIdProvider.notifier).state = active.first.id;
      if (mounted) context.go('/chat/${active.first.id}');
    } else {
      final created = await ref.read(conversationsProvider.notifier).create();
      if (!mounted) return;
      ref.read(selectedConversationIdProvider.notifier).state = created.id;
      if (mounted) context.go('/chat/${created.id}');
    }
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
    return Column(
      children: [
        _TopBar(
          title: 'OpenChat',
          subtitle: null,
          showMenu: !isDesktop(context),
        ),
        const Expanded(
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ],
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
        _TopBar(
          title: conversation.displayTitle,
          subtitle: conversation.modelName ?? conversation.modelId,
          showMenu: !isDesktop(context),
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

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.subtitle,
    this.showMenu = false,
  });

  final String title;
  final String? subtitle;
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (showMenu) ...[
            IconButtonCustom(
              icon: Icons.menu,
              onTap: () {
                final scaffold = Scaffold.maybeOf(context);
                scaffold?.openDrawer();
              },
              tooltip: 'Menu',
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.title.copyWith(fontSize: 15),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _MessageList extends ConsumerWidget {
  const _MessageList({
    required this.messagesAsync,
    required this.streamingMessage,
    required this.scrollController,
  });

  final AsyncValue<List<Message>> messagesAsync;
  final Message? streamingMessage;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onRegenerate: message.role == MessageRole.assistant &&
                      !message.isStreaming
                  ? () => ref.read(chatControllerProvider).regenerate(message)
                  : null,
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

class _EmptyConversationState extends ConsumerWidget {
  const _EmptyConversationState();

  static const _suggestions = <String>[
    'Explain a concept simply',
    'Write a Dart function',
    'Brainstorm ideas with me',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppColors.background,
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'What can I do for you?',
              style: AppTypography.title,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _suggestions
                  .map(
                    (s) => _SuggestionChip(
                      label: s,
                      onTap: () => _send(ref, s),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send(WidgetRef ref, String prompt) async {
    final id = ref.read(selectedConversationIdProvider);
    if (id == null) return;
    final conversation =
        await ref.read(conversationRepositoryProvider).getConversationById(id);
    if (conversation == null) return;
    await ref
        .read(chatControllerProvider)
        .sendMessage(conversation: conversation, content: prompt);
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
