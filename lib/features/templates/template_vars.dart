import '../../data/models/template.dart';

/// Dart port of the chat-relevant half of the portal's
/// `portal/src/utils/templateVariables.ts`. Kept in lockstep so the mobile
/// app builds byte-identical `/messages/templates` payloads to the web client.
///
/// WhatsApp templates use one of two parameter formats:
///  - `positional` — body placeholders are `{{1}}`, `{{2}}`, … and the wire
///    payload must be keyed by the numeric index ("1", "2", …).
///  - `named` — body placeholders are `{{first_name}}`, … and the payload must
///    be keyed by those names.
///
/// The *key* we send is what matters — never the human-readable label.
/// `Template.variables` holds descriptive labels for positional templates
/// (e.g. "customer name") which must NOT be used as payload keys.

/// A single fillable body variable resolved from a template.
class TemplateVarField {
  const TemplateVarField({required this.key, required this.label, this.example});

  /// Payload key sent in `templateVariables` — "1"/"2" (positional) or the name.
  final String key;

  /// Human-readable label shown next to the input — display only, never sent.
  final String label;

  /// Example value from the template's `bodyExample`, used as input placeholder.
  final String? example;
}

/// A single fillable button parameter resolved from a template.
class TemplateButtonField {
  const TemplateButtonField({
    required this.key,
    required this.label,
    required this.buttonIndex,
  });

  /// Payload key sent in `buttonVariables` — always `coupon_code`.
  final String key;
  final String label;
  final int buttonIndex;
}

final _positionalToken = RegExp(r'\{\{\s*(\d+)\s*\}\}');
final _namedToken = RegExp(r'\{\{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\}\}');

String _escape(String s) =>
    s.replaceAllMapped(RegExp(r'[.*+?^${}()|[\]\\]'), (m) => '\\${m[0]}');

/// True when the template uses positional (`{{1}}`) rather than named tokens.
bool isPositional(Template t) => t.parameterFormat != 'named';

/// Extract ordered, de-duplicated placeholder tokens from a template string.
List<String> _extractTokens(String? text, bool positional) {
  if (text == null || text.isEmpty) return const [];
  final re = positional ? _positionalToken : _namedToken;
  final seen = <String>[];
  for (final m in re.allMatches(text)) {
    final tok = m.group(1)!;
    if (!seen.contains(tok)) seen.add(tok);
  }
  if (positional) seen.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
  return seen;
}

/// Body variables the user must fill. Placeholders are parsed from `body` only
/// (the source of truth) — never the header, matching the portal.
List<TemplateVarField> templateVarFields(Template t) {
  final positional = isPositional(t);
  final tokens = _extractTokens(t.body, positional);

  if (positional) {
    // bodyExample for positional templates is string[][] — a list of example
    // sets; the first set maps index-for-index onto {{1}}, {{2}}, …
    final raw = t.bodyExample;
    final ex = (raw is List && raw.isNotEmpty && raw.first is List)
        ? List<String>.from((raw.first as List).map((e) => '$e'))
        : const <String>[];
    return tokens.map((tok) {
      final i = int.parse(tok) - 1;
      final label = (t.variables != null && i < t.variables!.length)
          ? t.variables![i].trim()
          : '';
      return TemplateVarField(
        key: tok,
        label: label.isNotEmpty ? label : '{{$tok}}',
        example: i < ex.length ? ex[i] : null,
      );
    }).toList();
  }

  // bodyExample for named templates is [{ param_name, example }].
  final raw = t.bodyExample;
  final named = (raw is List)
      ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
      : const <Map<String, dynamic>>[];
  return tokens.map((tok) {
    final hit = named.firstWhere(
      (e) => e['param_name'] == tok,
      orElse: () => const {},
    );
    return TemplateVarField(
      key: tok,
      label: tok,
      example: hit['example']?.toString(),
    );
  }).toList();
}

/// Dynamic button parameters — only COPY_CODE buttons carry a send-time value
/// (`coupon_code`); URL/QUICK_REPLY/PHONE_NUMBER buttons are static.
List<TemplateButtonField> templateButtonFields(Template t) {
  final buttons = t.buttons;
  if (buttons == null) return const [];
  final out = <TemplateButtonField>[];
  for (var i = 0; i < buttons.length; i++) {
    final b = buttons[i];
    if (b is Map && b['type'] == 'COPY_CODE') {
      out.add(TemplateButtonField(
        key: 'coupon_code',
        label: '${b['text'] ?? ''}',
        buttonIndex: i,
      ));
    }
  }
  return out;
}

/// Render a template body with filled values substituted in. Unfilled tokens
/// fall back to their human-readable label so the preview stays readable while
/// the user is still typing.
String renderPreview(Template t, Map<String, String> vars) {
  var preview = t.body;
  for (final f in templateVarFields(t)) {
    final v = vars[f.key];
    final rep = (v != null && v.trim().isNotEmpty)
        ? v
        : '{{${f.label.replaceAll(RegExp(r'[{}]'), '')}}}';
    preview = preview.replaceAll(
      RegExp(r'\{\{\s*' + _escape(f.key) + r'\s*\}\}'),
      rep,
    );
  }
  return preview;
}

/// Body variable labels whose values are still blank — for validation messages.
List<String> missingVarLabels(Template t, Map<String, String> vars) =>
    templateVarFields(t)
        .where((f) => (vars[f.key] ?? '').trim().isEmpty)
        .map((f) => f.label)
        .toList();

/// Button parameter labels whose values are still blank.
List<String> missingButtonLabels(Template t, Map<String, String> btn) =>
    templateButtonFields(t)
        .where((f) => (btn[f.key] ?? '').trim().isEmpty)
        .map((f) => f.label)
        .toList();
