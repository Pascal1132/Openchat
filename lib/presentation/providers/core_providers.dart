import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../artifacts/artifact_parser.dart';
import '../../data/local/local_data_source.dart';
import '../../data/repositories_impl/artifact_repository_impl.dart';
import '../../data/repositories_impl/convers_repository_impl.dart';
import '../../data/repositories_impl/message_repository_impl.dart';
import '../../data/repositories_impl/models_repository_impl.dart';
import '../../data/repositories_impl/secure_storage_repository_impl.dart';
import '../../data/repositories_impl/settings_repository_impl.dart';
import '../../domain/models/app_settings.dart';
import '../../domain/models/artifact.dart';
import '../../domain/models/conversation.dart';
import '../../domain/models/message.dart';
import '../../domain/models/openrouter_model.dart';
import '../../domain/repositories/artifact_repository.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../../domain/repositories/message_repository.dart';
import '../../domain/repositories/models_repository.dart';
import '../../domain/repositories/secure_storage_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/send_message_use_case.dart';
import '../../domain/usecases/test_api_key_use_case.dart';
import '../../services/openrouter/openrouter_api.dart';
import '../../services/secure_storage_service.dart';
import '../../tools/tool_executor.dart';
import '../../tools/tool_registry.dart';

// ---------------------------------------------------------------------------
// Low-level services
// ---------------------------------------------------------------------------

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final secureStorageServiceProvider = Provider<SecureStorageService>(
  (ref) => const SecureStorageService(),
);

final secureStorageRepositoryProvider = Provider<SecureStorageRepository>(
  (ref) => SecureStorageRepositoryImpl(ref.watch(secureStorageServiceProvider)),
);

final openRouterApiProvider = Provider<OpenRouterApi>(
  (ref) => OpenRouterApi(client: ref.watch(httpClientProvider)),
);

final artifactParserProvider = Provider<ArtifactParser>(
  (ref) => ArtifactParser(),
);

final toolRegistryProvider = Provider<ToolRegistry>(
  (ref) => ToolRegistry(),
);

final toolExecutorProvider = Provider<ToolExecutor>(
  (ref) => ToolExecutor(ref.watch(toolRegistryProvider)),
);

// ---------------------------------------------------------------------------
// Repositories
// ---------------------------------------------------------------------------

final conversationRepositoryProvider = Provider<ConversationRepository>(
  (ref) => ConversationRepositoryImpl(LocalDatabase.conversations),
);

final messageRepositoryProvider = Provider<MessageRepository>(
  (ref) => MessageRepositoryImpl(LocalDatabase.messages),
);

final artifactRepositoryProvider = Provider<ArtifactRepository>(
  (ref) => ArtifactRepositoryImpl(LocalDatabase.artifacts),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(
    settingsDataSource: LocalDatabase.settings,
    conversationsDataSource: LocalDatabase.conversations,
    messagesDataSource: LocalDatabase.messages,
    artifactsDataSource: LocalDatabase.artifacts,
  ),
);

final modelsRepositoryProvider = Provider<ModelsRepository>(
  (ref) => ModelsRepositoryImpl(
    api: ref.watch(openRouterApiProvider),
    cache: LocalDatabase.modelsCache,
  ),
);

// ---------------------------------------------------------------------------
// Use cases
// ---------------------------------------------------------------------------

final testApiKeyUseCaseProvider = Provider<TestApiKeyUseCase>(
  (ref) => TestApiKeyUseCase(ref.watch(openRouterApiProvider)),
);

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>(
  (ref) => SendMessageUseCase(
    api: ref.watch(openRouterApiProvider),
    messageRepository: ref.watch(messageRepositoryProvider),
    conversationRepository: ref.watch(conversationRepositoryProvider),
    artifactRepository: ref.watch(artifactRepositoryProvider),
    artifactParser: ref.watch(artifactParserProvider),
  ),
);

// ---------------------------------------------------------------------------
// State providers
// ---------------------------------------------------------------------------

/// API key state.
final apiKeyProvider = AsyncNotifierProvider<ApiKeyNotifier, String?>(
  ApiKeyNotifier.new,
);

class ApiKeyNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    return ref.watch(secureStorageRepositoryProvider).getApiKey();
  }

  Future<void> setApiKey(String apiKey) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(secureStorageRepositoryProvider).setApiKey(apiKey);
      state = AsyncValue.data(apiKey);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteApiKey() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(secureStorageRepositoryProvider).deleteApiKey();
      state = const AsyncValue.data(null);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> validate(String apiKey) async {
    return ref.read(testApiKeyUseCaseProvider).call(apiKey);
  }
}

/// Conversations list.
final conversationsProvider = AsyncNotifierProvider<ConversationsNotifier, List<Conversation>>(
  ConversationsNotifier.new,
);

class ConversationsNotifier extends AsyncNotifier<List<Conversation>> {
  @override
  Future<List<Conversation>> build() async {
    return ref.watch(conversationRepositoryProvider).getAllConversations();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(conversationRepositoryProvider).getAllConversations(),
    );
  }

  Future<Conversation> create({String? title, String? modelId, String? modelName}) async {
    final created = await ref.read(conversationRepositoryProvider).createConversation(
          title: title,
          modelId: modelId,
          modelName: modelName,
        );
    await refresh();
    return created;
  }

  Future<void> updateConversation(Conversation conversation) async {
    await ref.read(conversationRepositoryProvider).updateConversation(conversation);
    await refresh();
  }

  Future<void> delete(String id) async {
    await ref.read(conversationRepositoryProvider).deleteConversation(id);
    await ref.read(messageRepositoryProvider).deleteMessagesForConversation(id);
    await ref.read(artifactRepositoryProvider).deleteArtifactsForConversation(id);
    await refresh();
  }

  Future<void> duplicate(String id) async {
    await ref.read(conversationRepositoryProvider).duplicateConversation(id);
    await refresh();
  }

  Future<void> setArchived(String id, bool archived) async {
    await ref.read(conversationRepositoryProvider).archiveConversation(id, archived);
    await refresh();
  }
}

/// Selected conversation id.
final selectedConversationIdProvider = StateProvider<String?>((ref) => null);

/// Currently selected conversation details.
final currentConversationProvider = Provider<AsyncValue<Conversation?>>((ref) {
  final id = ref.watch(selectedConversationIdProvider);
  if (id == null) return const AsyncValue.data(null);
  return ref.watch(conversationProvider(id));
});

final conversationProvider = FutureProvider.family<Conversation?, String>(
  (ref, id) => ref.watch(conversationRepositoryProvider).getConversationById(id),
);

/// Messages for the selected conversation.
final currentMessagesProvider = Provider<AsyncValue<List<Message>>>((ref) {
  final id = ref.watch(selectedConversationIdProvider);
  if (id == null) return const AsyncValue.data(<Message>[]);
  return ref.watch(messagesProvider(id));
});

final messagesProvider = StreamProvider.family<List<Message>, String>(
  (ref, conversationId) async* {
    final repo = ref.watch(messageRepositoryProvider);
    // Poll lightly: messages change when we persist; this provider is rebuilt
    // by the notifier after sending a message.
    yield await repo.getMessagesForConversation(conversationId);
  },
);

class MessageNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  MessageNotifier(this._repository) : super(const AsyncValue.data(<Message>[]));

  final MessageRepository _repository;

  Future<void> load(String conversationId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.getMessagesForConversation(conversationId),
    );
  }

  Future<void> updateMessage(Message message) async {
    await _repository.updateMessage(message);
    final conversationId = message.conversationId;
    state = await AsyncValue.guard(
      () => _repository.getMessagesForConversation(conversationId),
    );
  }
}

/// Artifacts for the selected conversation.
final currentArtifactsProvider = Provider<AsyncValue<List<Artifact>>>((ref) {
  final id = ref.watch(selectedConversationIdProvider);
  if (id == null) return const AsyncValue.data(<Artifact>[]);
  return ref.watch(artifactsProvider(id));
});

final artifactsProvider = StreamProvider.family<List<Artifact>, String>(
  (ref, conversationId) async* {
    final repo = ref.watch(artifactRepositoryProvider);
    yield await repo.getArtifactsForConversation(conversationId);
  },
);

class ArtifactsNotifier extends StateNotifier<AsyncValue<List<Artifact>>> {
  ArtifactsNotifier(this._repository) : super(const AsyncValue.data(<Artifact>[]));

  final ArtifactRepository _repository;

  Future<void> load(String conversationId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.getArtifactsForConversation(conversationId),
    );
  }
}

/// App settings.
final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    return ref.watch(settingsRepositoryProvider).getSettings();
  }

  Future<void> save(AppSettings settings) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(settingsRepositoryProvider).saveSettings(settings);
      state = AsyncValue.data(settings);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> reset() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(settingsRepositoryProvider).resetSettings();
      state = const AsyncValue.data(AppSettings.defaults);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAllData() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(settingsRepositoryProvider).deleteAllLocalData();
      state = const AsyncValue.data(AppSettings.defaults);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Theme mode derived from settings.
final themeModeProvider = Provider<ThemeMode>((ref) {
  final settingsAsync = ref.watch(settingsProvider);
  return settingsAsync.valueOrNull?.themeMode ?? ThemeMode.system;
});

/// OpenRouter models.
final modelsProvider = AsyncNotifierProviderFamily<ModelsNotifier, List<OpenRouterModel>, String?>(
  ModelsNotifier.new,
);

class ModelsNotifier extends FamilyAsyncNotifier<List<OpenRouterModel>, String?> {
  @override
  Future<List<OpenRouterModel>> build(String? arg) async {
    final apiKey = arg;
    if (apiKey == null || apiKey.isEmpty) return <OpenRouterModel>[];
    return ref.read(modelsRepositoryProvider).fetchModels(apiKey: apiKey);
  }

  Future<void> refresh(String apiKey) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(modelsRepositoryProvider).fetchModels(
            apiKey: apiKey,
            forceRefresh: true,
          ),
    );
  }

  Future<void> toggleFavorite(String modelId) async {
    await ref.read(modelsRepositoryProvider).toggleFavorite(modelId);
    state = await AsyncValue.guard(
      () => ref.read(modelsRepositoryProvider).fetchModels(
            apiKey: arg ?? '',
            forceRefresh: false,
          ),
    );
  }
}

/// Chat send state.
final chatSendStateProvider = StateProvider<bool>((ref) => false);
final streamingMessageProvider = StateProvider<Message?>((ref) => null);

/// Controller for cancelling ongoing generation.
class ChatGenerationController extends ChangeNotifier {
  bool _cancelled = false;

  bool get isCancelled => _cancelled;

  void cancel() {
    _cancelled = true;
    notifyListeners();
  }

  void reset() {
    _cancelled = false;
    notifyListeners();
  }
}

final chatGenerationControllerProvider = ChangeNotifierProvider<ChatGenerationController>(
  (ref) => ChatGenerationController(),
);
