import '../../domain/models/tool.dart';

/// Stub tool for image analysis.
class AnalyzeImageTool implements Tool {
  @override
  String get name => 'analyze_image';

  @override
  String get description =>
      'Analyze or describe an image. Provide a URL or data URI.';

  @override
  Map<String, dynamic> get parameters => <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'image_url': <String, dynamic>{
            'type': 'string',
            'description': 'URL or base64 data URI of the image.',
          },
        },
        'required': <String>['image_url'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    return const ToolResult(
      success: false,
      data: null,
      error: 'Image analysis is not implemented yet.',
    );
  }
}
