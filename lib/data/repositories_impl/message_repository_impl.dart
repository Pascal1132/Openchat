import '../../domain/models/message.dart';
import '../../domain/repositories/message_repository.dart';
import '../local/local_data_source.dart';

class MessageRepositoryImpl implements MessageRepository {
  const MessageRepositoryImpl(this._dataSource);

  final HiveJsonDataSource _dataSource;

  @override
  Future<List<Message>> getMessagesForConversation(String conversationId) async {
    final all = await _dataSource.getAll();
    return all
        .where((json) => (json['conversationId'] as String?) == conversationId)
        .map((json) => Message.fromJson(json))
        .toList()
      ..sort((a, b) =>
          (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0)));
  }

  @override
  Future<Message?> getMessageById(String id) async {
    final json = await _dataSource.getById(id);
    if (json == null) return null;
    return Message.fromJson(json);
  }

  @override
  Future<Message> addMessage(Message message) async {
    final now = DateTime.now().toUtc();
    final stored = message.copyWith(
      createdAt: message.createdAt ?? now,
      updatedAt: message.updatedAt ?? now,
    );
    await _dataSource.put(stored.id, stored.toJson());
    return stored;
  }

  @override
  Future<void> updateMessage(Message message) async {
    final updated = message.copyWith(updatedAt: DateTime.now().toUtc());
    await _dataSource.put(updated.id, updated.toJson());
  }

  @override
  Future<void> deleteMessage(String id) async {
    await _dataSource.delete(id);
  }

  @override
  Future<void> deleteMessagesForConversation(String conversationId) async {
    final messages = await getMessagesForConversation(conversationId);
    for (final msg in messages) {
      await _dataSource.delete(msg.id);
    }
  }

  @override
  Future<void> deleteAll() async {
    await _dataSource.deleteAll();
  }
}
