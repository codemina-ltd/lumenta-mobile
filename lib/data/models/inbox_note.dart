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
  }) = _InboxNote;

  const InboxNote._();

  factory InboxNote.fromJson(Map<String, dynamic> json) =>
      _$InboxNoteFromJson(json);

  DateTime? get createdAtDate =>
      createdAt == null ? null : DateTime.tryParse(createdAt!)?.toLocal();
}
