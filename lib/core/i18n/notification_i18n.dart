import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Resolves server-provided notification i18n keys (e.g. `campaign.completed.title`)
/// against the same `notifications` namespace the web portal uses. The server
/// stores keys + params rather than rendered text, so the client owns the
/// translations. Params use the portal's i18next `{{name}}` interpolation.
///
/// Strings are loaded once from the bundled asset JSONs (mirrored from the
/// portal's `notifications.json`) and flattened to dotted keys.
class NotificationI18n {
  const NotificationI18n._();

  static const _locales = ['en', 'ar', 'fr'];

  // locale -> flattened dotted key -> template
  static final Map<String, Map<String, String>> _strings = {};
  static bool _loaded = false;

  /// Load and flatten the notification string bundles. Call once at startup.
  static Future<void> load() async {
    if (_loaded) return;
    for (final locale in _locales) {
      try {
        final raw = await rootBundle.loadString(
          'assets/i18n/notifications/$locale.json',
        );
        final json = jsonDecode(raw) as Map<String, dynamic>;
        final flat = <String, String>{};
        _flatten(json, '', flat);
        _strings[locale] = flat;
      } catch (_) {
        _strings[locale] = {};
      }
    }
    _loaded = true;
  }

  /// Translate [key] for [localeCode], interpolating [params]. Falls back to the
  /// English template, then to the raw key, so the UI never shows nothing.
  static String resolve(
    String localeCode,
    String key,
    Map<String, Object?> params,
  ) {
    final table = _strings[localeCode] ?? _strings['en'] ?? const {};
    final template = table[key] ?? _strings['en']?[key] ?? key;
    return _interpolate(template, params);
  }

  static void _flatten(
    Map<String, dynamic> node,
    String prefix,
    Map<String, String> out,
  ) {
    node.forEach((k, v) {
      final path = prefix.isEmpty ? k : '$prefix.$k';
      if (v is String) {
        out[path] = v;
      } else if (v is Map<String, dynamic>) {
        _flatten(v, path, out);
      }
    });
  }

  static String _interpolate(String template, Map<String, Object?> params) {
    var out = template;
    params.forEach((k, v) {
      out = out.replaceAll('{{$k}}', '${v ?? ''}');
    });
    return out;
  }
}
