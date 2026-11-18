import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/shared/member_permissions.dart';

void main() {
  group('memberCan', () {
    test('fails open while the permission map is unavailable', () {
      expect(memberCan(null, PermissionKeys.messageDeleteForMe), isTrue);
      expect(memberCan(null, PermissionKeys.chatAssign), isTrue);
    });

    test('reads the key once the map has loaded', () {
      final permissions = {
        PermissionKeys.messageReminder: true,
        PermissionKeys.messageDeleteForEveryone: false,
      };
      expect(memberCan(permissions, PermissionKeys.messageReminder), isTrue);
      expect(
        memberCan(permissions, PermissionKeys.messageDeleteForEveryone),
        isFalse,
      );
    });

    test('denies a key missing from a loaded map', () {
      expect(memberCan(const {}, PermissionKeys.messageNote), isFalse);
    });
  });
}
