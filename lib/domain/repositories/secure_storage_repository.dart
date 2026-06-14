/// Repository for securely storing and retrieving sensitive data.
abstract class SecureStorageRepository {
  Future<String?> getApiKey();
  Future<void> setApiKey(String apiKey);
  Future<void> deleteApiKey();
  Future<bool> hasApiKey();
}
