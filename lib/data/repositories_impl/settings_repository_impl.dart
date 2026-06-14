import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../core/errors.dart';
import '../../domain/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../local/local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({
    required this.settingsDataSource,
    required this.conversationsDataSource,
    required this.messagesDataSource,
    required this.artifactsDataSource,
  });

  final HiveJsonDataSource settingsDataSource;
  final HiveJsonDataSource conversationsDataSource;
  final HiveJsonDataSource messagesDataSource;
  final HiveJsonDataSource artifactsDataSource;

  static const String _settingsKey = 'app_settings';

  @override
  Future<AppSettings> getSettings() async {
    final json = await settingsDataSource.getById(_settingsKey);
    if (json == null) return AppSettings.defaults;
    try {
      return AppSettings.fromJson(json);
    } on Exception catch (e) {
      throw StorageException('Invalid settings data', cause: e);
    }
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await settingsDataSource.put(_settingsKey, settings.toJson());
  }

  @override
  Future<void> resetSettings() async {
    await settingsDataSource.put(_settingsKey, AppSettings.defaults.toJson());
  }

  @override
  Future<String> exportData() async {
    final conversations = await conversationsDataSource.getAll();
    final messages = await messagesDataSource.getAll();
    final artifacts = await artifactsDataSource.getAll();
    final settings = (await settingsDataSource.getById(_settingsKey)) ??
        AppSettings.defaults.toJson();

    final payload = <String, dynamic>{
      'version': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'settings': settings,
      'conversations': conversations,
      'messages': messages,
      'artifacts': artifacts,
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  @override
  Future<void> importData(String json) async {
    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final conversations = (decoded['conversations'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          <Map<String, dynamic>>[];
      final messages = (decoded['messages'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          <Map<String, dynamic>>[];
      final artifacts = (decoded['artifacts'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          <Map<String, dynamic>>[];
      final settingsJson = decoded['settings'] as Map<String, dynamic>?;

      await conversationsDataSource.putAll({
        for (final c in conversations)
          (c['id'] as String?) ?? const Uuid().v4(): c,
      });
      await messagesDataSource.putAll({
        for (final m in messages)
          (m['id'] as String?) ?? const Uuid().v4(): m,
      });
      await artifactsDataSource.putAll({
        for (final a in artifacts)
          (a['id'] as String?) ?? const Uuid().v4(): a,
      });
      if (settingsJson != null) {
        await settingsDataSource.put(_settingsKey, settingsJson);
      }
    } on Exception catch (e) {
      throw StorageException('Failed to import data', cause: e);
    }
  }

  @override
  Future<void> deleteAllLocalData() async {
    await Future.wait([
      conversationsDataSource.deleteAll(),
      messagesDataSource.deleteAll(),
      artifactsDataSource.deleteAll(),
      settingsDataSource.deleteAll(),
    ]);
  }
}
