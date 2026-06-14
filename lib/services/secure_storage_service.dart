// ignore_for_file: deprecated_member_use

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';
import '../core/errors.dart';

/// Wraps [FlutterSecureStorage] to persist the OpenRouter API key.
///
/// The API key is never logged or exposed as plain text outside this service.
class SecureStorageService {
  const SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          iOptions: IOSOptions(
            accountName: 'openchat_keychain',
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );

  final FlutterSecureStorage _storage;

  Future<String?> readApiKey() async {
    try {
      return _storage.read(key: StorageKeys.apiKey);
    } on Exception catch (e, _) {
      throw SecureStorageException('Unable to read API key', cause: e);
    }
  }

  Future<void> writeApiKey(String apiKey) async {
    try {
      await _storage.write(key: StorageKeys.apiKey, value: apiKey);
    } on Exception catch (e, _) {
      throw SecureStorageException('Unable to write API key', cause: e);
    }
  }

  Future<void> deleteApiKey() async {
    try {
      await _storage.delete(key: StorageKeys.apiKey);
    } on Exception catch (e, _) {
      throw SecureStorageException('Unable to delete API key', cause: e);
    }
  }

  Future<bool> hasApiKey() async {
    final value = await readApiKey();
    return value != null && value.isNotEmpty;
  }
}
