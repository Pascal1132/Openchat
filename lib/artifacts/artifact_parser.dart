import '../domain/models/artifact.dart';
import 'artifact_types.dart';

/// Parses `<artifact>` blocks out of assistant responses.
class ArtifactParser {
  static final RegExp _artifactPattern = RegExp(
    r'<artifact\s+([^>]*)>([\s\S]*?)<\/artifact>',
    caseSensitive: false,
    multiLine: true,
  );

  /// Extracts artifacts from [text].
  ///
  /// [idSeed] makes artifact identity stable across repeated parses of the
  /// same (growing) text — essential during streaming, where the same block
  /// is parsed on every token. Without it a fresh id would be minted each
  /// time, producing many duplicates of the same artifact. When the model
  /// supplies an explicit `id` attribute that always wins.
  List<Artifact> parse(String text, {String idSeed = 'artifact'}) {
    final artifacts = <Artifact>[];
    var index = 0;
    for (final match in _artifactPattern.allMatches(text)) {
      final rawAttributes = match.group(1) ?? '';
      final attrs = _parseAttributes(rawAttributes);
      final type = artifactTypeFromString(attrs['type'] ?? 'document') ??
          ArtifactType.document;
      final content = match.group(2) ?? '';
      final title = attrs['title']?.trim().isNotEmpty == true
          ? attrs['title']!
          : 'Untitled';
      final language = attrs['language'] ?? type.defaultLanguage;
      final id = attrs['id']?.trim().isNotEmpty == true
          ? attrs['id']!
          : '${idSeed}_$index';

      artifacts.add(
        Artifact(
          id: id,
          conversationId: '',
          type: type,
          title: title,
          content: content.trim(),
          language: language,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      index++;
    }
    return artifacts;
  }

  /// Removes `<artifact> ... </artifact>` blocks from the text and replaces
  /// them with a short placeholder so the chat transcript stays readable.
  String stripArtifacts(String text) {
    return text.replaceAllMapped(_artifactPattern, (match) {
      final rawAttributes = match.group(1) ?? '';
      final attrs = _parseAttributes(rawAttributes);
      final title = attrs['title']?.trim().isNotEmpty == true
          ? attrs['title']!
          : 'Artifact';
      return '\n*[Artifact: $title]*\n';
    }).trim();
  }

  Map<String, String> _parseAttributes(String attributes) {
    final map = <String, String>{};
    final tokens = _splitAttributes(attributes);
    for (final token in tokens) {
      final equalsIndex = token.indexOf('=');
      if (equalsIndex <= 0) continue;
      final key = token.substring(0, equalsIndex).trim().toLowerCase();
      final value = _stripQuotes(token.substring(equalsIndex + 1).trim());
      if (key.isNotEmpty) {
        map[key] = value;
      }
    }
    return map;
  }

  List<String> _splitAttributes(String attributes) {
    final tokens = <String>[];
    var current = StringBuffer();
    String? quoteChar;
    for (var i = 0; i < attributes.length; i++) {
      final char = attributes[i];
      if (quoteChar == null && (char == '"' || char == "'")) {
        quoteChar = char;
        current.write(char);
      } else if (quoteChar != null && char == quoteChar) {
        quoteChar = null;
        current.write(char);
      } else if (quoteChar == null && char == ' ') {
        if (current.isNotEmpty) {
          tokens.add(current.toString());
          current = StringBuffer();
        }
      } else {
        current.write(char);
      }
    }
    if (current.isNotEmpty) tokens.add(current.toString());
    return tokens;
  }

  String _stripQuotes(String value) {
    if (value.length >= 2) {
      final first = value[0];
      final last = value[value.length - 1];
      if ((first == '"' || first == "'") && first == last) {
        return value.substring(1, value.length - 1);
      }
    }
    return value;
  }
}
