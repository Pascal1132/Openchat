import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../domain/models/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    this.onRegenerate,
    this.onEdit,
    super.key,
  });

  final Message message;
  final VoidCallback? onRegenerate;
  final VoidCallback? onEdit;

  bool get _isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isUser
          ? Theme.of(context).colorScheme.surface
          : Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(context),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSenderLabel(context),
                const SizedBox(height: 6),
                _buildContent(context),
                if (message.isStreaming) _buildTypingIndicator(),
                if (_isUser) _buildUserActions(context),
                if (message.role == MessageRole.assistant && !message.isStreaming)
                  _buildAssistantActions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final icon = _isUser ? Icons.person : Icons.auto_awesome;
    final background = _isUser
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.tertiaryContainer;
    final foreground = _isUser
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onTertiaryContainer;
    return CircleAvatar(
      radius: 16,
      backgroundColor: background,
      child: Icon(icon, size: 18, color: foreground),
    );
  }

  Widget _buildSenderLabel(BuildContext context) {
    final label = _isUser ? 'You' : 'Assistant';
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isUser) {
      return SelectableText(
        message.content,
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }

    return MarkdownBody(
      data: message.content,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        codeblockDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        code: TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildUserActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 16),
          onPressed: onEdit,
          tooltip: 'Edit message',
        ),
      ],
    );
  }

  Widget _buildAssistantActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.refresh, size: 16),
          onPressed: onRegenerate,
          tooltip: 'Regenerate response',
        ),
      ],
    );
  }
}

