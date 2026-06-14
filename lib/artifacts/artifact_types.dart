import '../domain/models/artifact.dart';

/// Human-readable labels and default language for each artifact type.
extension ArtifactTypeX on ArtifactType {
  String get label {
    switch (this) {
      case ArtifactType.code:
        return 'Code';
      case ArtifactType.markdown:
        return 'Markdown';
      case ArtifactType.html:
        return 'HTML';
      case ArtifactType.json:
        return 'JSON';
      case ArtifactType.table:
        return 'Table';
      case ArtifactType.document:
        return 'Document';
    }
  }

  String? get defaultLanguage {
    switch (this) {
      case ArtifactType.code:
        return 'text';
      case ArtifactType.json:
        return 'json';
      case ArtifactType.html:
        return 'html';
      case ArtifactType.markdown:
      case ArtifactType.table:
      case ArtifactType.document:
        return null;
    }
  }
}

/// Parse an artifact type from a string.
ArtifactType? artifactTypeFromString(String value) {
  final lowered = value.toLowerCase().trim();
  for (final type in ArtifactType.values) {
    if (type.name == lowered) return type;
  }
  // Accept a few aliases.
  switch (lowered) {
    case 'js':
    case 'javascript':
    case 'ts':
    case 'typescript':
    case 'python':
    case 'dart':
    case 'go':
    case 'rust':
    case 'c':
    case 'cpp':
    case 'java':
    case 'kotlin':
    case 'swift':
    case 'ruby':
    case 'php':
    case 'css':
    case 'scss':
    case 'sql':
    case 'bash':
    case 'shell':
    case 'yaml':
    case 'xml':
      return ArtifactType.code;
    case 'htm':
      return ArtifactType.html;
    case 'csv':
      return ArtifactType.table;
    case 'txt':
      return ArtifactType.document;
    default:
      return null;
  }
}
