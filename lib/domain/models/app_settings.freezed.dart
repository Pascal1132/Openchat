// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  @ThemeModeConverter()
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  double get temperature => throw _privateConstructorUsedError;
  double get topP => throw _privateConstructorUsedError;
  int get maxTokens => throw _privateConstructorUsedError;
  bool get streamingEnabled => throw _privateConstructorUsedError;
  bool get artifactsEnabled => throw _privateConstructorUsedError;
  bool get toolsEnabled => throw _privateConstructorUsedError;
  String? get defaultModelId => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    @ThemeModeConverter() ThemeMode themeMode,
    double temperature,
    double topP,
    int maxTokens,
    bool streamingEnabled,
    bool artifactsEnabled,
    bool toolsEnabled,
    String? defaultModelId,
    String locale,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? temperature = null,
    Object? topP = null,
    Object? maxTokens = null,
    Object? streamingEnabled = null,
    Object? artifactsEnabled = null,
    Object? toolsEnabled = null,
    Object? defaultModelId = freezed,
    Object? locale = null,
  }) {
    return _then(
      _value.copyWith(
            themeMode:
                null == themeMode
                    ? _value.themeMode
                    : themeMode // ignore: cast_nullable_to_non_nullable
                        as ThemeMode,
            temperature:
                null == temperature
                    ? _value.temperature
                    : temperature // ignore: cast_nullable_to_non_nullable
                        as double,
            topP:
                null == topP
                    ? _value.topP
                    : topP // ignore: cast_nullable_to_non_nullable
                        as double,
            maxTokens:
                null == maxTokens
                    ? _value.maxTokens
                    : maxTokens // ignore: cast_nullable_to_non_nullable
                        as int,
            streamingEnabled:
                null == streamingEnabled
                    ? _value.streamingEnabled
                    : streamingEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            artifactsEnabled:
                null == artifactsEnabled
                    ? _value.artifactsEnabled
                    : artifactsEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            toolsEnabled:
                null == toolsEnabled
                    ? _value.toolsEnabled
                    : toolsEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            defaultModelId:
                freezed == defaultModelId
                    ? _value.defaultModelId
                    : defaultModelId // ignore: cast_nullable_to_non_nullable
                        as String?,
            locale:
                null == locale
                    ? _value.locale
                    : locale // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @ThemeModeConverter() ThemeMode themeMode,
    double temperature,
    double topP,
    int maxTokens,
    bool streamingEnabled,
    bool artifactsEnabled,
    bool toolsEnabled,
    String? defaultModelId,
    String locale,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? temperature = null,
    Object? topP = null,
    Object? maxTokens = null,
    Object? streamingEnabled = null,
    Object? artifactsEnabled = null,
    Object? toolsEnabled = null,
    Object? defaultModelId = freezed,
    Object? locale = null,
  }) {
    return _then(
      _$AppSettingsImpl(
        themeMode:
            null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                    as ThemeMode,
        temperature:
            null == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                    as double,
        topP:
            null == topP
                ? _value.topP
                : topP // ignore: cast_nullable_to_non_nullable
                    as double,
        maxTokens:
            null == maxTokens
                ? _value.maxTokens
                : maxTokens // ignore: cast_nullable_to_non_nullable
                    as int,
        streamingEnabled:
            null == streamingEnabled
                ? _value.streamingEnabled
                : streamingEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        artifactsEnabled:
            null == artifactsEnabled
                ? _value.artifactsEnabled
                : artifactsEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        toolsEnabled:
            null == toolsEnabled
                ? _value.toolsEnabled
                : toolsEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        defaultModelId:
            freezed == defaultModelId
                ? _value.defaultModelId
                : defaultModelId // ignore: cast_nullable_to_non_nullable
                    as String?,
        locale:
            null == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl extends _AppSettings {
  const _$AppSettingsImpl({
    @ThemeModeConverter() this.themeMode = ThemeMode.system,
    this.temperature = Defaults.temperature,
    this.topP = Defaults.topP,
    this.maxTokens = Defaults.maxTokens,
    this.streamingEnabled = Defaults.streamingEnabled,
    this.artifactsEnabled = Defaults.artifactsEnabled,
    this.toolsEnabled = Defaults.toolsEnabled,
    this.defaultModelId,
    this.locale = 'en',
  }) : super._();

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  @ThemeModeConverter()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final double temperature;
  @override
  @JsonKey()
  final double topP;
  @override
  @JsonKey()
  final int maxTokens;
  @override
  @JsonKey()
  final bool streamingEnabled;
  @override
  @JsonKey()
  final bool artifactsEnabled;
  @override
  @JsonKey()
  final bool toolsEnabled;
  @override
  final String? defaultModelId;
  @override
  @JsonKey()
  final String locale;

  @override
  String toString() {
    return 'AppSettings(themeMode: $themeMode, temperature: $temperature, topP: $topP, maxTokens: $maxTokens, streamingEnabled: $streamingEnabled, artifactsEnabled: $artifactsEnabled, toolsEnabled: $toolsEnabled, defaultModelId: $defaultModelId, locale: $locale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.topP, topP) || other.topP == topP) &&
            (identical(other.maxTokens, maxTokens) ||
                other.maxTokens == maxTokens) &&
            (identical(other.streamingEnabled, streamingEnabled) ||
                other.streamingEnabled == streamingEnabled) &&
            (identical(other.artifactsEnabled, artifactsEnabled) ||
                other.artifactsEnabled == artifactsEnabled) &&
            (identical(other.toolsEnabled, toolsEnabled) ||
                other.toolsEnabled == toolsEnabled) &&
            (identical(other.defaultModelId, defaultModelId) ||
                other.defaultModelId == defaultModelId) &&
            (identical(other.locale, locale) || other.locale == locale));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    themeMode,
    temperature,
    topP,
    maxTokens,
    streamingEnabled,
    artifactsEnabled,
    toolsEnabled,
    defaultModelId,
    locale,
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(this);
  }
}

abstract class _AppSettings extends AppSettings {
  const factory _AppSettings({
    @ThemeModeConverter() final ThemeMode themeMode,
    final double temperature,
    final double topP,
    final int maxTokens,
    final bool streamingEnabled,
    final bool artifactsEnabled,
    final bool toolsEnabled,
    final String? defaultModelId,
    final String locale,
  }) = _$AppSettingsImpl;
  const _AppSettings._() : super._();

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  @ThemeModeConverter()
  ThemeMode get themeMode;
  @override
  double get temperature;
  @override
  double get topP;
  @override
  int get maxTokens;
  @override
  bool get streamingEnabled;
  @override
  bool get artifactsEnabled;
  @override
  bool get toolsEnabled;
  @override
  String? get defaultModelId;
  @override
  String get locale;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
