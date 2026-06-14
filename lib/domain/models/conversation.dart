import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

/// A conversation thread.
@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required String title,
    String? modelId,
    String? modelName,
    @Default(false) bool archived,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastMessagePreview,
    int? tokenCountApprox,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  const Conversation._();

  /// Returns a short display title; falls back to a default if no title is set.
  String get displayTitle => title.isEmpty ? 'New chat' : title;
}
