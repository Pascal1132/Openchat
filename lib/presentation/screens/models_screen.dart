import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/openrouter_model.dart';
import '../providers/core_providers.dart';
import '../themes/colors.dart';
import '../themes/typography.dart';
import '../widgets/common/icon_button_custom.dart';
import '../widgets/common/surface_card.dart';

class ModelsScreen extends ConsumerStatefulWidget {
  const ModelsScreen({super.key});

  @override
  ConsumerState<ModelsScreen> createState() => _ModelsScreenState();
}

class _ModelsScreenState extends ConsumerState<ModelsScreen> {
  String _query = '';
  _SortMode _sortMode = _SortMode.name;

  @override
  Widget build(BuildContext context) {
    final apiKey = ref.watch(apiKeyProvider).valueOrNull ?? '';
    final modelsAsync = ref.watch(modelsProvider(apiKey));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(context, apiKey),
          Expanded(
            child: modelsAsync.when(
              data: (models) => _buildModelList(context, _filterAndSort(models)),
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
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, String apiKey) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          Text('Models', style: AppTypography.title),
          const Spacer(),
          IconButtonCustom(
            icon: Icons.refresh,
            onTap: () => ref.read(modelsProvider(apiKey).notifier).refresh(apiKey),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  List<OpenRouterModel> _filterAndSort(List<OpenRouterModel> models) {
    final filtered = models.where((model) {
      return model.displayName.toLowerCase().contains(_query) ||
          (model.description?.toLowerCase().contains(_query) ?? false);
    }).toList();

    switch (_sortMode) {
      case _SortMode.name:
        filtered.sort((a, b) => a.displayName.compareTo(b.displayName));
      case _SortMode.price:
        filtered.sort((a, b) {
          final aPrice = a.pricing?.completion ?? 0.0;
          final bPrice = b.pricing?.completion ?? 0.0;
          return aPrice.compareTo(bPrice);
        });
    }

    return filtered;
  }

  Widget _buildModelList(BuildContext context, List<OpenRouterModel> models) {
    return Column(
      children: [
        _buildFilters(context),
        Expanded(
          child: models.isEmpty
              ? Center(
                  child: Text(
                    'No models found.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: models.length,
                  itemBuilder: (context, index) {
                    final model = models[index];
                    return _ModelCard(
                      apiKey: ref.watch(apiKeyProvider).valueOrNull ?? '',
                      model: model,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceRaised,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 18, color: AppColors.textTertiary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: AppTypography.body,
                      decoration: InputDecoration(
                        hintText: 'Search models',
                        hintStyle: AppTypography.body.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onChanged: (value) =>
                          setState(() => _query = value.toLowerCase()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<_SortMode>(
                value: _sortMode,
                dropdownColor: AppColors.surfaceRaised,
                style: AppTypography.bodySmall,
                icon: const Icon(Icons.sort, size: 18, color: AppColors.textSecondary),
                onChanged: (value) {
                  if (value != null) setState(() => _sortMode = value);
                },
                items: _SortMode.values.map((mode) {
                  return DropdownMenuItem<_SortMode>(
                    value: mode,
                    child: Text(
                      mode.name.capitalize(),
                      style: AppTypography.bodySmall,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _SortMode { name, price }

extension _StringX on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

class _ModelCard extends ConsumerWidget {
  const _ModelCard({required this.apiKey, required this.model});

  final String apiKey;
  final OpenRouterModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  model.displayName,
                  style: AppTypography.title.copyWith(fontSize: 15),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref
                      .read(modelsProvider(apiKey).notifier)
                      .toggleFavorite(model.id);
                },
                child: Icon(
                  model.isFavorite ? Icons.star : Icons.star_border,
                  size: 20,
                  color: model.isFavorite ? AppColors.accent : AppColors.textTertiary,
                ),
              ),
            ],
          ),
          if (model.description != null && model.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                model.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall,
              ),
            ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (model.contextLength > 0)
                _Tag(label: '${model.contextLength} ctx'),
              if (model.pricing != null) ...[
                _Tag(label: '\$${_format(model.pricing!.prompt)}/1M in'),
                _Tag(label: '\$${_format(model.pricing!.completion)}/1M out'),
              ],
              if (model.supportsVision) const _Tag(label: 'Vision'),
              if (model.supportsTools) const _Tag(label: 'Tools'),
              if (model.supportsReasoning) const _Tag(label: 'Reasoning'),
            ],
          ),
        ],
      ),
    );
  }

  String _format(double value) {
    if (value == 0.0) return '0';
    if (value < 0.01) return value.toStringAsFixed(4);
    return value.toStringAsFixed(3);
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(fontSize: 10),
      ),
    );
  }
}
