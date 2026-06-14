import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../artifacts/widgets/artifact_panel.dart';
import '../../domain/models/artifact.dart' as domain_artifact;
import '../../domain/models/conversation.dart';
import '../../domain/models/message.dart';
import '../providers/chat_controller.dart';
import '../providers/core_providers.dart';
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
        ref.read(selectedConversationIdProvider.notifier).state = widget.conversationId;
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
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
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
    final showArtifacts = settings?.artifactsEnabled ?? true;

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
            showArtifacts,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'OpenChat',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new conversation from the sidebar.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
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
  ) {
    final isDesktopLayout = isDesktop(context);
    final hasArtifacts = (artifactsAsync.valueOrNull?.isNotEmpty ?? false) ||
        (streamingMessage?.artifactIds.isNotEmpty ?? false);

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildAppBar(context, conversation),
              Expanded(
                child: _buildMessageList(
                  messagesAsync,
                  streamingMessage,
                  isSending,
                ),
              ),
              if (isSending)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: ref.read(chatControllerProvider).stopGeneration,
                        icon: const Icon(Icons.stop, size: 16),
                        label: const Text('Stop generating'),
                      ),
                    ],
                  ),
                ),
              ChatInput(
                onSend: (text) => _sendMessage(conversation, text),
                isLoading: isSending,
              ),
            ],
          ),
        ),
        if (isDesktopLayout && showArtifacts)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: hasArtifacts ? 360 : 0,
            child: hasArtifacts
                ? Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    child: _buildArtifactPanel(artifactsAsync, streamingMessage),
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, Conversation conversation) {
    final modelName = conversation.modelName ?? conversation.modelId ?? 'Default model';
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              conversation.displayTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Text(
            modelName,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(
    AsyncValue<List<Message>> messagesAsync,
    Message? streamingMessage,
    bool isSending,
  ) {
    return messagesAsync.when(
      data: (messages) {
        final displayMessages = <Message>[...messages];
        if (streamingMessage != null &&
            displayMessages.every((m) => m.id != streamingMessage.id)) {
          displayMessages.add(streamingMessage);
        }

        if (displayMessages.isEmpty) {
          return _buildEmptyConversationState(context);
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: displayMessages.length,
          itemBuilder: (context, index) {
            final message = displayMessages[index];
            return MessageBubble(
              message: message,
              onRegenerate: () => ref
                  .read(chatControllerProvider)
                  .regenerate(message),
              onEdit: () {
                // TODO: implement inline editing.
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildEmptyConversationState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How can I help you today?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _SuggestionChip(
                label: 'Explain a concept',
                onTap: () {},
              ),
              _SuggestionChip(
                label: 'Write some code',
                onTap: () {},
              ),
              _SuggestionChip(
                label: 'Summarize a document',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArtifactPanel(
    AsyncValue<List<domain_artifact.Artifact>> artifactsAsync,
    Message? streamingMessage,
  ) {
    final artifacts = artifactsAsync.valueOrNull ?? <domain_artifact.Artifact>[];
    return ArtifactPanel(
      artifacts: artifacts,
      selectedArtifactId: artifacts.isNotEmpty ? artifacts.first.id : null,
      onArtifactDeleted: (artifact) async {
        await ref.read(artifactRepositoryProvider).deleteArtifact(artifact.id);
        ref.invalidate(artifactsProvider(artifact.conversationId));
      },
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}
