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
abstract class Template with _$Template {
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

    /// Fresh presigned URL for the header media. Only present on
    /// `GET /templates/:id` (the list endpoint doesn't presign).
    String? headerMediaUrl,
    String? footerText,
    List<dynamic>? buttons,
    Object? bodyExample,
    Object? headerExample,

    /// Carousel cards — non-null marks a marketing carousel template whose
    /// [body] is the shared bubble message shown above the cards.
    List<TemplateCarouselCard>? carouselCards,
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

  bool get isCarousel => carouselCards?.isNotEmpty ?? false;
}

/// One card of a carousel template. Card text and buttons are fixed at
/// template level — variables inside a card body are filled from the stored
/// example set (same contract as the API's send path), so [renderedBody]
/// shows exactly what the recipient received.
@freezed
abstract class TemplateCarouselCard with _$TemplateCarouselCard {
  const factory TemplateCarouselCard({
    @Default('IMAGE') String headerFormat,
    @Default('') String body,
    Object? bodyExample,
    List<dynamic>? buttons,

    /// Fresh presigned URL for the card media (from `GET /templates/:id`).
    String? mediaUrl,
  }) = _TemplateCarouselCard;

  const TemplateCarouselCard._();

  factory TemplateCarouselCard.fromJson(Map<String, dynamic> json) =>
      _$TemplateCarouselCardFromJson(json);

  bool get isVideo => headerFormat == 'VIDEO';

  /// Card body with `{{n}}` placeholders replaced by the stored positional
  /// example values (`bodyExample` is `string[][]`; the first row maps
  /// index-for-index onto `{{1}}`, `{{2}}`, …).
  String get renderedBody {
    var rendered = body;
    final raw = bodyExample;
    final row = (raw is List && raw.isNotEmpty && raw.first is List)
        ? (raw.first as List)
        : const [];
    for (var i = 0; i < row.length; i++) {
      rendered = rendered.replaceAll('{{${i + 1}}}', '${row[i]}');
    }
    return rendered;
  }
}
