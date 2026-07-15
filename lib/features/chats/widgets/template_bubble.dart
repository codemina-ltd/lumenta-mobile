import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/message.dart';
import '../../../data/models/template.dart';
import '../chat_providers.dart';

/// WhatsApp's action-link blue for template buttons — light/dark variants
/// tuned for contrast on the bubble surfaces.
Color _actionColor(BuildContext context) =>
    context.scheme.brightness == Brightness.light
    ? const Color(0xFF0277BD)
    : const Color(0xFF64B5F6);

/// Rich rendering of an outbound template message: header (text or media),
/// formatted body, footer, buttons (first three + "See all options"), and
/// the swipeable card strip for carousel templates. Falls back to the plain
/// body text while the template loads, on fetch failure, or for legacy /
/// external messages that carry no internal template id — so the bubble is
/// never worse than before.
class TemplateMessageContent extends ConsumerWidget {
  const TemplateMessageContent({
    super.key,
    required this.message,
    required this.textColor,
  });

  final Message message;
  final Color textColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templateId = message.templateId;
    if (templateId == null) return _plainBody();

    final async = ref.watch(chatTemplateProvider(templateId));
    final template = async.asData?.value;
    if (template == null) return _plainBody();

    return TemplateContentView(
      template: template,
      body: message.body,
      textColor: textColor,
    );
  }

  Widget _plainBody() => Text(
    message.body.isEmpty ? '…' : message.body,
    textDirection: Fmt.textDirectionFor(message.body),
    style: TextStyle(color: textColor, fontSize: 15, height: 1.35),
  );
}

/// The visible content of a template message — header (text or media),
/// formatted body, footer, buttons, and the carousel strip — factored out so
/// both the sent-message bubble ([TemplateMessageContent]) and the
/// send-template preview render pixel-identically. [body] is the already
/// personalised text (the sent message body, or the live-filled preview);
/// [template] supplies the structure and presigned media.
class TemplateContentView extends StatelessWidget {
  const TemplateContentView({
    super.key,
    required this.template,
    required this.body,
    required this.textColor,
    this.sidePadding = 0,
    this.topPadding = 0,
  });

  final Template template;
  final String body;
  final Color textColor;

  /// Extra horizontal inset applied to every section EXCEPT a media header, so
  /// the header image/video can sit closer to the bubble edges than the body
  /// text. Callers that shrink the bubble's own horizontal padding pass the
  /// difference here to hold the body at its original inset. Zero (the default,
  /// used by the sent-message bubble) keeps media and body on one shared inset.
  final double sidePadding;

  /// Extra top inset applied to the content ONLY when no media header leads, so
  /// a media header (which always leads) can hug the top edge while a text or
  /// bodied template keeps its original top padding. Callers that shrink the
  /// bubble's own top padding pass the difference here. Zero by default.
  final double topPadding;

  /// Whether the header is media (image/video/document/location) rather than
  /// text — media bleeds toward the edges; a text header aligns with the body.
  bool get _hasMediaHeader {
    final format = template.headerFormat;
    return !template.isCarousel &&
        format != null &&
        format.isNotEmpty &&
        format != 'TEXT';
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeader = _hasMediaHeader ? _header(context, template) : null;

    // Everything but a media header shares the body's inset; the media header
    // (when present) sits outside it, closer to the bubble edges.
    final content = Padding(
      padding: EdgeInsets.only(
        left: sidePadding,
        right: sidePadding,
        // A leading media header hugs the top; a leading text/body keeps its
        // original top inset.
        top: mediaHeader == null ? topPadding : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (mediaHeader == null && !template.isCarousel)
            ...?_header(context, template),
          _formattedText(body, textColor, fontSize: 15),
          if (!template.isCarousel &&
              (template.footerText?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 4),
            Text(
              template.footerText!,
              textDirection: Fmt.textDirectionFor(template.footerText!),
              style: TextStyle(
                color: textColor.withValues(alpha: 0.65),
                fontSize: 12,
              ),
            ),
          ],
          if (template.isCarousel)
            Padding(
              padding: const EdgeInsets.only(top: Insets.sm),
              child: _CarouselStrip(cards: template.carouselCards!),
            )
          else if (template.buttons?.isNotEmpty ?? false)
            _TemplateButtons(buttons: template.buttons!, textColor: textColor),
        ],
      ),
    );

    if (mediaHeader == null) return content;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [...mediaHeader, content],
    );
  }

  /// Header widgets for standard templates, or null when the template has
  /// no header.
  List<Widget>? _header(BuildContext context, Template t) {
    final format = t.headerFormat;
    if (format == null || format.isEmpty) return null;
    final l10n = AppLocalizations.of(context);

    if (format == 'TEXT') {
      final text = _renderHeaderText(t);
      if (text.isEmpty) return null;
      return [
        Text(
          text,
          textDirection: Fmt.textDirectionFor(text),
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
      ];
    }

    if (format == 'IMAGE' && (t.headerMediaUrl?.isNotEmpty ?? false)) {
      return [
        ClipRRect(
          borderRadius: BorderRadius.circular(Radii.sm),
          // Fill the bubble's content width (matching the portal's
          // `width: 100%` header media) instead of a fixed tile, so the media
          // spans the bubble when a long body widens it.
          child: CachedNetworkImage(
            imageUrl: t.headerMediaUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 170,
            placeholder: (_, _) => Container(
              width: double.infinity,
              height: 170,
              color: Colors.black.withValues(alpha: 0.05),
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, _, _) => _mediaPlaceholder(
              Icons.image_rounded,
              l10n.templateImageHeader,
            ),
          ),
        ),
        const SizedBox(height: 6),
      ];
    }

    final (icon, label) = switch (format) {
      'IMAGE' => (Icons.image_rounded, l10n.templateImageHeader),
      'VIDEO' => (Icons.play_circle_fill_rounded, l10n.previewVideo),
      'DOCUMENT' => (Icons.insert_drive_file_rounded, l10n.previewDocument),
      _ => (Icons.location_on_rounded, l10n.previewLocation),
    };
    return [_mediaPlaceholder(icon, label), const SizedBox(height: 6)];
  }

  Widget _mediaPlaceholder(IconData icon, String label) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor.withValues(alpha: 0.6), size: 30),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// TEXT header with its single `{{n}}` placeholder filled from the stored
  /// example values (header variables aren't fillable at send time).
  String _renderHeaderText(Template t) {
    var text = t.headerText ?? '';
    final raw = t.headerExample;
    if (raw is List) {
      for (var i = 0; i < raw.length; i++) {
        final v = raw[i];
        if (v is String) text = text.replaceAll('{{${i + 1}}}', v);
      }
    }
    return text;
  }
}

/// Body text with WhatsApp's single-level inline styling applied:
/// `*bold*`, `_italic_`, `~strike~`.
Widget _formattedText(
  String text,
  Color color, {
  double fontSize = 14,
  int? maxLines,
}) {
  final base = TextStyle(color: color, fontSize: fontSize, height: 1.35);
  return Text.rich(
    TextSpan(children: _waSpans(text.isEmpty ? '…' : text, base)),
    textDirection: Fmt.textDirectionFor(text),
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
  );
}

final _waTokens = RegExp(r'(\*[^*\n]+\*|_[^_\n]+_|~[^~\n]+~)');

List<TextSpan> _waSpans(String text, TextStyle base) {
  final spans = <TextSpan>[];
  var index = 0;
  for (final match in _waTokens.allMatches(text)) {
    if (match.start > index) {
      spans.add(TextSpan(text: text.substring(index, match.start)));
    }
    final token = match.group(0)!;
    final inner = token.substring(1, token.length - 1);
    spans.add(
      TextSpan(
        text: inner,
        style: switch (token[0]) {
          '*' => base.copyWith(fontWeight: FontWeight.w700),
          '_' => base.copyWith(fontStyle: FontStyle.italic),
          _ => base.copyWith(decoration: TextDecoration.lineThrough),
        },
      ),
    );
    index = match.end;
  }
  if (index < text.length) spans.add(TextSpan(text: text.substring(index)));
  return spans;
}

IconData _buttonIcon(String? type) => switch (type) {
  'URL' => Icons.open_in_new_rounded,
  'PHONE_NUMBER' => Icons.phone_rounded,
  'COPY_CODE' => Icons.copy_rounded,
  _ => Icons.reply_rounded,
};

/// Template buttons attached below the bubble body, WhatsApp-style: hairline
/// separators, action-blue label. The first three show inline; more collapse
/// behind a "See all options" row that opens a bottom sheet.
class _TemplateButtons extends StatelessWidget {
  const _TemplateButtons({required this.buttons, required this.textColor});

  final List<dynamic> buttons;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final collapsed = buttons.length > 3;
    final shown = collapsed ? buttons.sublist(0, 2) : buttons;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 6),
        for (final button in shown)
          _row(
            context,
            icon: _buttonIcon(button is Map ? '${button['type']}' : null),
            label: button is Map ? '${button['text'] ?? '…'}' : '…',
          ),
        if (collapsed)
          _row(
            context,
            icon: Icons.format_list_bulleted_rounded,
            label: l10n.templateSeeAllOptions,
            onTap: () => _showAll(context),
          ),
      ],
    );
  }

  Widget _row(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final action = _actionColor(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: textColor.withValues(alpha: 0.15)),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: action),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: Fmt.textDirectionFor(label),
                style: TextStyle(
                  color: action,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAll(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.lg,
                0,
                Insets.lg,
                Insets.sm,
              ),
              child: Text(
                l10n.templateAllOptionsTitle,
                style: ctx.text.titleMedium,
              ),
            ),
            for (final button in buttons)
              ListTile(
                dense: true,
                leading: Icon(
                  _buttonIcon(button is Map ? '${button['type']}' : null),
                  color: _actionColor(ctx),
                  size: 20,
                ),
                title: Text(button is Map ? '${button['text'] ?? '…'}' : '…'),
              ),
            const SizedBox(height: Insets.sm),
          ],
        ),
      ),
    );
  }
}

/// Swipeable carousel card strip with page-dot indicators — the mobile
/// counterpart of the portal previews' CarouselStrip. Card text and buttons
/// render with their stored sample values, matching what was actually sent.
class _CarouselStrip extends StatefulWidget {
  const _CarouselStrip({required this.cards});

  final List<TemplateCarouselCard> cards;

  @override
  State<_CarouselStrip> createState() => _CarouselStripState();
}

class _CarouselStripState extends State<_CarouselStrip> {
  final _controller = PageController(viewportFraction: 0.88);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Meta requires a uniform button structure across cards, so the first
    // card's button count sizes every page.
    final buttonCount = widget.cards.first.buttons?.length ?? 0;
    final height = 96.0 + 68 + buttonCount * 32;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          width: 250,
          child: PageView.builder(
            controller: _controller,
            padEnds: false,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: widget.cards.length,
            itemBuilder: (context, i) => Padding(
              padding: EdgeInsetsDirectional.only(
                end: Insets.sm,
                start: i == 0 ? 0 : 0,
              ),
              child: _CarouselCard(card: widget.cards[i]),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.cards.length; i++)
              AnimatedContainer(
                duration: Motion.fast,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: i == _page ? 14 : 5,
                height: 5,
                decoration: BoxDecoration(
                  color: i == _page
                      ? _actionColor(context)
                      : context.scheme.onSurface.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(Radii.pill),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({required this.card});

  final TemplateCarouselCard card;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final isLight = scheme.brightness == Brightness.light;
    final surface = isLight ? Colors.white : scheme.surfaceContainerHigh;
    final onSurface = scheme.onSurface;
    final action = _actionColor(context);
    final buttons = card.buttons ?? const [];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(Radii.md),
        border: isLight
            ? Border.all(color: Colors.black.withValues(alpha: 0.06))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Media header — image renders inline; video (or missing media)
          // shows a dark play tile.
          if (!card.isVideo && (card.mediaUrl?.isNotEmpty ?? false))
            CachedNetworkImage(
              imageUrl: card.mediaUrl!,
              fit: BoxFit.cover,
              height: 96,
              placeholder: (_, _) => Container(
                height: 96,
                color: Colors.black.withValues(alpha: 0.05),
              ),
              errorWidget: (_, _, _) => _mediaTile(context),
            )
          else
            _mediaTile(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Insets.sm, 6, Insets.sm, 4),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: _formattedText(
                  card.renderedBody,
                  onSurface,
                  fontSize: 13,
                  maxLines: 3,
                ),
              ),
            ),
          ),
          for (final button in buttons)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: onSurface.withValues(alpha: 0.1)),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _buttonIcon(button is Map ? '${button['type']}' : null),
                    size: 13,
                    color: action,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      button is Map ? '${button['text'] ?? '…'}' : '…',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: action,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _mediaTile(BuildContext context) {
    final isVideo = card.isVideo;
    return Container(
      height: 96,
      color: isVideo ? const Color(0xFF233138) : const Color(0xFFDFE5E7),
      child: Icon(
        isVideo ? Icons.play_circle_fill_rounded : Icons.image_rounded,
        color: isVideo ? const Color(0xFFE9EDEF) : const Color(0xFF8696A0),
        size: 30,
      ),
    );
  }
}
