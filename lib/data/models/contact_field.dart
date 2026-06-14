// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_field.freezed.dart';
part 'contact_field.g.dart';

/// A tenant-defined typed custom field (LUMENTA_GROWTH plan §2.1).
@freezed
class ContactField with _$ContactField {
  const factory ContactField({
    required String id,
    required String key,
    required String label,
    required String type,
    List<String>? options,
    @Default(false) bool isRequired,
    @Default(0) int displayOrder,
  }) = _ContactField;

  factory ContactField.fromJson(Map<String, dynamic> json) =>
      _$ContactFieldFromJson(json);
}

/// A tenant-editable lifecycle stage (LUMENTA_GROWTH plan §2.1).
@freezed
class ContactLifecycleStage with _$ContactLifecycleStage {
  const factory ContactLifecycleStage({
    required String id,
    required String key,
    required String label,
    @Default('#B8A4FF') String color,
    @Default(0) int displayOrder,
    @Default(false) bool isDefault,
  }) = _ContactLifecycleStage;

  factory ContactLifecycleStage.fromJson(Map<String, dynamic> json) =>
      _$ContactLifecycleStageFromJson(json);
}
