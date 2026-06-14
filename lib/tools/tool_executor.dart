import '../domain/models/tool.dart';
import 'tool_registry.dart';

/// Executes [Tool] instances from a [ToolRegistry].
class ToolExecutor {
  const ToolExecutor(this._registry);

  final ToolRegistry _registry;

  Future<ToolResult> execute(String toolName, Map<String, dynamic> arguments) async {
    final tool = _registry.findByName(toolName);
    if (tool == null) {
      return ToolResult(
        success: false,
        data: null,
        error: 'Tool "$toolName" is not available.',
      );
    }
    try {
      return await tool.execute(arguments);
    } on Exception catch (e) {
      return ToolResult(
        success: false,
        data: null,
        error: e.toString(),
      );
    }
  }
}
