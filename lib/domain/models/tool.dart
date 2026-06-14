import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool.freezed.dart';
part 'tool.g.dart';

/// The result of executing a tool.
@freezed
class ToolResult with _$ToolResult {
  const factory ToolResult({
    required bool success,
    required dynamic data,
    String? error,
  }) = _ToolResult;

  factory ToolResult.fromJson(Map<String, dynamic> json) =>
      _$ToolResultFromJson(json);
}

/// Definition of a tool that can be exposed to an LLM.
abstract class Tool {
  String get name;
  String get description;
  Map<String, dynamic> get parameters;

  Future<ToolResult> execute(Map<String, dynamic> arguments);
}

/// A lightweight DTO describing a tool call returned by the model.
@freezed
class ToolCall with _$ToolCall {
  const factory ToolCall({
    required String id,
    required String name,
    required Map<String, dynamic> arguments,
  }) = _ToolCall;

  factory ToolCall.fromJson(Map<String, dynamic> json) =>
      _$ToolCallFromJson(json);
}
