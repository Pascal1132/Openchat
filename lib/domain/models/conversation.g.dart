// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      modelId: json['modelId'] as String?,
      modelName: json['modelName'] as String?,
      archived: json['archived'] as bool? ?? false,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
      lastMessagePreview: json['lastMessagePreview'] as String?,
      tokenCountApprox: (json['tokenCountApprox'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'modelId': instance.modelId,
      'modelName': instance.modelName,
      'archived': instance.archived,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'lastMessagePreview': instance.lastMessagePreview,
      'tokenCountApprox': instance.tokenCountApprox,
    };
