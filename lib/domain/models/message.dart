import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// The role of a message in the conversation.
enum MessageRole {
  system,
  user,
  assistant,
  tool,
}

/// A single chat message.
@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required MessageRole role,
    required String content,
    DateTime? createdAt,
    DateTime? updatedAt,
    /// Whether this message is still streaming from the API.
    @Default(false) bool isStreaming,
    /// IDs of artifacts attached to this assistant message.
    @Default(<String>[]) List<String> artifactIds,
    /// Tool call payload for assistant messages proposing tool usage.
    Map<String, dynamic>? toolCalls,
    /// Tool result payload for tool-role messages.
    Map<String, dynamic>? toolResult,
    /// Approximate token count for this message.
    int? tokenCountApprox,
    /// Id of the model that generated this (assistant) message.
    String? modelId,
    /// Human-readable name of the model that generated this message.
    String? modelName,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  const Message._();

  bool get hasArtifacts => artifactIds.isNotEmpty;
}
