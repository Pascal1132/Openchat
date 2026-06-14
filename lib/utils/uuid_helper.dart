import 'package:uuid/uuid.dart';

/// Generates a time-based UUID v4 string.
String generateUuid() => const Uuid().v4();
