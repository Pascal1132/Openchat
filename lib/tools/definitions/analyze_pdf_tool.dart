import '../../domain/models/tool.dart';

/// Stub tool for PDF analysis.
class AnalyzePdfTool implements Tool {
  @override
  String get name => 'analyze_pdf';

  @override
  String get description =>
      'Extract and analyze text from a PDF document. Provide a URL or file path.';

  @override
  Map<String, dynamic> get parameters => <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'url': <String, dynamic>{
            'type': 'string',
            'description': 'URL or local path to the PDF.',
          },
        },
        'required': <String>['url'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    return const ToolResult(
      success: false,
      data: null,
      error: 'PDF analysis is not implemented yet.',
    );
  }
}
