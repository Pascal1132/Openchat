import '../../domain/models/artifact.dart';
import '../../domain/repositories/artifact_repository.dart';
import '../local/local_data_source.dart';

class ArtifactRepositoryImpl implements ArtifactRepository {
  const ArtifactRepositoryImpl(this._dataSource);

  final HiveJsonDataSource _dataSource;

  @override
  Future<List<Artifact>> getArtifactsForConversation(String conversationId) async {
    final all = await _dataSource.getAll();
    return all
        .where((json) => (json['conversationId'] as String?) == conversationId)
        .map((json) => Artifact.fromJson(json))
        .toList()
      ..sort((a, b) =>
          (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0)));
  }

  @override
  Future<Artifact?> getArtifactById(String id) async {
    final json = await _dataSource.getById(id);
    if (json == null) return null;
    return Artifact.fromJson(json);
  }

  @override
  Future<Artifact> saveArtifact(Artifact artifact) async {
    final now = DateTime.now().toUtc();
    final stored = artifact.copyWith(
      createdAt: artifact.createdAt ?? now,
      updatedAt: artifact.updatedAt ?? now,
    );
    await _dataSource.put(stored.id, stored.toJson());
    return stored;
  }

  @override
  Future<void> updateArtifact(Artifact artifact) async {
    final updated = artifact.copyWith(
      updatedAt: DateTime.now().toUtc(),
    );
    await _dataSource.put(updated.id, updated.toJson());
  }

  @override
  Future<void> deleteArtifact(String id) async {
    await _dataSource.delete(id);
  }

  @override
  Future<void> deleteArtifactsForConversation(String conversationId) async {
    final artifacts = await getArtifactsForConversation(conversationId);
    for (final artifact in artifacts) {
      await _dataSource.delete(artifact.id);
    }
  }

  @override
  Future<void> deleteAll() async {
    await _dataSource.deleteAll();
  }
}
