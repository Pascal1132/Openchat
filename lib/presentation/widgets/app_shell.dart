import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/conversation.dart';
import '../providers/core_providers.dart';
import '../themes/colors.dart';
import '../themes/typography.dart';
import 'common/icon_button_custom.dart';
import 'conversation_tile.dart';
import 'responsive_layout.dart';

class AppShell extends ConsumerWidget {
  const AppShell({
    required this.body,
    required this.selectedConversationId,
    super.key,
  });

  final Widget body;
  final String? selectedConversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final isDesktopLayout = isDesktop(context);

    return Scaffold(
      body: Row(
        children: [
          if (isDesktopLayout)
            SizedBox(
              width: 280,
              child: _Sidebar(
                selectedConversationId: selectedConversationId,
                conversationsAsync: conversationsAsync,
              ),
            ),
          Expanded(child: body),
        ],
      ),
      drawer: isDesktopLayout
          ? null
          : Drawer(
              backgroundColor: AppColors.surface,
              child: _Sidebar(
                selectedConversationId: selectedConversationId,
                conversationsAsync: conversationsAsync,
              ),
            ),
    );
  }
}

class _Sidebar extends ConsumerWidget {
  const _Sidebar({
    required this.selectedConversationId,
    required this.conversationsAsync,
  });

  final String? selectedConversationId;
  final AsyncValue<List<Conversation>> conversationsAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.surface,
      child: SafeArea(
        child: Column(
        children: [
          _buildHeader(context, ref),
          _buildSearch(context, ref),
          Expanded(
            child: conversationsAsync.when(
              data: (conversations) => _buildList(context, ref, conversations),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (Object error, StackTrace stackTrace) => const Center(
                child: Text('Unable to load conversations'),
              ),
            ),
          ),
          _buildFooter(context, ref),
        ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final created = await ref
                    .read(conversationsProvider.notifier)
                    .create();
                ref.read(selectedConversationIdProvider.notifier).state =
                    created.id;
                if (context.mounted) context.go('/chat/${created.id}');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'New chat',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 16,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                style: AppTypography.bodySmall,
                decoration: InputDecoration(
                  hintText: 'Search chats',
                  hintStyle: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  // TODO: implement search filtering.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<Conversation> conversations,
  ) {
    final active = conversations.where((c) => !c.archived).toList();

    if (active.isEmpty) {
      return Center(
        child: Text(
          'No conversations yet',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: active.length,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final conversation = active[index];
        return ConversationTile(
          conversation: conversation,
          isSelected: conversation.id == selectedConversationId,
          onTap: () {
            ref.read(selectedConversationIdProvider.notifier).state =
                conversation.id;
            if (context.mounted && !isDesktop(context)) {
              Navigator.of(context).pop();
            }
            if (context.mounted) context.go('/chat/${conversation.id}');
          },
          onRename: (newTitle) => ref
              .read(conversationsProvider.notifier)
              .updateConversation(conversation.copyWith(title: newTitle)),
          onDuplicate: () => ref
              .read(conversationsProvider.notifier)
              .duplicate(conversation.id),
          onArchive: () => ref
              .read(conversationsProvider.notifier)
              .setArchived(conversation.id, !conversation.archived),
          onDelete: () => ref
              .read(conversationsProvider.notifier)
              .delete(conversation.id),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButtonCustom(
            icon: Icons.auto_awesome,
            onTap: () {
              if (context.mounted && !isDesktop(context)) {
                Navigator.of(context).pop();
              }
              if (context.mounted) context.push('/models');
            },
            tooltip: 'Models',
          ),
          IconButtonCustom(
            icon: Icons.settings,
            onTap: () {
              if (context.mounted && !isDesktop(context)) {
                Navigator.of(context).pop();
              }
              if (context.mounted) context.push('/settings');
            },
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }
}
