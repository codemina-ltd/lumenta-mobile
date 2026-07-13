// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbox_label.freezed.dart';
part 'inbox_label.g.dart';

/// A tenant-defined label applied to inbox threads (LUMENTA_GROWTH plan §1.1).
@freezed
abstract class InboxLabel with _$InboxLabel {
  const factory InboxLabel({
    required String id,
    required String name,
    @Default('#00C896') String color,
  }) = _InboxLabel;

  factory InboxLabel.fromJson(Map<String, dynamic> json) =>
      _$InboxLabelFromJson(json);
}
