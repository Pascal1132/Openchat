import '../models/artifact.dart';

/// Repository for artifact CRUD operations.
abstract class ArtifactRepository {
  Future<List<Artifact>> getArtifactsForConversation(String conversationId);
  Future<Artifact?> getArtifactById(String id);
  Future<Artifact> saveArtifact(Artifact artifact);
  Future<void> updateArtifact(Artifact artifact);
  Future<void> deleteArtifact(String id);
  Future<void> deleteArtifactsForConversation(String conversationId);
  Future<void> deleteAll();
}
