import '../domain/models/tool.dart';
import 'definitions/analyze_image_tool.dart';
import 'definitions/analyze_pdf_tool.dart';
import 'definitions/image_generation_tool.dart';
import 'definitions/search_web_tool.dart';

/// Registry holding every tool available to OpenChat.
///
/// Adding a new tool only requires implementing [Tool] and registering it here.
class ToolRegistry {
  ToolRegistry({List<Tool>? tools}) : _tools = tools ?? defaultTools;

  final List<Tool> _tools;

  static final List<Tool> defaultTools = <Tool>[
    SearchWebTool(),
    ImageGenerationTool(),
    AnalyzeImageTool(),
    AnalyzePdfTool(),
  ];

  List<Tool> get all => List<Tool>.unmodifiable(_tools);

  Tool? findByName(String name) {
    try {
      return _tools.firstWhere((tool) => tool.name == name);
    } on StateError {
      return null;
    }
  }
}
