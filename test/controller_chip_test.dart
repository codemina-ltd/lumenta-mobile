import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/i18n/arb/app_localizations_en.dart';
import 'package:mobile/data/models/conversation_controller.dart';
import 'package:mobile/features/chats/widgets/controller_chip.dart';

void main() {
  final l10n = AppLocalizationsEn();
  String? nameOf(String id) => id == 'u1' ? 'Sara' : null;

  group('ConversationControllerState.fromMap', () {
    test('parses every field', () {
      final s = ConversationControllerState.fromMap({
        'controller': 'human',
        'label': null,
        'assignedUserId': 'u1',
        'until': '2026-10-19T12:30:00.000Z',
      });
      expect(s.controller, ConversationControllerKind.human);
      expect(s.assignedUserId, 'u1');
      expect(s.until, DateTime.utc(2026, 10, 19, 12, 30));
    });

    test('unknown kind degrades to released', () {
      final s = ConversationControllerState.fromMap({'controller': 'alien'});
      expect(s.controller, ConversationControllerKind.released);
    });
  });

  group('controllerChipLabel', () {
    test('lume with assistant name', () {
      final s = ConversationControllerState.fromMap({
        'controller': 'lume',
        'label': 'محمد',
      });
      expect(controllerChipLabel(l10n, s, nameOf), 'Lume · محمد');
    });

    test('human resolves assignee name, falls back when unknown', () {
      final known = ConversationControllerState.fromMap({
        'controller': 'human',
        'assignedUserId': 'u1',
      });
      final unknown = ConversationControllerState.fromMap({
        'controller': 'human',
        'assignedUserId': 'u9',
      });
      expect(controllerChipLabel(l10n, known, nameOf), 'Human agent · Sara');
      expect(controllerChipLabel(l10n, unknown, nameOf), 'Human agent');
    });

    test('released ignores label', () {
      final s = ConversationControllerState.fromMap({
        'controller': 'released',
        'label': 'x',
      });
      expect(controllerChipLabel(l10n, s, nameOf), 'Released');
    });
  });
}
