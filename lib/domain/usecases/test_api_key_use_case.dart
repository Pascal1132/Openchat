import '../../services/openrouter/openrouter_api.dart';

class TestApiKeyUseCase {
  const TestApiKeyUseCase(this._api);

  final OpenRouterApi _api;

  Future<bool> call(String apiKey) async {
    if (apiKey.trim().isEmpty) return false;
    try {
      await _api.fetchModels(apiKey: apiKey);
      return true;
    } on Exception {
      return false;
    }
  }
}
