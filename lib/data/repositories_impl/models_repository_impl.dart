import '../../domain/models/openrouter_model.dart';
import '../../domain/repositories/models_repository.dart';
import '../../services/openrouter/openrouter_api.dart';
import '../local/local_data_source.dart';

class ModelsRepositoryImpl implements ModelsRepository {
  ModelsRepositoryImpl({
    required OpenRouterApi api,
    required HiveJsonDataSource cache,
  }) : _api = api,
       _cache = cache;

  final OpenRouterApi _api;
  final HiveJsonDataSource _cache;

  static const String _favoritesKey = 'favorite_model_ids';
  static const String _cacheTimestampKey = 'models_cache_timestamp';

  @override
  Future<List<OpenRouterModel>> fetchModels({
    required String apiKey,
    bool forceRefresh = false,
  }) async {
    final cachedRaw = await _cache.getAll();
    final cacheTimestamp = await _cache.getById(_cacheTimestampKey);

    final isCacheFresh = cacheTimestamp != null && _isCacheFresh(cacheTimestamp);

    if (!forceRefresh && isCacheFresh) {
      final models = cachedRaw
          .where((json) => json['id'] != null && json.containsKey('name'))
          .map(OpenRouterModel.fromJson)
          .toList();
      if (models.isNotEmpty) return _applyFavorites(models);
    }

    final models = await _api.fetchModels(apiKey: apiKey);
    final entries = <String, Map<String, dynamic>>{};
    for (final model in models) {
      entries[model.id] = model.copyWith(cachedAt: DateTime.now().toUtc()).toJson();
    }
    await _cache.putAll(entries);
    await _cache.put(_cacheTimestampKey, {
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });

    return _applyFavorites(models);
  }

  @override
  Future<void> toggleFavorite(String modelId) async {
    final favorites = await getFavoriteModelIds();
    if (favorites.contains(modelId)) {
      favorites.remove(modelId);
    } else {
      favorites.add(modelId);
    }
    await _cache.put(_favoritesKey, {'ids': favorites});
  }

  @override
  Future<List<String>> getFavoriteModelIds() async {
    final raw = await _cache.getById(_favoritesKey);
    if (raw == null) return <String>[];
    final ids = raw['ids'];
    if (ids is List<dynamic>) {
      return ids.cast<String>();
    }
    return <String>[];
  }

  bool _isCacheFresh(Map<String, dynamic> timestampJson) {
    final timestamp = timestampJson['timestamp'] as String?;
    if (timestamp == null) return false;
    try {
      final cachedAt = DateTime.parse(timestamp);
      return DateTime.now().toUtc().difference(cachedAt).inHours < 24;
    } on FormatException {
      return false;
    }
  }

  Future<List<OpenRouterModel>> _applyFavorites(List<OpenRouterModel> models) async {
    final favorites = await getFavoriteModelIds();
    return models.map((model) {
      return model.copyWith(isFavorite: favorites.contains(model.id));
    }).toList();
  }
}
