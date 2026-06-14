import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/conversation.dart';
import '../providers/core_providers.dart';
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
    final sidebarWidth = isDesktopLayout ? 280.0 : 0.0;

    return Scaffold(
      appBar: isDesktopLayout
          ? null
          : AppBar(
              title: const Text('OpenChat'),
              centerTitle: false,
            ),
      drawer: isDesktopLayout
          ? null
          : _buildSidebarDrawer(context, ref, conversationsAsync),
      body: Row(
        children: [
          if (isDesktopLayout)
            SizedBox(
              width: sidebarWidth,
              child: _buildSidebarContent(context, ref, conversationsAsync),
            ),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _buildSidebarDrawer(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Conversation>> conversationsAsync,
  ) {
    return Drawer(
      child: _buildSidebarContent(context, ref, conversationsAsync),
    );
  }

  Widget _buildSidebarContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Conversation>> conversationsAsync,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        children: [
          _buildNewChatButton(context, ref),
          _buildSearchField(context, ref),
          Expanded(
            child: conversationsAsync.when(
              data: (conversations) => _buildConversationList(context, ref, conversations),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object error, StackTrace stackTrace) => const Center(child: Text('Unable to load conversations')),
            ),
          ),
          const Divider(height: 1),
          _buildFooter(context, ref),
        ],
      ),
    );
  }

  Widget _buildNewChatButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: FilledButton.icon(
        onPressed: () async {
          final created = await ref.read(conversationsProvider.notifier).create();
          ref.read(selectedConversationIdProvider.notifier).state = created.id;
          if (context.mounted && !isDesktop(context)) Navigator.of(context).pop();
          if (context.mounted) context.go('/chat/${created.id}');
        },
        icon: const Icon(Icons.add),
        label: const Text('New chat'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 44),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search chats',
          prefixIcon: const Icon(Icons.search, size: 18),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildConversationList(
    BuildContext context,
    WidgetRef ref,
    List<Conversation> conversations,
  ) {
    final active = conversations.where((c) => !c.archived).toList();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: active.length,
      itemBuilder: (context, index) {
        final conversation = active[index];
        return ConversationTile(
          conversation: conversation,
          isSelected: conversation.id == selectedConversationId,
          onTap: () {
            ref.read(selectedConversationIdProvider.notifier).state = conversation.id;
            if (context.mounted && !isDesktop(context)) {
              Navigator.of(context).pop();
            }
            if (context.mounted) context.go('/chat/${conversation.id}');
          },
          onRename: (newTitle) => ref
              .read(conversationsProvider.notifier)
              .updateConversation(conversation.copyWith(title: newTitle)),
          onDuplicate: () => ref.read(conversationsProvider.notifier).duplicate(conversation.id),
          onArchive: () => ref
              .read(conversationsProvider.notifier)
              .setArchived(conversation.id, !conversation.archived),
          onDelete: () => ref.read(conversationsProvider.notifier).delete(conversation.id),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.auto_awesome),
          title: const Text('Models'),
          dense: true,
          onTap: () {
            if (context.mounted && !isDesktop(context)) Navigator.of(context).pop();
            if (context.mounted) context.push('/models');
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          dense: true,
          onTap: () {
            if (context.mounted && !isDesktop(context)) Navigator.of(context).pop();
            if (context.mounted) context.push('/settings');
          },
        ),
      ],
    );
  }
}
