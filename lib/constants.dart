/// Application-wide constants.
library;

/// OpenRouter API configuration.
abstract final class OpenRouterConstants {
  static const String baseUrl = 'https://openrouter.ai/api';
  static const String modelsEndpoint = '/v1/models';
  static const String chatCompletionsEndpoint = '/v1/chat/completions';

  /// Sent with every request so OpenRouter can identify the app.
  static const String appName = 'OpenChat';
  static const String appUrl = 'https://test.pascalparent.ca/chat';
}

/// Storage keys and box names.
abstract final class StorageKeys {
  static const String apiKey = 'openrouter_api_key';

  static const String conversationsBox = 'conversations';
  static const String messagesBox = 'messages';
  static const String artifactsBox = 'artifacts';
  static const String settingsBox = 'settings';
  static const String modelsCacheBox = 'models_cache';
}

/// Default chat inference parameters.
abstract final class Defaults {
  static const double temperature = 0.7;
  static const double topP = 0.95;
  static const int maxTokens = 2048;
  static const bool streamingEnabled = true;
  static const bool artifactsEnabled = true;
  static const bool toolsEnabled = false;
}

/// UI breakpoints.
abstract final class Breakpoints {
  static const double mobile = 700;
  static const double tablet = 1200;
}
