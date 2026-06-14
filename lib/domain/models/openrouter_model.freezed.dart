// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'openrouter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ModelPricing _$ModelPricingFromJson(Map<String, dynamic> json) {
  return _ModelPricing.fromJson(json);
}

/// @nodoc
mixin _$ModelPricing {
  double get prompt => throw _privateConstructorUsedError;
  double get completion => throw _privateConstructorUsedError;
  double get request => throw _privateConstructorUsedError;
  double get image => throw _privateConstructorUsedError;
  double get webSearch => throw _privateConstructorUsedError;
  double get internalReasoning => throw _privateConstructorUsedError;

  /// Serializes this ModelPricing to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModelPricing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModelPricingCopyWith<ModelPricing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelPricingCopyWith<$Res> {
  factory $ModelPricingCopyWith(
    ModelPricing value,
    $Res Function(ModelPricing) then,
  ) = _$ModelPricingCopyWithImpl<$Res, ModelPricing>;
  @useResult
  $Res call({
    double prompt,
    double completion,
    double request,
    double image,
    double webSearch,
    double internalReasoning,
  });
}

/// @nodoc
class _$ModelPricingCopyWithImpl<$Res, $Val extends ModelPricing>
    implements $ModelPricingCopyWith<$Res> {
  _$ModelPricingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModelPricing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = null,
    Object? completion = null,
    Object? request = null,
    Object? image = null,
    Object? webSearch = null,
    Object? internalReasoning = null,
  }) {
    return _then(
      _value.copyWith(
            prompt:
                null == prompt
                    ? _value.prompt
                    : prompt // ignore: cast_nullable_to_non_nullable
                        as double,
            completion:
                null == completion
                    ? _value.completion
                    : completion // ignore: cast_nullable_to_non_nullable
                        as double,
            request:
                null == request
                    ? _value.request
                    : request // ignore: cast_nullable_to_non_nullable
                        as double,
            image:
                null == image
                    ? _value.image
                    : image // ignore: cast_nullable_to_non_nullable
                        as double,
            webSearch:
                null == webSearch
                    ? _value.webSearch
                    : webSearch // ignore: cast_nullable_to_non_nullable
                        as double,
            internalReasoning:
                null == internalReasoning
                    ? _value.internalReasoning
                    : internalReasoning // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ModelPricingImplCopyWith<$Res>
    implements $ModelPricingCopyWith<$Res> {
  factory _$$ModelPricingImplCopyWith(
    _$ModelPricingImpl value,
    $Res Function(_$ModelPricingImpl) then,
  ) = __$$ModelPricingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double prompt,
    double completion,
    double request,
    double image,
    double webSearch,
    double internalReasoning,
  });
}

/// @nodoc
class __$$ModelPricingImplCopyWithImpl<$Res>
    extends _$ModelPricingCopyWithImpl<$Res, _$ModelPricingImpl>
    implements _$$ModelPricingImplCopyWith<$Res> {
  __$$ModelPricingImplCopyWithImpl(
    _$ModelPricingImpl _value,
    $Res Function(_$ModelPricingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ModelPricing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = null,
    Object? completion = null,
    Object? request = null,
    Object? image = null,
    Object? webSearch = null,
    Object? internalReasoning = null,
  }) {
    return _then(
      _$ModelPricingImpl(
        prompt:
            null == prompt
                ? _value.prompt
                : prompt // ignore: cast_nullable_to_non_nullable
                    as double,
        completion:
            null == completion
                ? _value.completion
                : completion // ignore: cast_nullable_to_non_nullable
                    as double,
        request:
            null == request
                ? _value.request
                : request // ignore: cast_nullable_to_non_nullable
                    as double,
        image:
            null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                    as double,
        webSearch:
            null == webSearch
                ? _value.webSearch
                : webSearch // ignore: cast_nullable_to_non_nullable
                    as double,
        internalReasoning:
            null == internalReasoning
                ? _value.internalReasoning
                : internalReasoning // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ModelPricingImpl implements _ModelPricing {
  const _$ModelPricingImpl({
    this.prompt = 0.0,
    this.completion = 0.0,
    this.request = 0.0,
    this.image = 0.0,
    this.webSearch = 0.0,
    this.internalReasoning = 0.0,
  });

  factory _$ModelPricingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModelPricingImplFromJson(json);

  @override
  @JsonKey()
  final double prompt;
  @override
  @JsonKey()
  final double completion;
  @override
  @JsonKey()
  final double request;
  @override
  @JsonKey()
  final double image;
  @override
  @JsonKey()
  final double webSearch;
  @override
  @JsonKey()
  final double internalReasoning;

  @override
  String toString() {
    return 'ModelPricing(prompt: $prompt, completion: $completion, request: $request, image: $image, webSearch: $webSearch, internalReasoning: $internalReasoning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelPricingImpl &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.completion, completion) ||
                other.completion == completion) &&
            (identical(other.request, request) || other.request == request) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.webSearch, webSearch) ||
                other.webSearch == webSearch) &&
            (identical(other.internalReasoning, internalReasoning) ||
                other.internalReasoning == internalReasoning));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    prompt,
    completion,
    request,
    image,
    webSearch,
    internalReasoning,
  );

  /// Create a copy of ModelPricing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelPricingImplCopyWith<_$ModelPricingImpl> get copyWith =>
      __$$ModelPricingImplCopyWithImpl<_$ModelPricingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModelPricingImplToJson(this);
  }
}

abstract class _ModelPricing implements ModelPricing {
  const factory _ModelPricing({
    final double prompt,
    final double completion,
    final double request,
    final double image,
    final double webSearch,
    final double internalReasoning,
  }) = _$ModelPricingImpl;

  factory _ModelPricing.fromJson(Map<String, dynamic> json) =
      _$ModelPricingImpl.fromJson;

  @override
  double get prompt;
  @override
  double get completion;
  @override
  double get request;
  @override
  double get image;
  @override
  double get webSearch;
  @override
  double get internalReasoning;

  /// Create a copy of ModelPricing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModelPricingImplCopyWith<_$ModelPricingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpenRouterModel _$OpenRouterModelFromJson(Map<String, dynamic> json) {
  return _OpenRouterModel.fromJson(json);
}

/// @nodoc
mixin _$OpenRouterModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get contextLength => throw _privateConstructorUsedError;
  ModelPricing? get pricing => throw _privateConstructorUsedError;
  bool get supportsVision => throw _privateConstructorUsedError;
  bool get supportsTools => throw _privateConstructorUsedError;
  bool get supportsReasoning => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  DateTime? get cachedAt => throw _privateConstructorUsedError;

  /// Serializes this OpenRouterModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenRouterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenRouterModelCopyWith<OpenRouterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenRouterModelCopyWith<$Res> {
  factory $OpenRouterModelCopyWith(
    OpenRouterModel value,
    $Res Function(OpenRouterModel) then,
  ) = _$OpenRouterModelCopyWithImpl<$Res, OpenRouterModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    int contextLength,
    ModelPricing? pricing,
    bool supportsVision,
    bool supportsTools,
    bool supportsReasoning,
    bool isFavorite,
    DateTime? cachedAt,
  });

  $ModelPricingCopyWith<$Res>? get pricing;
}

/// @nodoc
class _$OpenRouterModelCopyWithImpl<$Res, $Val extends OpenRouterModel>
    implements $OpenRouterModelCopyWith<$Res> {
  _$OpenRouterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenRouterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? contextLength = null,
    Object? pricing = freezed,
    Object? supportsVision = null,
    Object? supportsTools = null,
    Object? supportsReasoning = null,
    Object? isFavorite = null,
    Object? cachedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            contextLength:
                null == contextLength
                    ? _value.contextLength
                    : contextLength // ignore: cast_nullable_to_non_nullable
                        as int,
            pricing:
                freezed == pricing
                    ? _value.pricing
                    : pricing // ignore: cast_nullable_to_non_nullable
                        as ModelPricing?,
            supportsVision:
                null == supportsVision
                    ? _value.supportsVision
                    : supportsVision // ignore: cast_nullable_to_non_nullable
                        as bool,
            supportsTools:
                null == supportsTools
                    ? _value.supportsTools
                    : supportsTools // ignore: cast_nullable_to_non_nullable
                        as bool,
            supportsReasoning:
                null == supportsReasoning
                    ? _value.supportsReasoning
                    : supportsReasoning // ignore: cast_nullable_to_non_nullable
                        as bool,
            isFavorite:
                null == isFavorite
                    ? _value.isFavorite
                    : isFavorite // ignore: cast_nullable_to_non_nullable
                        as bool,
            cachedAt:
                freezed == cachedAt
                    ? _value.cachedAt
                    : cachedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of OpenRouterModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ModelPricingCopyWith<$Res>? get pricing {
    if (_value.pricing == null) {
      return null;
    }

    return $ModelPricingCopyWith<$Res>(_value.pricing!, (value) {
      return _then(_value.copyWith(pricing: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OpenRouterModelImplCopyWith<$Res>
    implements $OpenRouterModelCopyWith<$Res> {
  factory _$$OpenRouterModelImplCopyWith(
    _$OpenRouterModelImpl value,
    $Res Function(_$OpenRouterModelImpl) then,
  ) = __$$OpenRouterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    int contextLength,
    ModelPricing? pricing,
    bool supportsVision,
    bool supportsTools,
    bool supportsReasoning,
    bool isFavorite,
    DateTime? cachedAt,
  });

  @override
  $ModelPricingCopyWith<$Res>? get pricing;
}

/// @nodoc
class __$$OpenRouterModelImplCopyWithImpl<$Res>
    extends _$OpenRouterModelCopyWithImpl<$Res, _$OpenRouterModelImpl>
    implements _$$OpenRouterModelImplCopyWith<$Res> {
  __$$OpenRouterModelImplCopyWithImpl(
    _$OpenRouterModelImpl _value,
    $Res Function(_$OpenRouterModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpenRouterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? contextLength = null,
    Object? pricing = freezed,
    Object? supportsVision = null,
    Object? supportsTools = null,
    Object? supportsReasoning = null,
    Object? isFavorite = null,
    Object? cachedAt = freezed,
  }) {
    return _then(
      _$OpenRouterModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        contextLength:
            null == contextLength
                ? _value.contextLength
                : contextLength // ignore: cast_nullable_to_non_nullable
                    as int,
        pricing:
            freezed == pricing
                ? _value.pricing
                : pricing // ignore: cast_nullable_to_non_nullable
                    as ModelPricing?,
        supportsVision:
            null == supportsVision
                ? _value.supportsVision
                : supportsVision // ignore: cast_nullable_to_non_nullable
                    as bool,
        supportsTools:
            null == supportsTools
                ? _value.supportsTools
                : supportsTools // ignore: cast_nullable_to_non_nullable
                    as bool,
        supportsReasoning:
            null == supportsReasoning
                ? _value.supportsReasoning
                : supportsReasoning // ignore: cast_nullable_to_non_nullable
                    as bool,
        isFavorite:
            null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                    as bool,
        cachedAt:
            freezed == cachedAt
                ? _value.cachedAt
                : cachedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenRouterModelImpl extends _OpenRouterModel {
  const _$OpenRouterModelImpl({
    required this.id,
    required this.name,
    this.description,
    this.contextLength = 0,
    this.pricing,
    this.supportsVision = false,
    this.supportsTools = false,
    this.supportsReasoning = false,
    this.isFavorite = false,
    this.cachedAt,
  }) : super._();

  factory _$OpenRouterModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenRouterModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final int contextLength;
  @override
  final ModelPricing? pricing;
  @override
  @JsonKey()
  final bool supportsVision;
  @override
  @JsonKey()
  final bool supportsTools;
  @override
  @JsonKey()
  final bool supportsReasoning;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final DateTime? cachedAt;

  @override
  String toString() {
    return 'OpenRouterModel(id: $id, name: $name, description: $description, contextLength: $contextLength, pricing: $pricing, supportsVision: $supportsVision, supportsTools: $supportsTools, supportsReasoning: $supportsReasoning, isFavorite: $isFavorite, cachedAt: $cachedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenRouterModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.contextLength, contextLength) ||
                other.contextLength == contextLength) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.supportsVision, supportsVision) ||
                other.supportsVision == supportsVision) &&
            (identical(other.supportsTools, supportsTools) ||
                other.supportsTools == supportsTools) &&
            (identical(other.supportsReasoning, supportsReasoning) ||
                other.supportsReasoning == supportsReasoning) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.cachedAt, cachedAt) ||
                other.cachedAt == cachedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    contextLength,
    pricing,
    supportsVision,
    supportsTools,
    supportsReasoning,
    isFavorite,
    cachedAt,
  );

  /// Create a copy of OpenRouterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenRouterModelImplCopyWith<_$OpenRouterModelImpl> get copyWith =>
      __$$OpenRouterModelImplCopyWithImpl<_$OpenRouterModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenRouterModelImplToJson(this);
  }
}

abstract class _OpenRouterModel extends OpenRouterModel {
  const factory _OpenRouterModel({
    required final String id,
    required final String name,
    final String? description,
    final int contextLength,
    final ModelPricing? pricing,
    final bool supportsVision,
    final bool supportsTools,
    final bool supportsReasoning,
    final bool isFavorite,
    final DateTime? cachedAt,
  }) = _$OpenRouterModelImpl;
  const _OpenRouterModel._() : super._();

  factory _OpenRouterModel.fromJson(Map<String, dynamic> json) =
      _$OpenRouterModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  int get contextLength;
  @override
  ModelPricing? get pricing;
  @override
  bool get supportsVision;
  @override
  bool get supportsTools;
  @override
  bool get supportsReasoning;
  @override
  bool get isFavorite;
  @override
  DateTime? get cachedAt;

  /// Create a copy of OpenRouterModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenRouterModelImplCopyWith<_$OpenRouterModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
