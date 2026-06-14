// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openrouter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModelPricingImpl _$$ModelPricingImplFromJson(Map<String, dynamic> json) =>
    _$ModelPricingImpl(
      prompt: (json['prompt'] as num?)?.toDouble() ?? 0.0,
      completion: (json['completion'] as num?)?.toDouble() ?? 0.0,
      request: (json['request'] as num?)?.toDouble() ?? 0.0,
      image: (json['image'] as num?)?.toDouble() ?? 0.0,
      webSearch: (json['webSearch'] as num?)?.toDouble() ?? 0.0,
      internalReasoning: (json['internalReasoning'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$ModelPricingImplToJson(_$ModelPricingImpl instance) =>
    <String, dynamic>{
      'prompt': instance.prompt,
      'completion': instance.completion,
      'request': instance.request,
      'image': instance.image,
      'webSearch': instance.webSearch,
      'internalReasoning': instance.internalReasoning,
    };

_$OpenRouterModelImpl _$$OpenRouterModelImplFromJson(
  Map<String, dynamic> json,
) => _$OpenRouterModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  contextLength: (json['contextLength'] as num?)?.toInt() ?? 0,
  pricing:
      json['pricing'] == null
          ? null
          : ModelPricing.fromJson(json['pricing'] as Map<String, dynamic>),
  supportsVision: json['supportsVision'] as bool? ?? false,
  supportsTools: json['supportsTools'] as bool? ?? false,
  supportsReasoning: json['supportsReasoning'] as bool? ?? false,
  isFavorite: json['isFavorite'] as bool? ?? false,
  cachedAt:
      json['cachedAt'] == null
          ? null
          : DateTime.parse(json['cachedAt'] as String),
);

Map<String, dynamic> _$$OpenRouterModelImplToJson(
  _$OpenRouterModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'contextLength': instance.contextLength,
  'pricing': instance.pricing,
  'supportsVision': instance.supportsVision,
  'supportsTools': instance.supportsTools,
  'supportsReasoning': instance.supportsReasoning,
  'isFavorite': instance.isFavorite,
  'cachedAt': instance.cachedAt?.toIso8601String(),
};
