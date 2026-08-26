// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbox_note.freezed.dart';
part 'inbox_note.g.dart';

/// An internal-only note on a thread (LUMENTA_GROWTH plan §1.1). Never sent to
/// the customer.
@freezed
abstract class InboxNote with _$InboxNote {
  const factory InboxNote({
    required String id,
    required String threadId,
    required String authorUserId,
    required String body,
    String? createdAt,
    /// KAN-186 — emoji reactions aggregated by the API (read-only here).
    @Default(<InboxNoteReaction>[]) List<InboxNoteReaction> reactions,
  }) = _InboxNote;

  const InboxNote._();

  factory InboxNote.fromJson(Map<String, dynamic> json) =>
      _$InboxNoteFromJson(json);

  DateTime? get createdAtDate =>
      createdAt == null ? null : DateTime.tryParse(createdAt!)?.toLocal();
}

/// KAN-186 — one emoji on a note: how many reacted, who, and whether the
/// signed-in member is among them.
@freezed
abstract class InboxNoteReaction with _$InboxNoteReaction {
  const factory InboxNoteReaction({
    required String emoji,
    @Default(0) int count,
    @Default(<String>[]) List<String> userIds,
    @Default(false) bool reactedByMe,
  }) = _InboxNoteReaction;

  factory InboxNoteReaction.fromJson(Map<String, dynamic> json) =>
      _$InboxNoteReactionFromJson(json);
}
