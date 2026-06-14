// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artifact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Artifact _$ArtifactFromJson(Map<String, dynamic> json) {
  return _Artifact.fromJson(json);
}

/// @nodoc
mixin _$Artifact {
  String get id => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  ArtifactType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get language => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  List<String> get versionHistory => throw _privateConstructorUsedError;

  /// Serializes this Artifact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Artifact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArtifactCopyWith<Artifact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArtifactCopyWith<$Res> {
  factory $ArtifactCopyWith(Artifact value, $Res Function(Artifact) then) =
      _$ArtifactCopyWithImpl<$Res, Artifact>;
  @useResult
  $Res call({
    String id,
    String conversationId,
    ArtifactType type,
    String title,
    String content,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
    int version,
    List<String> versionHistory,
  });
}

/// @nodoc
class _$ArtifactCopyWithImpl<$Res, $Val extends Artifact>
    implements $ArtifactCopyWith<$Res> {
  _$ArtifactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Artifact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? type = null,
    Object? title = null,
    Object? content = null,
    Object? language = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? version = null,
    Object? versionHistory = null,
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
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as ArtifactType,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            content:
                null == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as String,
            language:
                freezed == language
                    ? _value.language
                    : language // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            version:
                null == version
                    ? _value.version
                    : version // ignore: cast_nullable_to_non_nullable
                        as int,
            versionHistory:
                null == versionHistory
                    ? _value.versionHistory
                    : versionHistory // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArtifactImplCopyWith<$Res>
    implements $ArtifactCopyWith<$Res> {
  factory _$$ArtifactImplCopyWith(
    _$ArtifactImpl value,
    $Res Function(_$ArtifactImpl) then,
  ) = __$$ArtifactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String conversationId,
    ArtifactType type,
    String title,
    String content,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
    int version,
    List<String> versionHistory,
  });
}

/// @nodoc
class __$$ArtifactImplCopyWithImpl<$Res>
    extends _$ArtifactCopyWithImpl<$Res, _$ArtifactImpl>
    implements _$$ArtifactImplCopyWith<$Res> {
  __$$ArtifactImplCopyWithImpl(
    _$ArtifactImpl _value,
    $Res Function(_$ArtifactImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Artifact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? type = null,
    Object? title = null,
    Object? content = null,
    Object? language = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? version = null,
    Object? versionHistory = null,
  }) {
    return _then(
      _$ArtifactImpl(
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
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as ArtifactType,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String,
        language:
            freezed == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        version:
            null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                    as int,
        versionHistory:
            null == versionHistory
                ? _value._versionHistory
                : versionHistory // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArtifactImpl extends _Artifact {
  const _$ArtifactImpl({
    required this.id,
    required this.conversationId,
    required this.type,
    required this.title,
    required this.content,
    this.language,
    this.createdAt,
    this.updatedAt,
    this.version = 1,
    final List<String> versionHistory = const <String>[],
  }) : _versionHistory = versionHistory,
       super._();

  factory _$ArtifactImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArtifactImplFromJson(json);

  @override
  final String id;
  @override
  final String conversationId;
  @override
  final ArtifactType type;
  @override
  final String title;
  @override
  final String content;
  @override
  final String? language;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final int version;
  final List<String> _versionHistory;
  @override
  @JsonKey()
  List<String> get versionHistory {
    if (_versionHistory is EqualUnmodifiableListView) return _versionHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_versionHistory);
  }

  @override
  String toString() {
    return 'Artifact(id: $id, conversationId: $conversationId, type: $type, title: $title, content: $content, language: $language, createdAt: $createdAt, updatedAt: $updatedAt, version: $version, versionHistory: $versionHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArtifactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(
              other._versionHistory,
              _versionHistory,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    conversationId,
    type,
    title,
    content,
    language,
    createdAt,
    updatedAt,
    version,
    const DeepCollectionEquality().hash(_versionHistory),
  );

  /// Create a copy of Artifact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArtifactImplCopyWith<_$ArtifactImpl> get copyWith =>
      __$$ArtifactImplCopyWithImpl<_$ArtifactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArtifactImplToJson(this);
  }
}

abstract class _Artifact extends Artifact {
  const factory _Artifact({
    required final String id,
    required final String conversationId,
    required final ArtifactType type,
    required final String title,
    required final String content,
    final String? language,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final int version,
    final List<String> versionHistory,
  }) = _$ArtifactImpl;
  const _Artifact._() : super._();

  factory _Artifact.fromJson(Map<String, dynamic> json) =
      _$ArtifactImpl.fromJson;

  @override
  String get id;
  @override
  String get conversationId;
  @override
  ArtifactType get type;
  @override
  String get title;
  @override
  String get content;
  @override
  String? get language;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  int get version;
  @override
  List<String> get versionHistory;

  /// Create a copy of Artifact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArtifactImplCopyWith<_$ArtifactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
