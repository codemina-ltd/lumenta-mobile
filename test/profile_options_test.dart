import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/profile/profile_options.dart';

void main() {
  group('fonts', () {
    test('Arabic locale allows only Vazirmatn', () {
      final fonts = fontsForLocale('ar');
      expect(fonts, hasLength(1));
      expect(fonts.single.key, 'vazirmatn');
      expect(defaultFontForLocale('ar'), 'vazirmatn');
    });

    test('Latin locales get the portal font list with inter as default', () {
      for (final locale in ['en', 'fr', null]) {
        final keys = fontsForLocale(locale).map((f) => f.key).toList();
        expect(keys, contains('inter'));
        expect(keys, contains('fraunces'));
        expect(keys, isNot(contains('vazirmatn')));
        expect(defaultFontForLocale(locale), 'inter');
      }
    });
  });

  group('timezones', () {
    test('contains well-known IANA zones, sorted by offset then name', () {
      final zones = allTimezones();
      final ids = zones.map((z) => z.id).toSet();
      expect(ids, containsAll(['UTC', 'Africa/Cairo', 'Europe/London']));
      for (var i = 1; i < zones.length; i++) {
        final byOffset = zones[i - 1].offset.compareTo(zones[i].offset);
        expect(
          byOffset < 0 ||
              (byOffset == 0 && zones[i - 1].id.compareTo(zones[i].id) < 0),
          isTrue,
          reason: '${zones[i - 1].id} should sort before ${zones[i].id}',
        );
      }
    });

    test('offset labels render as GMT±HH:MM', () {
      const utc = TimezoneOption(id: 'UTC', offset: Duration.zero);
      expect(utc.offsetLabel, 'GMT+00:00');
      const kabul = TimezoneOption(
        id: 'Asia/Kabul',
        offset: Duration(hours: 4, minutes: 30),
      );
      expect(kabul.offsetLabel, 'GMT+04:30');
      const ny = TimezoneOption(
        id: 'America/New_York',
        offset: Duration(hours: -5),
      );
      expect(ny.offsetLabel, 'GMT-05:00');
      expect(ny.label, 'America/New York (GMT-05:00)');
    });
  });
}
