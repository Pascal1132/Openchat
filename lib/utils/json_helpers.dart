import 'dart:convert';

/// Safely decodes a JSON string into a map.
Map<String, dynamic>? tryDecodeJson(String? value) {
  if (value == null || value.isEmpty) return null;
  try {
    final decoded = jsonDecode(value);
    if (decoded is Map<String, dynamic>) return decoded;
    return null;
  } on FormatException {
    return null;
  }
}

/// Encodes an object to a pretty-printed JSON string.
String prettyPrintJson(Object? value) {
  return const JsonEncoder.withIndent('  ').convert(value);
}
