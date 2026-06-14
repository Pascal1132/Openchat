/// Parsed Server-Sent Event.
class SseEvent {
  const SseEvent({this.data, this.error, this.isDone = false});

  final String? data;
  final String? error;
  final bool isDone;
}

/// Incremental parser for OpenRouter's SSE stream.
///
/// Implements the core Server-Sent Events parsing rules:
/// - Lines starting with `data: ` contribute to the current event payload.
/// - Lines starting with `: ` are comments and ignored.
/// - Empty lines emit the buffered event.
/// - `data: [DONE]` signals the end of the stream.
class SseParser {
  final StringBuffer _dataBuffer = StringBuffer();

  /// Feeds a complete line (without its trailing newline). Returns any
  /// events completed by this line.
  List<SseEvent> feedLine(String line) {
    final events = <SseEvent>[];

    if (line.isEmpty) {
      if (_dataBuffer.isNotEmpty) {
        events.add(_emit());
      }
      return events;
    }

    if (line.startsWith(':')) {
      // Comment line — ignore.
      return events;
    }

    if (line.startsWith('data: ')) {
      final value = line.substring(6);
      if (_dataBuffer.isNotEmpty) _dataBuffer.write('\n');
      _dataBuffer.write(value);
      return events;
    }

    // Unknown line format; treat the whole line as data to be safe.
    if (_dataBuffer.isNotEmpty) _dataBuffer.write('\n');
    _dataBuffer.write(line);
    return events;
  }

  /// Feeds raw text that may contain multiple lines.
  List<SseEvent> feed(String chunk) {
    final events = <SseEvent>[];
    final lines = chunk.split('\n');
    for (final line in lines) {
      events.addAll(feedLine(line));
    }
    return events;
  }

  /// Flushes any buffered event even if no empty line was received.
  List<SseEvent> flush() {
    if (_dataBuffer.isEmpty) return <SseEvent>[];
    return <SseEvent>[_emit()];
  }

  SseEvent _emit() {
    final raw = _dataBuffer.toString();
    _dataBuffer.clear();
    if (raw == '[DONE]') {
      return const SseEvent(isDone: true);
    }
    return SseEvent(data: raw);
  }
}
