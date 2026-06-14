import '../models/app_settings.dart';

/// Repository for app settings and data management.
abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<void> resetSettings();
  Future<String> exportData();
  Future<void> importData(String json);
  Future<void> deleteAllLocalData();
}
