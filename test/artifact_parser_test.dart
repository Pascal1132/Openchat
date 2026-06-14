import 'package:flutter_test/flutter_test.dart';
import 'package:openchat/artifacts/artifact_parser.dart';
import 'package:openchat/domain/models/artifact.dart';

void main() {
  final parser = ArtifactParser();

  group('ArtifactParser', () {
    test('extracts a code artifact', () {
      const text = '''
Here is some code:
<artifact type="code" title="main.dart" language="dart">
void main() {
  print('hello');
}
</artifact>
Hope it helps!
''';
      final artifacts = parser.parse(text);
      expect(artifacts.length, 1);
      expect(artifacts.first.type, ArtifactType.code);
      expect(artifacts.first.title, 'main.dart');
      expect(artifacts.first.language, 'dart');
      expect(artifacts.first.content.contains("print('hello')"), isTrue);
    });

    test('extracts multiple artifacts', () {
      const text = '''
<artifact type="markdown" title="notes.md">Hello</artifact>
<artifact type="json" title="data.json">{"x":1}</artifact>
''';
      final artifacts = parser.parse(text);
      expect(artifacts.length, 2);
      expect(artifacts[0].type, ArtifactType.markdown);
      expect(artifacts[1].type, ArtifactType.json);
    });

    test('strips artifacts and leaves placeholders', () {
      const text = 'See <artifact type="code" title="main.dart">...</artifact> done';
      final stripped = parser.stripArtifacts(text);
      expect(stripped.contains('<artifact'), isFalse);
      expect(stripped.contains('[Artifact: main.dart]'), isTrue);
    });

    test('falls back to document type when type is missing', () {
      const text = '<artifact title="plain">content</artifact>';
      final artifacts = parser.parse(text);
      expect(artifacts.first.type, ArtifactType.document);
    });
  });
}
