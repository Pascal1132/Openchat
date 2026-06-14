/// Base exception used inside OpenChat.
class OpenChatException implements Exception {
  const OpenChatException(this.message, {this.code, this.cause});

  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() => 'OpenChatException: $message${code != null ? ' [$code]' : ''}';
}

/// Exception originating from the OpenRouter API.
class OpenRouterException extends OpenChatException {
  const OpenRouterException(super.message, {super.code, super.cause});
}

/// Exception originating from local storage operations.
class StorageException extends OpenChatException {
  const StorageException(super.message, {super.cause});
}

/// Exception originating from secure storage operations.
class SecureStorageException extends OpenChatException {
  const SecureStorageException(super.message, {super.cause});
}
