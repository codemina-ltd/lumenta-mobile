/// Turns a flow's JSON definition into display metadata for its submitted
/// fields, so responses render the way the customer saw the form — labels
/// instead of keys, option titles instead of ids — with graceful fallbacks
/// for fields the definition no longer describes (renamed/deleted fields,
/// deleted flows). A direct Dart port of the portal's
/// `pages/Flows/responses/fieldMeta.ts`, kept behaviour-compatible so both
/// clients resolve a submission the same way.
library;

import 'dart:convert';

import '../data/models/flow.dart';

/// How a submitted value should be rendered.
enum FlowFieldKind {
  text,
  number,
  longtext,
  date,
  singleSelect,
  multiSelect,
  boolean,
  media,
  unknown,
}

class FlowFieldMeta {
  const FlowFieldMeta({
    required this.key,
    required this.label,
    required this.kind,
    this.options,
  });

  final String key;
  final String label;
  final FlowFieldKind kind;

  /// Option id → display title, when the component had a static data-source.
  final Map<String, String>? options;
}

/// Reserved / plumbing keys that must never surface in the UI: the correlation
/// token and the preference-center signals the platform consumes itself.
final RegExp _internalKeyRe = RegExp(r'^(flow_token|lumenta_)');

bool isInternalFlowKey(String key) => _internalKeyRe.hasMatch(key);

/// "delivery_date" / "0_Delivery_date" → "Delivery date".
String humanizeFlowKey(String key) {
  final cleaned = key
      .replaceFirst(RegExp(r'^\d+_'), '')
      .replaceAll(RegExp(r'[_-]+'), ' ')
      .trim();
  if (cleaned.isEmpty) return key;
  return cleaned[0].toUpperCase() + cleaned.substring(1);
}

/// Component type → render kind for everything that captures user input.
FlowFieldKind? _componentKind(Map<String, dynamic> component) {
  final type = component['type'];
  if (type is! String) return null;
  switch (type) {
    case 'TextInput':
      return component['input-type'] == 'number'
          ? FlowFieldKind.number
          : FlowFieldKind.text;
    case 'TextArea':
      return FlowFieldKind.longtext;
    case 'DatePicker':
    case 'CalendarPicker':
      return FlowFieldKind.date;
    case 'Dropdown':
    case 'RadioButtonsGroup':
      return FlowFieldKind.singleSelect;
    case 'CheckboxGroup':
    case 'ChipsSelector':
      return FlowFieldKind.multiSelect;
    case 'OptIn':
      return FlowFieldKind.boolean;
    case 'PhotoPicker':
    case 'DocumentPicker':
      return FlowFieldKind.media;
    default:
      // Any future/unmodelled component that still captures a named value.
      return component['name'] is String && component['label'] is String
          ? FlowFieldKind.unknown
          : null;
  }
}

Map<String, String>? _optionsFromDataSource(Map<String, dynamic> component) {
  final source = component['data-source'];
  // Dynamic data-sources are `${data.x}` bindings — no static titles to map.
  if (source is! List) return null;
  final options = <String, String>{};
  for (final entry in source) {
    if (entry is Map && entry['id'] is String) {
      final id = entry['id'] as String;
      final title = entry['title'];
      options[id] = title is String ? title : id;
    }
  }
  return options.isEmpty ? null : options;
}

void _walkComponents(dynamic children, Map<String, FlowFieldMeta> out) {
  if (children is! List) return;
  for (final child in children) {
    if (child is! Map) continue;
    final map = Map<String, dynamic>.from(child);

    final kind = _componentKind(map);
    final name = map['name'];
    if (kind != null && name is String && !out.containsKey(name)) {
      final label = map['label'];
      out[name] = FlowFieldMeta(
        key: name,
        label: label is String && label.trim().isNotEmpty
            ? label
            : humanizeFlowKey(name),
        kind: kind,
        options: _optionsFromDataSource(map),
      );
    }

    // Containers and branches that can hold further input components.
    _walkComponents(map['children'], out);
    _walkComponents(map['then'], out);
    _walkComponents(map['else'], out);
    final cases = map['cases'];
    if (cases is List) {
      for (final c in cases) {
        if (c is Map) _walkComponents(c['then'], out);
      }
    }
  }
}

/// Ordered field metadata from a flow's JSON, following the screen order the
/// customer experienced. Returns [] for missing/invalid JSON.
List<FlowFieldMeta> extractFlowFields(String? flowJson) {
  if (flowJson == null || flowJson.isEmpty) return const [];
  dynamic parsed;
  try {
    parsed = jsonDecode(flowJson);
  } catch (_) {
    return const [];
  }
  if (parsed is! Map || parsed['screens'] is! List) return const [];

  final out = <String, FlowFieldMeta>{};
  for (final screen in parsed['screens'] as List) {
    if (screen is! Map) continue;
    final layout = screen['layout'];
    if (layout is Map) _walkComponents(layout['children'], out);
  }
  return out.values.toList();
}

/// Choose the field metadata for a single submission. The message carries no
/// flow id, so this falls back to the flow whose defined field keys overlap
/// the submitted keys the most — answers still render with real labels as long
/// as any schema-compatible flow survives, including when the original flow
/// was deleted. Returns [] when nothing matches, letting callers degrade to
/// humanized keys.
List<FlowFieldMeta> matchFlowFields(
  List<Flow> flows,
  Map<String, dynamic> response,
) {
  final keys = response.keys.where((k) => !isInternalFlowKey(k)).toList();
  if (keys.isEmpty) return const [];
  List<FlowFieldMeta> best = const [];
  var bestScore = 0;
  for (final flow in flows) {
    final fields = extractFlowFields(flow.flowJson);
    if (fields.isEmpty) continue;
    final known = fields.map((f) => f.key).toSet();
    final score = keys.where(known.contains).length;
    if (score > bestScore) {
      bestScore = score;
      best = fields;
    }
  }
  return best;
}

/// Every field the flow defines, plus any extra keys present in the submission
/// that the definition doesn't know (field renamed, flow edited after the
/// submission, deleted flow). Internal plumbing keys are dropped.
List<FlowFieldMeta> buildDisplayFlowFields(
  List<FlowFieldMeta> metaFields,
  Map<String, dynamic> response,
) {
  final fields = [...metaFields];
  final known = metaFields.map((f) => f.key).toSet();
  for (final key in response.keys) {
    if (known.contains(key) || isInternalFlowKey(key)) continue;
    known.add(key);
    fields.add(
      FlowFieldMeta(
        key: key,
        label: humanizeFlowKey(key),
        kind: FlowFieldKind.unknown,
      ),
    );
  }
  return fields;
}

// ─── Value coercion helpers (shared by the detail renderer) ───

/// Accepts real arrays and JSON-stringified arrays ('["a","b"]').
List<dynamic>? flowValueAsArray(dynamic value) {
  if (value is List) return value;
  if (value is String && value.trim().startsWith('[')) {
    try {
      final parsed = jsonDecode(value);
      return parsed is List ? parsed : null;
    } catch (_) {
      return null;
    }
  }
  return null;
}

/// WhatsApp DatePickers submit epoch-milliseconds as a string; endpoint-driven
/// flows may echo ISO/`YYYY-MM-DD` strings instead. Returns null when the
/// value doesn't look like a date at all.
DateTime? flowParseDate(dynamic value) {
  if (value is num) {
    return DateTime.fromMillisecondsSinceEpoch(value.toInt());
  }
  if (value is! String || value.trim().isEmpty) return null;
  final trimmed = value.trim();
  if (RegExp(r'^\d{10,}$').hasMatch(trimmed)) {
    final ms = int.tryParse(trimmed);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }
  return DateTime.tryParse(trimmed);
}

bool flowParseBoolean(dynamic value) =>
    value == true || value == 'true' || value == '1' || value == 1;

/// Normalises one PhotoPicker/DocumentPicker entry to a display name.
String? flowMediaName(dynamic value) {
  if (value is Map) {
    final name = value['file_name'] ?? value['filename'] ?? value['name'];
    return name is String && name.isNotEmpty ? name : null;
  }
  return value is String && value.isNotEmpty ? value : null;
}

/// Maps a select id to its display title, prettifying unmapped raw ids.
String flowSelectLabel(dynamic value, Map<String, String>? options) {
  final raw = value.toString();
  final mapped = options?[raw];
  if (mapped != null) return mapped;
  // Meta's own builder emits ids like "0_Option_title" — prettify those.
  return RegExp(r'^\d+_').hasMatch(raw) ? humanizeFlowKey(raw) : raw;
}

/// Display labels for a multi-select value, one per chip. Empty when nothing
/// was selected or the value isn't array-shaped.
List<String> flowMultiSelectLabels(FlowFieldMeta field, dynamic value) {
  final arr = flowValueAsArray(value);
  if (arr == null) return const [];
  return arr.map((v) => flowSelectLabel(v, field.options)).toList();
}

/// A single-line display string for a submitted value, resolving option ids to
/// titles, booleans to yes/no, and dates via [formatDate]. Multi-select values
/// are joined with ", " — callers that render chips should use
/// [flowMultiSelectLabels] instead.
String flowDisplayValue(
  FlowFieldMeta field,
  dynamic value, {
  required String yes,
  required String no,
  required String Function(DateTime) formatDate,
}) {
  if (value == null) return '';
  switch (field.kind) {
    case FlowFieldKind.boolean:
      return flowParseBoolean(value) ? yes : no;
    case FlowFieldKind.date:
      final date = flowParseDate(value);
      return date != null ? formatDate(date) : value.toString();
    case FlowFieldKind.singleSelect:
      return flowSelectLabel(value, field.options);
    case FlowFieldKind.multiSelect:
      return flowMultiSelectLabels(field, value).join(', ');
    case FlowFieldKind.media:
      return flowMediaName(value) ?? '';
    case FlowFieldKind.text:
    case FlowFieldKind.number:
    case FlowFieldKind.longtext:
    case FlowFieldKind.unknown:
      if (value is Map || value is List) return jsonEncode(value);
      return value.toString();
  }
}
