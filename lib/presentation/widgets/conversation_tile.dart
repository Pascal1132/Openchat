import 'package:flutter/material.dart';

import '../../domain/models/conversation.dart';
import '../themes/colors.dart';
import '../themes/typography.dart';
import 'common/icon_button_custom.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    required this.conversation,
    required this.isSelected,
    this.onTap,
    this.onRename,
    this.onDuplicate,
    this.onArchive,
    this.onDelete,
    super.key,
  });

  final Conversation conversation;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<String>? onRename;
  final VoidCallback? onDuplicate;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.surfaceOverlay : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.4) : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: isSelected ? AppColors.primary : AppColors.textTertiary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.displayTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (conversation.lastMessagePreview != null)
                        Text(
                          conversation.lastMessagePreview!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.label.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
                _MoreMenu(
                  conversation: conversation,
                  onRename: () => _showRenameDialog(context),
                  onDuplicate: onDuplicate,
                  onArchive: onArchive,
                  onDelete: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: conversation.title);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Rename', style: AppTypography.title),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: 'Conversation title',
            hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: AppTypography.bodySmall),
          ),
          FilledButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) onRename?.call(newTitle);
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _MoreMenu extends StatelessWidget {
  const _MoreMenu({
    required this.conversation,
    this.onRename,
    this.onDuplicate,
    this.onArchive,
    this.onDelete,
  });

  final Conversation conversation;
  final VoidCallback? onRename;
  final VoidCallback? onDuplicate;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMenu(context),
      child: const IconButtonCustom(
        icon: Icons.more_vert,
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MenuItem(icon: Icons.edit, label: 'Rename', onTap: onRename),
              _MenuItem(icon: Icons.copy, label: 'Duplicate', onTap: onDuplicate),
              _MenuItem(
                icon: conversation.archived ? Icons.unarchive : Icons.archive,
                label: conversation.archived ? 'Unarchive' : 'Archive',
                onTap: onArchive,
              ),
              _MenuItem(
                icon: Icons.delete_outline,
                label: 'Delete',
                color: AppColors.error,
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary),
      title: Text(
        label,
        style: AppTypography.body.copyWith(
          color: color ?? AppColors.textPrimary,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        onTap?.call();
      },
    );
  }
}
