import '../../domain/models/tool.dart';

/// Stub tool for web search.
///
/// In a future iteration this can be wired to a real search provider.
class SearchWebTool implements Tool {
  @override
  String get name => 'search_web';

  @override
  String get description =>
      'Search the web for current information. Provide a concise query.';

  @override
  Map<String, dynamic> get parameters => <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'query': <String, dynamic>{
            'type': 'string',
            'description': 'The search query.',
          },
        },
        'required': <String>['query'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    final query = arguments['query'] as String? ?? '';
    return ToolResult(
      success: true,
      data: <String, dynamic>{
        'query': query,
        'results': <Map<String, String>>[
          {
            'title': 'Web search placeholder',
            'snippet':
                'Web search is not yet implemented locally. Query received: $query',
          },
        ],
      },
    );
  }
}
