// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artifact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArtifactImpl _$$ArtifactImplFromJson(Map<String, dynamic> json) =>
    _$ArtifactImpl(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      type: $enumDecode(_$ArtifactTypeEnumMap, json['type']),
      title: json['title'] as String,
      content: json['content'] as String,
      language: json['language'] as String?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
      version: (json['version'] as num?)?.toInt() ?? 1,
      versionHistory:
          (json['versionHistory'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$ArtifactImplToJson(_$ArtifactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'type': _$ArtifactTypeEnumMap[instance.type]!,
      'title': instance.title,
      'content': instance.content,
      'language': instance.language,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'version': instance.version,
      'versionHistory': instance.versionHistory,
    };

const _$ArtifactTypeEnumMap = {
  ArtifactType.code: 'code',
  ArtifactType.markdown: 'markdown',
  ArtifactType.html: 'html',
  ArtifactType.json: 'json',
  ArtifactType.table: 'table',
  ArtifactType.document: 'document',
};
