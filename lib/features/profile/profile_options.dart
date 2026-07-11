import 'package:timezone/data/latest_10y.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Static option lists for the profile screen, mirrored from the portal
/// (`portal/src/i18n/config.ts` and `portal/src/theme/fonts.ts`) and the API
/// allow-lists (`api/src/users/font.constants.ts`). Keep them in lockstep.

class LocaleOption {
  const LocaleOption({
    required this.code,
    required this.flag,
    required this.nativeName,
  });

  final String code;
  final String flag;
  final String nativeName;

  String get label => '$flag $nativeName';
}

const supportedLocales = [
  LocaleOption(code: 'en', flag: '🇬🇧', nativeName: 'English'),
  LocaleOption(code: 'ar', flag: '🇸🇦', nativeName: 'العربية'),
  LocaleOption(code: 'fr', flag: '🇫🇷', nativeName: 'Français'),
];

class FontOption {
  const FontOption({required this.key, required this.label});

  final String key;
  final String label;
}

/// Fonts the API accepts for Latin locales (en/fr). Order matters: the server
/// snaps to the first entry when a user leaves Arabic without picking a font.
const latinFonts = [
  FontOption(key: 'fraunces', label: 'Fraunces'),
  FontOption(key: 'spectral', label: 'Spectral'),
  FontOption(key: 'bricolage-grotesque', label: 'Bricolage Grotesque'),
  FontOption(key: 'instrument-serif', label: 'Instrument Serif'),
  FontOption(key: 'schibsted-grotesk', label: 'Schibsted Grotesk'),
  FontOption(key: 'inter', label: 'Inter'),
];

/// The single font the API allows for the Arabic locale.
const arabicFonts = [FontOption(key: 'vazirmatn', label: 'Vazirmatn')];

const defaultLatinFont = 'inter';
const defaultArabicFont = 'vazirmatn';

/// Fonts selectable for [locale], matching the server's per-locale allow-list
/// (`FONT_NOT_ALLOWED` is thrown for anything else).
List<FontOption> fontsForLocale(String? locale) =>
    locale == 'ar' ? arabicFonts : latinFonts;

/// The font to preselect when the stored one isn't valid for [locale].
String defaultFontForLocale(String? locale) =>
    locale == 'ar' ? defaultArabicFont : defaultLatinFont;

class TimezoneOption {
  const TimezoneOption({required this.id, required this.offset});

  /// IANA identifier, e.g. `Africa/Cairo` — the value persisted to the API.
  final String id;
  final Duration offset;

  String get offsetLabel {
    final sign = offset.isNegative ? '-' : '+';
    final abs = offset.abs();
    final h = abs.inHours.toString().padLeft(2, '0');
    final m = (abs.inMinutes % 60).toString().padLeft(2, '0');
    return 'GMT$sign$h:$m';
  }

  String get label => '${id.replaceAll('_', ' ')} ($offsetLabel)';
}

bool _tzReady = false;
List<TimezoneOption>? _timezones;

/// All IANA zones with their *current* UTC offset, sorted by offset then name
/// (the portal builds the same list from `Intl.supportedValuesOf('timeZone')`).
/// The tz database is initialized lazily on first use — only the profile
/// screen needs it.
List<TimezoneOption> allTimezones() {
  if (_timezones != null) return _timezones!;
  if (!_tzReady) {
    tzdata.initializeTimeZones();
    _tzReady = true;
  }
  final options = tz.timeZoneDatabase.locations.entries
      .map(
        (e) => TimezoneOption(
          id: e.key,
          offset: tz.TZDateTime.now(e.value).timeZoneOffset,
        ),
      )
      .toList()
    ..sort((a, b) {
      final byOffset = a.offset.compareTo(b.offset);
      return byOffset != 0 ? byOffset : a.id.compareTo(b.id);
    });
  return _timezones = options;
}
