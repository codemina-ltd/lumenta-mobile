import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../auth/auth_controller.dart';

/// The member's effective permissions (`GET /me/permissions`) — cached for
/// the session and re-fetched whenever the active tenant changes, like
/// [tenantFeaturesProvider]. [HomeShell] watches it eagerly so the map is
/// resolved before a chat screen offers an action.
final memberPermissionsProvider = FutureProvider<Map<String, bool>>((
  ref,
) async {
  ref.watch(authControllerProvider.select((s) => s.activeTenantId));
  return ref.read(permissionsRepoProvider).getMine();
});

/// Permission keys the app gates an affordance on. The server enforces every
/// one of them; hiding the control just avoids offering an action that would
/// come back 403.
abstract final class PermissionKeys {
  static const chatAssign = 'chat_assign:edit';
  static const messageReminder = 'message_reminder:create';
  static const messageNote = 'message_note:create';
  static const messageDeleteForMe = 'message_delete_for_me:delete';
  static const messageDeleteForEveryone = 'message_delete_for_everyone:delete';
}

/// Whether the member holds [key].
///
/// A null [permissions] map (fetch pending or failed) yields true: the server
/// is the authority, so a network blip must not strip controls from a member
/// who is entitled to them. Once the map has loaded an absent key is denied,
/// matching the portal.
bool memberCan(Map<String, bool>? permissions, String key) {
  if (permissions == null) return true;
  return permissions[key] ?? false;
}
