import 'package:flutter_test/flutter_test.dart';
import 'package:openchat/services/openrouter/sse_parser.dart';

void main() {
  group('SseParser', () {
    test('parses a simple data event', () {
      final parser = SseParser();
      final events = parser.feed('data: {"choices":[]}\n\n');
      expect(events.length, 1);
      expect(events.first.data, '{"choices":[]}');
      expect(events.first.isDone, false);
    });

    test('recognizes [DONE]', () {
      final parser = SseParser();
      final events = parser.feed('data: [DONE]\n\n');
      expect(events.length, 1);
      expect(events.first.isDone, true);
    });

    test('ignores comments', () {
      final parser = SseParser();
      final events = parser.feed(': OPENROUTER PROCESSING\n\ndata: hello\n\n');
      expect(events.length, 1);
      expect(events.first.data, 'hello');
    });

    test('buffers multiline data events', () {
      final parser = SseParser();
      final events = parser.feed('data: hello\ndata: world\n\n');
      expect(events.length, 1);
      expect(events.first.data, 'hello\nworld');
    });

    test('flushes remaining buffered data', () {
      final parser = SseParser();
      parser.feed('data: trailing');
      final events = parser.flush();
      expect(events.length, 1);
      expect(events.first.data, 'trailing');
    });
  });
}
