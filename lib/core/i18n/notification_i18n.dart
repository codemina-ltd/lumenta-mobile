/// Resolves server-provided notification i18n keys (e.g. `message.received.title`)
/// against the same `notifications` namespace the web portal uses. The server
/// stores keys + params rather than rendered text, so the client owns the
/// translations. Params use the portal's i18next `{{name}}` interpolation.
class NotificationI18n {
  const NotificationI18n._();

  // locale -> key -> template
  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'message.received.title': 'New message from {{clientName}}',
      'message.received.body': '{{clientName}}: {{preview}}',
    },
    'ar': {
      'message.received.title': 'رسالة جديدة من {{clientName}}',
      'message.received.body': '{{clientName}}: {{preview}}',
    },
    'fr': {
      'message.received.title': 'Nouveau message de {{clientName}}',
      'message.received.body': '{{clientName}} : {{preview}}',
    },
  };

  /// Translate [key] for [localeCode], interpolating [params]. Falls back to the
  /// English template, then to the raw key, so the UI never shows nothing.
  static String resolve(
    String localeCode,
    String key,
    Map<String, Object?> params,
  ) {
    final table = _strings[localeCode] ?? _strings['en']!;
    final template = table[key] ?? _strings['en']![key] ?? key;
    return _interpolate(template, params);
  }

  static String _interpolate(String template, Map<String, Object?> params) {
    var out = template;
    params.forEach((k, v) {
      out = out.replaceAll('{{$k}}', '${v ?? ''}');
    });
    return out;
  }
}
