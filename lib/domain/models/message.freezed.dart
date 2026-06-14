// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String get id => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  MessageRole get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Whether this message is still streaming from the API.
  bool get isStreaming => throw _privateConstructorUsedError;

  /// IDs of artifacts attached to this assistant message.
  List<String> get artifactIds => throw _privateConstructorUsedError;

  /// Tool call payload for assistant messages proposing tool usage.
  Map<String, dynamic>? get toolCalls => throw _privateConstructorUsedError;

  /// Tool result payload for tool-role messages.
  Map<String, dynamic>? get toolResult => throw _privateConstructorUsedError;

  /// Approximate token count for this message.
  int? get tokenCountApprox => throw _privateConstructorUsedError;

  /// Id of the model that generated this (assistant) message.
  String? get modelId => throw _privateConstructorUsedError;

  /// Human-readable name of the model that generated this message.
  String? get modelName => throw _privateConstructorUsedError;

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call({
    String id,
    String conversationId,
    MessageRole role,
    String content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isStreaming,
    List<String> artifactIds,
    Map<String, dynamic>? toolCalls,
    Map<String, dynamic>? toolResult,
    int? tokenCountApprox,
    String? modelId,
    String? modelName,
  });
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isStreaming = null,
    Object? artifactIds = null,
    Object? toolCalls = freezed,
    Object? toolResult = freezed,
    Object? tokenCountApprox = freezed,
    Object? modelId = freezed,
    Object? modelName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            conversationId:
                null == conversationId
                    ? _value.conversationId
                    : conversationId // ignore: cast_nullable_to_non_nullable
                        as String,
            role:
                null == role
                    ? _value.role
                    : role // ignore: cast_nullable_to_non_nullable
                        as MessageRole,
            content:
                null == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as String,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            isStreaming:
                null == isStreaming
                    ? _value.isStreaming
                    : isStreaming // ignore: cast_nullable_to_non_nullable
                        as bool,
            artifactIds:
                null == artifactIds
                    ? _value.artifactIds
                    : artifactIds // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            toolCalls:
                freezed == toolCalls
                    ? _value.toolCalls
                    : toolCalls // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            toolResult:
                freezed == toolResult
                    ? _value.toolResult
                    : toolResult // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            tokenCountApprox:
                freezed == tokenCountApprox
                    ? _value.tokenCountApprox
                    : tokenCountApprox // ignore: cast_nullable_to_non_nullable
                        as int?,
            modelId:
                freezed == modelId
                    ? _value.modelId
                    : modelId // ignore: cast_nullable_to_non_nullable
                        as String?,
            modelName:
                freezed == modelName
                    ? _value.modelName
                    : modelName // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
    _$MessageImpl value,
    $Res Function(_$MessageImpl) then,
  ) = __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String conversationId,
    MessageRole role,
    String content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isStreaming,
    List<String> artifactIds,
    Map<String, dynamic>? toolCalls,
    Map<String, dynamic>? toolResult,
    int? tokenCountApprox,
    String? modelId,
    String? modelName,
  });
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
    _$MessageImpl _value,
    $Res Function(_$MessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isStreaming = null,
    Object? artifactIds = null,
    Object? toolCalls = freezed,
    Object? toolResult = freezed,
    Object? tokenCountApprox = freezed,
    Object? modelId = freezed,
    Object? modelName = freezed,
  }) {
    return _then(
      _$MessageImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        conversationId:
            null == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                    as String,
        role:
            null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                    as MessageRole,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        isStreaming:
            null == isStreaming
                ? _value.isStreaming
                : isStreaming // ignore: cast_nullable_to_non_nullable
                    as bool,
        artifactIds:
            null == artifactIds
                ? _value._artifactIds
                : artifactIds // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        toolCalls:
            freezed == toolCalls
                ? _value._toolCalls
                : toolCalls // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        toolResult:
            freezed == toolResult
                ? _value._toolResult
                : toolResult // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        tokenCountApprox:
            freezed == tokenCountApprox
                ? _value.tokenCountApprox
                : tokenCountApprox // ignore: cast_nullable_to_non_nullable
                    as int?,
        modelId:
            freezed == modelId
                ? _value.modelId
                : modelId // ignore: cast_nullable_to_non_nullable
                    as String?,
        modelName:
            freezed == modelName
                ? _value.modelName
                : modelName // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl extends _Message {
  const _$MessageImpl({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    this.createdAt,
    this.updatedAt,
    this.isStreaming = false,
    final List<String> artifactIds = const <String>[],
    final Map<String, dynamic>? toolCalls,
    final Map<String, dynamic>? toolResult,
    this.tokenCountApprox,
    this.modelId,
    this.modelName,
  }) : _artifactIds = artifactIds,
       _toolCalls = toolCalls,
       _toolResult = toolResult,
       super._();

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final String id;
  @override
  final String conversationId;
  @override
  final MessageRole role;
  @override
  final String content;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Whether this message is still streaming from the API.
  @override
  @JsonKey()
  final bool isStreaming;

  /// IDs of artifacts attached to this assistant message.
  final List<String> _artifactIds;

  /// IDs of artifacts attached to this assistant message.
  @override
  @JsonKey()
  List<String> get artifactIds {
    if (_artifactIds is EqualUnmodifiableListView) return _artifactIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artifactIds);
  }

  /// Tool call payload for assistant messages proposing tool usage.
  final Map<String, dynamic>? _toolCalls;

  /// Tool call payload for assistant messages proposing tool usage.
  @override
  Map<String, dynamic>? get toolCalls {
    final value = _toolCalls;
    if (value == null) return null;
    if (_toolCalls is EqualUnmodifiableMapView) return _toolCalls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Tool result payload for tool-role messages.
  final Map<String, dynamic>? _toolResult;

  /// Tool result payload for tool-role messages.
  @override
  Map<String, dynamic>? get toolResult {
    final value = _toolResult;
    if (value == null) return null;
    if (_toolResult is EqualUnmodifiableMapView) return _toolResult;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Approximate token count for this message.
  @override
  final int? tokenCountApprox;

  /// Id of the model that generated this (assistant) message.
  @override
  final String? modelId;

  /// Human-readable name of the model that generated this message.
  @override
  final String? modelName;

  @override
  String toString() {
    return 'Message(id: $id, conversationId: $conversationId, role: $role, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, isStreaming: $isStreaming, artifactIds: $artifactIds, toolCalls: $toolCalls, toolResult: $toolResult, tokenCountApprox: $tokenCountApprox, modelId: $modelId, modelName: $modelName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isStreaming, isStreaming) ||
                other.isStreaming == isStreaming) &&
            const DeepCollectionEquality().equals(
              other._artifactIds,
              _artifactIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._toolCalls,
              _toolCalls,
            ) &&
            const DeepCollectionEquality().equals(
              other._toolResult,
              _toolResult,
            ) &&
            (identical(other.tokenCountApprox, tokenCountApprox) ||
                other.tokenCountApprox == tokenCountApprox) &&
            (identical(other.modelId, modelId) || other.modelId == modelId) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    conversationId,
    role,
    content,
    createdAt,
    updatedAt,
    isStreaming,
    const DeepCollectionEquality().hash(_artifactIds),
    const DeepCollectionEquality().hash(_toolCalls),
    const DeepCollectionEquality().hash(_toolResult),
    tokenCountApprox,
    modelId,
    modelName,
  );

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(this);
  }
}

abstract class _Message extends Message {
  const factory _Message({
    required final String id,
    required final String conversationId,
    required final MessageRole role,
    required final String content,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final bool isStreaming,
    final List<String> artifactIds,
    final Map<String, dynamic>? toolCalls,
    final Map<String, dynamic>? toolResult,
    final int? tokenCountApprox,
    final String? modelId,
    final String? modelName,
  }) = _$MessageImpl;
  const _Message._() : super._();

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  String get id;
  @override
  String get conversationId;
  @override
  MessageRole get role;
  @override
  String get content;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Whether this message is still streaming from the API.
  @override
  bool get isStreaming;

  /// IDs of artifacts attached to this assistant message.
  @override
  List<String> get artifactIds;

  /// Tool call payload for assistant messages proposing tool usage.
  @override
  Map<String, dynamic>? get toolCalls;

  /// Tool result payload for tool-role messages.
  @override
  Map<String, dynamic>? get toolResult;

  /// Approximate token count for this message.
  @override
  int? get tokenCountApprox;

  /// Id of the model that generated this (assistant) message.
  @override
  String? get modelId;

  /// Human-readable name of the model that generated this message.
  @override
  String? get modelName;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
