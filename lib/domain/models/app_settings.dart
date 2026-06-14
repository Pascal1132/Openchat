import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../constants.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @ThemeModeConverter() @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(Defaults.temperature) double temperature,
    @Default(Defaults.topP) double topP,
    @Default(Defaults.maxTokens) int maxTokens,
    @Default(Defaults.streamingEnabled) bool streamingEnabled,
    @Default(Defaults.artifactsEnabled) bool artifactsEnabled,
    @Default(Defaults.toolsEnabled) bool toolsEnabled,
    String? defaultModelId,
    @Default('en') String locale,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  const AppSettings._();

  /// Default settings instance.
  static const AppSettings defaults = AppSettings();
}

class ThemeModeConverter implements JsonConverter<ThemeMode, String> {
  const ThemeModeConverter();

  @override
  ThemeMode fromJson(String json) => ThemeMode.values.byName(json);

  @override
  String toJson(ThemeMode object) => object.name;
}
