import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ignore_for_file: deprecated_member_use

import '../../domain/models/app_settings.dart';
import '../providers/core_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: settingsAsync.when(
        data: (settings) => _SettingsBody(settings: settings),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _SettingsBody extends ConsumerWidget {
  const _SettingsBody({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _SectionTitle(title: 'Appearance'),
        _ThemeSelector(settings: settings),
        const SizedBox(height: 24),
        const _SectionTitle(title: 'Chat'),
        _ChatSettings(settings: settings),
        const SizedBox(height: 24),
        const _SectionTitle(title: 'OpenRouter'),
        _OpenRouterSettings(),
        const SizedBox(height: 24),
        const _SectionTitle(title: 'Data'),
        _DataManagement(),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            value: ThemeMode.system,
            groupValue: settings.themeMode,
            onChanged: (value) => _update(ref, value!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: settings.themeMode,
            onChanged: (value) => _update(ref, value!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: settings.themeMode,
            onChanged: (value) => _update(ref, value!),
          ),
        ],
      ),
    );
  }

  void _update(WidgetRef ref, ThemeMode mode) {
    ref.read(settingsProvider.notifier).save(settings.copyWith(themeMode: mode));
  }
}

class _ChatSettings extends ConsumerWidget {
  const _ChatSettings({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Streaming'),
              subtitle: const Text('Receive responses token-by-token'),
              value: settings.streamingEnabled,
              onChanged: (value) => ref
                  .read(settingsProvider.notifier)
                  .save(settings.copyWith(streamingEnabled: value)),
            ),
            SwitchListTile(
              title: const Text('Artifacts'),
              subtitle: const Text('Show generated files in a side panel'),
              value: settings.artifactsEnabled,
              onChanged: (value) => ref
                  .read(settingsProvider.notifier)
                  .save(settings.copyWith(artifactsEnabled: value)),
            ),
            SwitchListTile(
              title: const Text('Tools'),
              subtitle: const Text('Allow the assistant to invoke tools'),
              value: settings.toolsEnabled,
              onChanged: (value) => ref
                  .read(settingsProvider.notifier)
                  .save(settings.copyWith(toolsEnabled: value)),
            ),
            const SizedBox(height: 16),
            Text('Temperature: ${settings.temperature.toStringAsFixed(2)}'),
            Slider(
              value: settings.temperature,
              min: 0,
              max: 2,
              divisions: 40,
              label: settings.temperature.toStringAsFixed(2),
              onChanged: (value) => ref
                  .read(settingsProvider.notifier)
                  .save(settings.copyWith(temperature: value)),
            ),
            Text('Top P: ${settings.topP.toStringAsFixed(2)}'),
            Slider(
              value: settings.topP,
              min: 0,
              max: 1,
              divisions: 20,
              label: settings.topP.toStringAsFixed(2),
              onChanged: (value) => ref
                  .read(settingsProvider.notifier)
                  .save(settings.copyWith(topP: value)),
            ),
            Text('Max tokens: ${settings.maxTokens}'),
            Slider(
              value: settings.maxTokens.toDouble(),
              min: 256,
              max: 8192,
              divisions: 31,
              label: settings.maxTokens.toString(),
              onChanged: (value) => ref
                  .read(settingsProvider.notifier)
                  .save(settings.copyWith(maxTokens: value.toInt())),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpenRouterSettings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiKey = ref.watch(apiKeyProvider).valueOrNull;
    final isTesting = ref.watch(chatSendStateProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (apiKey != null && apiKey.isNotEmpty)
              Text(
                'API key is set (${apiKey.substring(0, apiKey.length.clamp(0, 8))}•••)',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              const Text('No API key set'),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: isTesting
                      ? null
                      : () async {
                          if (apiKey == null || apiKey.isEmpty) return;
                          final valid = await ref
                              .read(apiKeyProvider.notifier)
                              .validate(apiKey);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(valid
                                    ? 'API key is valid'
                                    : 'API key test failed'),
                              ),
                            );
                          }
                        },
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Test connection'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(apiKeyProvider.notifier).deleteApiKey();
                    await ref.read(settingsProvider.notifier).deleteAllData();
                    if (context.mounted) context.go('/onboarding');
                  },
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Remove key & data'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DataManagement extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All conversations, messages, and artifacts are stored locally.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    final json = await ref
                        .read(settingsRepositoryProvider)
                        .exportData();
                    if (context.mounted) {
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Export data'),
                          content: SelectableText(json),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.upload, size: 16),
                  label: const Text('Export'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    _showImportDialog(context, ref);
                  },
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Import'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _confirmDeleteAll(context, ref),
                  icon: const Icon(Icons.delete_forever, size: 16),
                  label: const Text('Delete all'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import data'),
        content: TextField(
          controller: controller,
          maxLines: 8,
          minLines: 4,
          decoration: const InputDecoration(
            hintText: 'Paste exported JSON here',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final json = controller.text.trim();
              if (json.isNotEmpty) {
                try {
                  await ref.read(settingsRepositoryProvider).importData(json);
                  ref.invalidate(conversationsProvider);
                  ref.invalidate(settingsProvider);
                } on Exception catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Import failed: $e')),
                    );
                  }
                }
              }
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete all local data?'),
        content: const Text(
          'This will remove every conversation, message, and artifact stored on this device. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(settingsProvider.notifier).deleteAllData();
              ref.invalidate(conversationsProvider);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
