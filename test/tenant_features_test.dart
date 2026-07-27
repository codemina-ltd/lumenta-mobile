import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/shared/tenant_features.dart';

void main() {
  group('channelFeatureEnabled', () {
    test('fails open when the flags are unavailable', () {
      expect(channelFeatureEnabled(null, 'instagram'), isTrue);
      expect(channelFeatureEnabled(null, 'email'), isTrue);
    });

    test('WhatsApp is never gated', () {
      expect(
        channelFeatureEnabled({'channel_instagram': false}, 'whatsapp'),
        isTrue,
      );
      expect(channelFeatureEnabled(const {}, 'whatsapp'), isTrue);
    });

    test('reads the channel_<type> key', () {
      final flags = {
        'channel_instagram': true,
        'channel_messenger': false,
        'channel_sms': false,
        'channel_email': true,
      };
      expect(channelFeatureEnabled(flags, 'instagram'), isTrue);
      expect(channelFeatureEnabled(flags, 'messenger'), isFalse);
      expect(channelFeatureEnabled(flags, 'sms'), isFalse);
      expect(channelFeatureEnabled(flags, 'email'), isTrue);
    });

    test('an absent key fails open (data-gating decides)', () {
      expect(channelFeatureEnabled({'team_inbox': true}, 'instagram'), isTrue);
    });
  });

  group('allChannelFeaturesDisabled', () {
    test('true only when every channel flag is an explicit false', () {
      expect(
        allChannelFeaturesDisabled({
          'channel_instagram': false,
          'channel_messenger': false,
          'channel_sms': false,
          'channel_email': false,
        }),
        isTrue,
      );
      expect(
        allChannelFeaturesDisabled({
          'channel_instagram': true,
          'channel_messenger': false,
          'channel_sms': false,
          'channel_email': false,
        }),
        isFalse,
      );
      // Absent keys fail open, so a partial map is not "all disabled".
      expect(
        allChannelFeaturesDisabled({'channel_instagram': false}),
        isFalse,
      );
      expect(allChannelFeaturesDisabled(null), isFalse);
    });
  });
}
