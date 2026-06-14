import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../domain/models/message.dart';
import '../themes/colors.dart';
import '../themes/typography.dart';
import 'common/icon_button_custom.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    this.onRegenerate,
    this.onEdit,
    this.onCopy,
    super.key,
  });

  final Message message;
  final VoidCallback? onRegenerate;
  final VoidCallback? onEdit;
  final VoidCallback? onCopy;

  bool get _isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isUser ? AppColors.background : AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(isUser: _isUser, isStreaming: message.isStreaming),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 6),
                _Content(message: message),
                if (message.isStreaming) _StreamingCursor(),
                const SizedBox(height: 10),
                _Actions(
                  isUser: _isUser,
                  onEdit: onEdit,
                  onRegenerate: onRegenerate,
                  onCopy: onCopy,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final modelLabel = message.modelName ?? message.modelId;
    return Row(
      children: [
        Text(
          _isUser ? 'You' : 'OpenChat',
          style: AppTypography.label.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (!_isUser && modelLabel != null && modelLabel.isNotEmpty) ...[
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceOverlay,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, size: 9, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      modelLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (message.isStreaming) ...[
          const SizedBox(width: 8),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.isUser, this.isStreaming});

  final bool isUser;
  final bool? isStreaming;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: isUser
            ? const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryMuted],
              )
            : const LinearGradient(
                colors: [AppColors.accent, Color(0xFF4DFFEA)],
              ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: isUser
            ? const Icon(Icons.person, size: 18, color: Colors.white)
            : const _SparkleIcon(),
      ),
    );
  }
}

class _SparkleIcon extends StatefulWidget {
  const _SparkleIcon();

  @override
  State<_SparkleIcon> createState() => _SparkleIconState();
}

class _SparkleIconState extends State<_SparkleIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 0.2 - 0.1,
          child: const Icon(
            Icons.auto_awesome,
            size: 18,
            color: AppColors.background,
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    if (message.role == MessageRole.user) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.userBubble,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.content,
          style: AppTypography.body.copyWith(color: Colors.white),
        ),
      );
    }

    return MarkdownBody(
      data: message.content,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: AppTypography.body,
        h1: AppTypography.display.copyWith(fontSize: 24),
        h2: AppTypography.title.copyWith(fontSize: 20),
        h3: AppTypography.title.copyWith(fontSize: 18),
        code: AppTypography.code.copyWith(
          backgroundColor: AppColors.codeBlock,
        ),
        codeblockDecoration: BoxDecoration(
          color: AppColors.codeBlock,
          borderRadius: BorderRadius.circular(14),
        ),
        blockquote: AppTypography.body.copyWith(
          color: AppColors.textSecondary,
        ),
        blockquoteDecoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: AppColors.primary, width: 3),
          ),
        ),
        listBullet: AppTypography.body,
        tableHead: AppTypography.body.copyWith(fontWeight: FontWeight.w700),
        tableBody: AppTypography.body,
        tableBorder: TableBorder.all(color: AppColors.border, width: 1),
        tableCellsPadding: const EdgeInsets.all(8),
      ),
    );
  }
}

class _StreamingCursor extends StatefulWidget {
  @override
  State<_StreamingCursor> createState() => _StreamingCursorState();
}

class _StreamingCursorState extends State<_StreamingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      },
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.isUser,
    this.onEdit,
    this.onRegenerate,
    this.onCopy,
  });

  final bool isUser;
  final VoidCallback? onEdit;
  final VoidCallback? onRegenerate;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onCopy != null)
          IconButtonCustom(
            icon: Icons.copy,
            onTap: onCopy,
            tooltip: 'Copy',
          ),
        if (!isUser && onRegenerate != null) ...[
          const SizedBox(width: 6),
          IconButtonCustom(
            icon: Icons.refresh,
            onTap: onRegenerate,
            tooltip: 'Regenerate',
          ),
        ],
        if (isUser && onEdit != null) ...[
          const SizedBox(width: 6),
          IconButtonCustom(
            icon: Icons.edit,
            onTap: onEdit,
            tooltip: 'Edit',
          ),
        ],
      ],
    );
  }
}
