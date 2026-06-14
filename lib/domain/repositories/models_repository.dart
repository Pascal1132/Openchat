import '../models/openrouter_model.dart';

/// Repository for OpenRouter models.
abstract class ModelsRepository {
  Future<List<OpenRouterModel>> fetchModels({required String apiKey, bool forceRefresh = false});
  Future<void> toggleFavorite(String modelId);
  Future<List<String>> getFavoriteModelIds();
}
