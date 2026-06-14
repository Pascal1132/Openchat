import 'package:freezed_annotation/freezed_annotation.dart';

part 'artifact.freezed.dart';
part 'artifact.g.dart';

/// Supported artifact types.
enum ArtifactType {
  code,
  markdown,
  html,
  json,
  table,
  document,
}

/// An artifact produced by the assistant within a conversation.
@freezed
class Artifact with _$Artifact {
  const factory Artifact({
    required String id,
    required String conversationId,
    required ArtifactType type,
    required String title,
    required String content,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(1) int version,
    @Default(<String>[]) List<String> versionHistory,
  }) = _Artifact;

  factory Artifact.fromJson(Map<String, dynamic> json) =>
      _$ArtifactFromJson(json);

  const Artifact._();

  /// Returns an updated artifact with a new version appended to history.
  Artifact updateContent(String newContent) {
    final now = DateTime.now().toUtc();
    final newVersion = version + 1;
    return copyWith(
      content: newContent,
      updatedAt: now,
      version: newVersion,
      versionHistory: [...versionHistory, content],
    );
  }
}
