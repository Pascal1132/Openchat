import 'package:uuid/uuid.dart';

import '../../domain/models/conversation.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../local/local_data_source.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  const ConversationRepositoryImpl(this._dataSource);

  final HiveJsonDataSource _dataSource;

  @override
  Future<List<Conversation>> getAllConversations() async {
    final data = await _dataSource.getAll();
    return data.map((json) => Conversation.fromJson(json)).toList()
      ..sort((a, b) => (b.updatedAt ?? b.createdAt ?? DateTime(0))
          .compareTo(a.updatedAt ?? a.createdAt ?? DateTime(0)));
  }

  @override
  Future<Conversation?> getConversationById(String id) async {
    final json = await _dataSource.getById(id);
    if (json == null) return null;
    return Conversation.fromJson(json);
  }

  @override
  Future<Conversation> createConversation({
    String? title,
    String? modelId,
    String? modelName,
  }) async {
    final now = DateTime.now().toUtc();
    final conversation = Conversation(
      id: const Uuid().v4(),
      title: title ?? 'New chat',
      modelId: modelId,
      modelName: modelName,
      createdAt: now,
      updatedAt: now,
    );
    await _dataSource.put(conversation.id, conversation.toJson());
    return conversation;
  }

  @override
  Future<void> updateConversation(Conversation conversation) async {
    final updated = conversation.copyWith(
      updatedAt: DateTime.now().toUtc(),
    );
    await _dataSource.put(updated.id, updated.toJson());
  }

  @override
  Future<void> deleteConversation(String id) async {
    await _dataSource.delete(id);
  }

  @override
  Future<void> duplicateConversation(String id) async {
    final original = await getConversationById(id);
    if (original == null) return;
    final now = DateTime.now().toUtc();
    final duplicate = original.copyWith(
      id: const Uuid().v4(),
      title: '${original.title} (copy)',
      createdAt: now,
      updatedAt: now,
    );
    await _dataSource.put(duplicate.id, duplicate.toJson());
  }

  @override
  Future<void> archiveConversation(String id, bool archived) async {
    final conversation = await getConversationById(id);
    if (conversation == null) return;
    await updateConversation(conversation.copyWith(archived: archived));
  }

  @override
  Future<List<Conversation>> searchConversations(String query) async {
    final data = await _dataSource.search(query);
    return data.map((json) => Conversation.fromJson(json)).toList();
  }

  @override
  Future<void> deleteAll() async {
    await _dataSource.deleteAll();
  }
}
