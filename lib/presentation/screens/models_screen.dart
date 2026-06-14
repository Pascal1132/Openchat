import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/openrouter_model.dart';
import '../providers/core_providers.dart';

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
      appBar: AppBar(
        title: const Text('Models'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh models',
            onPressed: () => ref.read(modelsProvider(apiKey).notifier).refresh(apiKey),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndSortBar(context),
          Expanded(
            child: modelsAsync.when(
              data: (models) => _buildModelList(context, apiKey, _filterAndSort(models)),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndSortBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search models',
                prefixIcon: Icon(Icons.search, size: 18),
              ),
              onChanged: (value) => setState(() => _query = value.toLowerCase()),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<_SortMode>(
            value: _sortMode,
            underline: const SizedBox.shrink(),
            onChanged: (value) {
              if (value != null) setState(() => _sortMode = value);
            },
            items: const [
              DropdownMenuItem(value: _SortMode.name, child: Text('Name')),
              DropdownMenuItem(value: _SortMode.price, child: Text('Price')),
            ],
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

  Widget _buildModelList(BuildContext context, String apiKey, List<OpenRouterModel> models) {
    if (models.isEmpty) {
      return const Center(child: Text('No models found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: models.length,
      itemBuilder: (context, index) {
        final model = models[index];
        return _ModelCard(
          apiKey: apiKey,
          model: model,
        );
      },
    );
  }
}

enum _SortMode { name, price }

class _ModelCard extends ConsumerWidget {
  const _ModelCard({
    required this.apiKey,
    required this.model,
  });

  final String apiKey;
  final OpenRouterModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected ${model.displayName}')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      model.displayName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      model.isFavorite ? Icons.star : Icons.star_border,
                      size: 20,
                      color: model.isFavorite ? Colors.amber : null,
                    ),
                    onPressed: () {
                      ref.read(modelsProvider(apiKey).notifier).toggleFavorite(model.id);
                    },
                  ),
                ],
              ),
              if (model.description != null && model.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    model.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  if (model.contextLength > 0)
                    _Chip(label: '${model.contextLength} ctx'),
                  if (model.pricing != null) ...[
                    _Chip(label: '\$${_format(model.pricing!.prompt)}/1M in'),
                    _Chip(label: '\$${_format(model.pricing!.completion)}/1M out'),
                  ],
                  if (model.supportsVision) const _Chip(label: 'Vision'),
                  if (model.supportsTools) const _Chip(label: 'Tools'),
                  if (model.supportsReasoning) const _Chip(label: 'Reasoning'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _format(double value) {
    if (value == 0.0) return '0';
    if (value < 0.01) return value.toStringAsFixed(4);
    return value.toStringAsFixed(3);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
