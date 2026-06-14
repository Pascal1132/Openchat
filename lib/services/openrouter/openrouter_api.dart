import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../../core/errors.dart';
import '../../domain/models/message.dart';
import '../../domain/models/openrouter_model.dart';
import '../../domain/models/tool.dart';
import 'sse_parser.dart';

/// Default request body for an OpenRouter chat completion.
class ChatCompletionRequest {
  const ChatCompletionRequest({
    required this.model,
    required this.messages,
    this.temperature = Defaults.temperature,
    this.topP = Defaults.topP,
    this.maxTokens = Defaults.maxTokens,
    this.stream = true,
    this.tools,
    this.toolChoice,
  });

  final String model;
  final List<Message> messages;
  final double temperature;
  final double topP;
  final int maxTokens;
  final bool stream;
  final List<Tool>? tools;
  final String? toolChoice;

  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{
      'model': model,
      'messages': messages.map((m) => _messageToJson(m)).toList(),
      'temperature': temperature,
      'top_p': topP,
      'max_tokens': maxTokens,
      'stream': stream,
      'transforms': <String>[],
    };
    if (tools != null && tools!.isNotEmpty) {
      body['tools'] = tools!
          .map((tool) => {
                'type': 'function',
                'function': {
                  'name': tool.name,
                  'description': tool.description,
                  'parameters': tool.parameters,
                },
              })
          .toList();
      body['tool_choice'] = toolChoice ?? 'auto';
    }
    return body;
  }
}

Map<String, dynamic> _messageToJson(Message message) {
  if (message.role == MessageRole.tool && message.toolResult != null) {
    return {
      'role': 'tool',
      'content': message.content,
      'tool_call_id': message.toolResult!['tool_call_id'],
    };
  }
  if (message.toolCalls != null && message.toolCalls!.isNotEmpty) {
    return {
      'role': 'assistant',
      'content': null,
      'tool_calls': message.toolCalls!['tool_calls'],
    };
  }
  return {
    'role': message.role.name,
    'content': message.content,
  };
}

/// Client for the OpenRouter API.
class OpenRouterApi {
  OpenRouterApi({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Map<String, String> _headers(String apiKey) => <String, String>{
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': OpenRouterConstants.appUrl,
        'X-OpenRouter-Title': OpenRouterConstants.appName,
      };

  /// Fetches the list of available models.
  Future<List<OpenRouterModel>> fetchModels({required String apiKey}) async {
    final uri = Uri.parse('${OpenRouterConstants.baseUrl}${OpenRouterConstants.modelsEndpoint}');
    final response = await _client.get(uri, headers: _headers(apiKey));

    if (response.statusCode == HttpStatus.unauthorized) {
      throw const OpenRouterException('Invalid API key', code: 'UNAUTHORIZED');
    }
    if (response.statusCode != HttpStatus.ok) {
      throw OpenRouterException(
        'Failed to fetch models: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    }

    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded['data'] as List<dynamic>? ?? <dynamic>[];
      return data
          .cast<Map<String, dynamic>>()
          .map(_parseOpenRouterModel)
          .where((model) => model.id.isNotEmpty)
          .toList();
    } on Exception catch (e) {
      throw OpenRouterException('Failed to parse models response', cause: e);
    }
  }

  /// Sends a chat completion request and yields incoming content chunks.
  Stream<String> streamChatCompletion({
    required String apiKey,
    required ChatCompletionRequest request,
  }) async* {
    final uri = Uri.parse(
      '${OpenRouterConstants.baseUrl}${OpenRouterConstants.chatCompletionsEndpoint}',
    );
    final streamedRequest = http.Request('POST', uri)
      ..headers.addAll(_headers(apiKey))
      ..body = jsonEncode(request.toJson());

    final response = await _client.send(streamedRequest);

    if (response.statusCode == HttpStatus.unauthorized) {
      throw const OpenRouterException('Invalid API key', code: 'UNAUTHORIZED');
    }
    if (response.statusCode != HttpStatus.ok) {
      final body = await response.stream.bytesToString();
      throw OpenRouterException(
        'Chat request failed: ${response.statusCode}',
        code: response.statusCode.toString(),
        cause: body,
      );
    }

    final parser = SseParser();
    await for (final chunk in response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      for (final event in parser.feed(chunk)) {
        if (event.isDone) return;
        if (event.error != null) {
          throw OpenRouterException(event.error!, code: 'STREAM_ERROR');
        }
        if (event.data != null) {
          final content = _extractDeltaContent(event.data!);
          if (content != null) yield content;
        }
      }
    }
  }

  String? _extractDeltaContent(String dataLine) {
    try {
      final decoded = jsonDecode(dataLine) as Map<String, dynamic>;
      if (decoded['error'] != null) {
        throw OpenRouterException(decoded['error'].toString(), code: 'STREAM_ERROR');
      }
      final choices = decoded['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) return null;
      final first = choices.first as Map<String, dynamic>;
      final delta = first['delta'] as Map<String, dynamic>?;
      if (delta == null) return null;

      // Check for tool_calls first.
      final toolCalls = delta['tool_calls'] as List<dynamic>?;
      if (toolCalls != null && toolCalls.isNotEmpty) {
        // Tool calls are emitted as a JSON string so the upper layer can
        // aggregate them.
        return '__TOOL_CALLS__:$dataLine';
      }

      final content = delta['content'];
      if (content == null) return null;
      return content as String;
    } on OpenRouterException {
      rethrow;
    } on Exception {
      return null;
    }
  }

  OpenRouterModel _parseOpenRouterModel(Map<String, dynamic> json) {
    final pricingJson = json['pricing'] as Map<String, dynamic>?;
    final pricing = pricingJson == null
        ? null
        : ModelPricing(
            prompt: _parseDouble(pricingJson['prompt']),
            completion: _parseDouble(pricingJson['completion']),
            request: _parseDouble(pricingJson['request']),
            image: _parseDouble(pricingJson['image']),
            webSearch: _parseDouble(pricingJson['web_search']),
            internalReasoning: _parseDouble(pricingJson['internal_reasoning']),
          );

    return OpenRouterModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      contextLength: (json['context_length'] as num?)?.toInt() ?? 0,
      pricing: pricing,
      supportsVision: ((json['architecture'] as Map<String, dynamic>?)?['modality']
                  as String? ??
              '')
          .contains('image'),
      supportsTools: json['supports_tools'] as bool? ?? false,
      supportsReasoning: json['supports_reasoning'] as bool? ?? false,
      cachedAt: DateTime.now().toUtc(),
    );
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
