import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../constants.dart';
import '../../core/errors.dart';

/// Generic JSON-based Hive data source.
///
/// Stores each record as a JSON string under its id in a named Hive box.
class HiveJsonDataSource {
  HiveJsonDataSource({required this.boxName});

  final String boxName;

  Box<String>? _box;

  Future<Box<String>> _open() async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox<String>(boxName);
    return _box!;
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final box = await _open();
    final values = <Map<String, dynamic>>[];
    for (final raw in box.values) {
      try {
        values.add(jsonDecode(raw) as Map<String, dynamic>);
      } on FormatException {
        continue;
      }
    }
    return values;
  }

  Future<Map<String, dynamic>?> getById(String id) async {
    final box = await _open();
    final raw = box.get(id);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } on FormatException {
      return null;
    }
  }

  Future<void> put(String id, Map<String, dynamic> data) async {
    final box = await _open();
    await box.put(id, jsonEncode(data));
  }

  Future<void> putAll(Map<String, Map<String, dynamic>> entries) async {
    final box = await _open();
    final serialized = <String, String>{};
    for (final entry in entries.entries) {
      serialized[entry.key] = jsonEncode(entry.value);
    }
    await box.putAll(serialized);
  }

  Future<void> delete(String id) async {
    final box = await _open();
    await box.delete(id);
  }

  Future<void> deleteAll() async {
    final box = await _open();
    await box.clear();
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    final lowerQuery = query.toLowerCase();
    final all = await getAll();
    return all.where((data) {
      final title = (data['title'] as String? ?? '').toLowerCase();
      final content = (data['content'] as String? ?? '').toLowerCase();
      return title.contains(lowerQuery) || content.contains(lowerQuery);
    }).toList();
  }

  Future<int> count() async {
    final box = await _open();
    return box.length;
  }
}

/// Utility class that opens and exposes all local boxes used by the app.
class LocalDatabase {
  LocalDatabase._();

  static final conversations = HiveJsonDataSource(
    boxName: StorageKeys.conversationsBox,
  );
  static final messages = HiveJsonDataSource(
    boxName: StorageKeys.messagesBox,
  );
  static final artifacts = HiveJsonDataSource(
    boxName: StorageKeys.artifactsBox,
  );
  static final settings = HiveJsonDataSource(
    boxName: StorageKeys.settingsBox,
  );
  static final modelsCache = HiveJsonDataSource(
    boxName: StorageKeys.modelsCacheBox,
  );

  static Future<void> deleteEverything() async {
    try {
      await Future.wait([
        conversations.deleteAll(),
        messages.deleteAll(),
        artifacts.deleteAll(),
        settings.deleteAll(),
        modelsCache.deleteAll(),
      ]);
    } on Exception catch (e) {
      throw StorageException('Failed to delete all local data', cause: e);
    }
  }
}
