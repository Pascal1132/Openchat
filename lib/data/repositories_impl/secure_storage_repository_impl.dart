import '../../domain/repositories/secure_storage_repository.dart';
import '../../services/secure_storage_service.dart';

class SecureStorageRepositoryImpl implements SecureStorageRepository {
  const SecureStorageRepositoryImpl(this._service);

  final SecureStorageService _service;

  @override
  Future<String?> getApiKey() => _service.readApiKey();

  @override
  Future<void> setApiKey(String apiKey) => _service.writeApiKey(apiKey);

  @override
  Future<void> deleteApiKey() => _service.deleteApiKey();

  @override
  Future<bool> hasApiKey() => _service.hasApiKey();
}
