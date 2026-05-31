import 'package:freezed_annotation/freezed_annotation.dart';

part 'template.freezed.dart';
part 'template.g.dart';

/// A WhatsApp message template from `GET /v1/templates`.
///
/// Mirrors the portal's `Template` type (`portal/src/types`) closely enough to
/// reuse the same variable-resolution conventions — see `template_vars.dart`.
/// `bodyExample` / `headerExample` are polymorphic on the wire (`string[][]`
/// for positional templates, `{ param_name, example }[]` for named ones), so
/// they stay untyped here and are interpreted in the util.
@freezed
class Template with _$Template {
  const factory Template({
    required String id,
    @Default('') String name,
    @Default('') String category,
    @Default('') String language,
    @Default('') String status,
    @Default('positional') String parameterFormat,
    @Default('') String body,
    List<String>? variables,
    String? headerFormat,
    String? headerText,
    String? headerS3Key,
    String? footerText,
    List<dynamic>? buttons,
    Object? bodyExample,
    Object? headerExample,
  }) = _Template;

  const Template._();

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);

  /// True when the template's header carries media (image/video/document)
  /// rather than text — the picker shows a chip for these in v1.
  bool get hasMediaHeader =>
      headerFormat == 'IMAGE' ||
      headerFormat == 'VIDEO' ||
      headerFormat == 'DOCUMENT';
}
