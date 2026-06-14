import '../models/message.dart';

/// Repository for message CRUD operations within conversations.
abstract class MessageRepository {
  Future<List<Message>> getMessagesForConversation(String conversationId);
  Future<Message?> getMessageById(String id);
  Future<Message> addMessage(Message message);
  Future<void> updateMessage(Message message);
  Future<void> deleteMessage(String id);
  Future<void> deleteMessagesForConversation(String conversationId);
  Future<void> deleteAll();
}
