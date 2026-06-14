// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      themeMode:
          json['themeMode'] == null
              ? ThemeMode.system
              : const ThemeModeConverter().fromJson(
                json['themeMode'] as String,
              ),
      temperature:
          (json['temperature'] as num?)?.toDouble() ?? Defaults.temperature,
      topP: (json['topP'] as num?)?.toDouble() ?? Defaults.topP,
      maxTokens: (json['maxTokens'] as num?)?.toInt() ?? Defaults.maxTokens,
      streamingEnabled:
          json['streamingEnabled'] as bool? ?? Defaults.streamingEnabled,
      artifactsEnabled:
          json['artifactsEnabled'] as bool? ?? Defaults.artifactsEnabled,
      toolsEnabled: json['toolsEnabled'] as bool? ?? Defaults.toolsEnabled,
      defaultModelId: json['defaultModelId'] as String?,
      locale: json['locale'] as String? ?? 'en',
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'themeMode': const ThemeModeConverter().toJson(instance.themeMode),
      'temperature': instance.temperature,
      'topP': instance.topP,
      'maxTokens': instance.maxTokens,
      'streamingEnabled': instance.streamingEnabled,
      'artifactsEnabled': instance.artifactsEnabled,
      'toolsEnabled': instance.toolsEnabled,
      'defaultModelId': instance.defaultModelId,
      'locale': instance.locale,
    };
