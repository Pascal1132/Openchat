import 'package:freezed_annotation/freezed_annotation.dart';

part 'openrouter_model.freezed.dart';
part 'openrouter_model.g.dart';

/// Pricing information for a model.
@freezed
class ModelPricing with _$ModelPricing {
  const factory ModelPricing({
    @Default(0.0) double prompt,
    @Default(0.0) double completion,
    @Default(0.0) double request,
    @Default(0.0) double image,
    @Default(0.0) double webSearch,
    @Default(0.0) double internalReasoning,
  }) = _ModelPricing;

  factory ModelPricing.fromJson(Map<String, dynamic> json) =>
      _$ModelPricingFromJson(json);
}

/// A model exposed by OpenRouter.
@freezed
class OpenRouterModel with _$OpenRouterModel {
  const factory OpenRouterModel({
    required String id,
    required String name,
    String? description,
    @Default(0) int contextLength,
    ModelPricing? pricing,
    @Default(false) bool supportsVision,
    @Default(false) bool supportsTools,
    @Default(false) bool supportsReasoning,
    @Default(false) bool isFavorite,
    DateTime? cachedAt,
  }) = _OpenRouterModel;

  factory OpenRouterModel.fromJson(Map<String, dynamic> json) =>
      _$OpenRouterModelFromJson(json);

  const OpenRouterModel._();

  String get displayName => name.isEmpty ? id : name;
}
