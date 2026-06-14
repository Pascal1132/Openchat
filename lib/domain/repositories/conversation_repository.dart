import '../models/conversation.dart';

/// Repository for conversation CRUD operations.
abstract class ConversationRepository {
  Future<List<Conversation>> getAllConversations();
  Future<Conversation?> getConversationById(String id);
  Future<Conversation> createConversation({String? title, String? modelId, String? modelName});
  Future<void> updateConversation(Conversation conversation);
  Future<void> deleteConversation(String id);
  Future<void> duplicateConversation(String id);
  Future<void> archiveConversation(String id, bool archived);
  Future<List<Conversation>> searchConversations(String query);
  Future<void> deleteAll();
}
