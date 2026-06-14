import '../../domain/models/tool.dart';

/// Stub tool for image generation.
class ImageGenerationTool implements Tool {
  @override
  String get name => 'generate_image';

  @override
  String get description =>
      'Generate an image from a text prompt. Not yet implemented.';

  @override
  Map<String, dynamic> get parameters => <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'prompt': <String, dynamic>{
            'type': 'string',
            'description': 'A detailed image prompt.',
          },
        },
        'required': <String>['prompt'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    final prompt = arguments['prompt'] as String? ?? '';
    return ToolResult(
      success: false,
      data: null,
      error: 'Image generation is not implemented yet. Prompt: $prompt',
    );
  }
}
