import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/models/app_settings.dart';
import '../providers/core_providers.dart';
import '../themes/colors.dart';
import '../themes/typography.dart';
import '../widgets/common/glow_button.dart';
import '../widgets/common/icon_button_custom.dart';
import '../widgets/common/surface_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: settingsAsync.when(
        data: (settings) => _SettingsBody(settings: settings),
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
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _AppBar()),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const _SectionTitle(title: 'Appearance'),
              _ThemeSelector(settings: settings),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Chat'),
              _ChatSettings(settings: settings),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'OpenRouter'),
              _OpenRouterSettings(),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Get the app'),
              const _DownloadApkCard(),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Data'),
              _DataManagement(),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.viewPaddingOf(context).top;
    return Container(
      height: 64 + topInset,
      padding: EdgeInsets.only(left: 16, right: 16, top: topInset),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButtonCustom(
            icon: Icons.arrow_back,
            onTap: () => context.pop(),
          ),
          const SizedBox(width: 12),
          Text('Settings', style: AppTypography.title),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: AppTypography.title.copyWith(fontSize: 15)),
    );
  }
}

class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modes = <ThemeMode, String>{
      ThemeMode.system: 'System',
      ThemeMode.light: 'Light',
      ThemeMode.dark: 'Dark',
    };

    return SurfaceCard(
      child: Column(
        children: modes.entries.map((entry) {
          final isSelected = settings.themeMode == entry.key;
          return GestureDetector(
            onTap: () => ref
                .read(settingsProvider.notifier)
                .save(settings.copyWith(themeMode: entry.key)),
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surfaceOverlay : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    entry.key == ThemeMode.system
                        ? Icons.brightness_auto
                        : entry.key == ThemeMode.light
                            ? Icons.light_mode
                            : Icons.dark_mode,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTypography.body,
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ChatSettings extends ConsumerWidget {
  const _ChatSettings({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SwitchTile(
            title: 'Streaming',
            subtitle: 'Receive responses token-by-token',
            value: settings.streamingEnabled,
            onChanged: (value) => ref
                .read(settingsProvider.notifier)
                .save(settings.copyWith(streamingEnabled: value)),
          ),
          _SwitchTile(
            title: 'Artifacts',
            subtitle: 'Show generated files in a panel',
            value: settings.artifactsEnabled,
            onChanged: (value) => ref
                .read(settingsProvider.notifier)
                .save(settings.copyWith(artifactsEnabled: value)),
          ),
          _SwitchTile(
            title: 'Tools',
            subtitle: 'Allow the assistant to invoke tools',
            value: settings.toolsEnabled,
            onChanged: (value) => ref
                .read(settingsProvider.notifier)
                .save(settings.copyWith(toolsEnabled: value)),
          ),
          const SizedBox(height: 12),
          _SliderTile(
            label: 'Temperature',
            value: settings.temperature,
            min: 0,
            max: 2,
            divisions: 40,
            onChanged: (value) => ref
                .read(settingsProvider.notifier)
                .save(settings.copyWith(temperature: value)),
          ),
          _SliderTile(
            label: 'Top P',
            value: settings.topP,
            min: 0,
            max: 1,
            divisions: 20,
            onChanged: (value) => ref
                .read(settingsProvider.notifier)
                .save(settings.copyWith(topP: value)),
          ),
          _SliderTile(
            label: 'Max tokens',
            value: settings.maxTokens.toDouble(),
            min: 256,
            max: 8192,
            divisions: 31,
            displayInteger: true,
            onChanged: (value) => ref
                .read(settingsProvider.notifier)
                .save(settings.copyWith(maxTokens: value.toInt())),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.body),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.displayInteger = false,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final bool displayInteger;

  @override
  Widget build(BuildContext context) {
    final valueText = displayInteger ? value.toInt().toString() : value.toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.body),
              Text(
                valueText,
                style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              thumbColor: AppColors.primary,
              inactiveTrackColor: AppColors.surfaceOverlay,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpenRouterSettings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiKey = ref.watch(apiKeyProvider).valueOrNull;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            apiKey != null && apiKey.isNotEmpty
                ? 'API key is set'
                : 'No API key set',
            style: AppTypography.body,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GlowButton(
                label: 'Test connection',
                icon: const Icon(Icons.check, size: 16, color: Colors.white),
                onPressed: apiKey == null || apiKey.isEmpty
                    ? null
                    : () async {
                        final valid = await ref
                            .read(apiKeyProvider.notifier)
                            .validate(apiKey);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.surfaceRaised,
                              content: Text(
                                valid
                                    ? 'API key is valid'
                                    : 'API key test failed',
                                style: AppTypography.bodySmall,
                              ),
                            ),
                          );
                        }
                      },
              ),
              const SizedBox(width: 10),
              GlowButton(
                label: 'Remove key',
                isPrimary: false,
                onPressed: () async {
                  await ref.read(apiKeyProvider.notifier).deleteApiKey();
                  await ref.read(settingsProvider.notifier).deleteAllData();
                  if (context.mounted) context.go('/onboarding');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DownloadApkCard extends StatelessWidget {
  const _DownloadApkCard();

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceOverlay,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.android,
              color: AppColors.success,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('OpenChat for Android', style: AppTypography.body),
                Text(
                  'Download the APK',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          GlowButton(
            label: 'Download',
            icon: const Icon(Icons.download, size: 16, color: Colors.white),
            onPressed: () {
              final url = Uri.parse(
                'https://test.pascalparent.ca/chat/openchat.apk',
              );
              launchUrl(url, mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
    );
  }
}

class _DataManagement extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All data is stored locally on this device.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GlowButton(
                  label: 'Export',
                  icon: const Icon(Icons.upload, size: 16, color: Colors.white),
                  onPressed: () async {
                    final json = await ref.read(settingsRepositoryProvider).exportData();
                    if (context.mounted) {
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.surfaceRaised,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text('Export data', style: AppTypography.title),
                          content: SizedBox(
                            width: 600,
                            child: SelectableText(
                              json,
                              style: AppTypography.code,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Close', style: AppTypography.bodySmall),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(width: 10),
                GlowButton(
                  label: 'Import',
                  isPrimary: false,
                  onPressed: () => _showImportDialog(context, ref),
                ),
                const SizedBox(width: 10),
                GlowButton(
                  label: 'Delete all',
                  isPrimary: false,
                  onPressed: () => _confirmDeleteAll(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Import data', style: AppTypography.title),
        content: TextField(
          controller: controller,
          maxLines: 10,
          minLines: 6,
          style: AppTypography.code,
          decoration: InputDecoration(
            hintText: 'Paste exported JSON',
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
                      SnackBar(
                        backgroundColor: AppColors.surfaceRaised,
                        content: Text(
                          'Import failed: $e',
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.error),
                        ),
                      ),
                    );
                  }
                }
              }
              if (context.mounted) Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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
        backgroundColor: AppColors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Delete all data?', style: AppTypography.title),
        content: Text(
          'This will remove every conversation, message, and artifact stored on this device. This cannot be undone.',
          style: AppTypography.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: AppTypography.bodySmall),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(settingsProvider.notifier).deleteAllData();
              ref.invalidate(conversationsProvider);
              if (context.mounted) Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
