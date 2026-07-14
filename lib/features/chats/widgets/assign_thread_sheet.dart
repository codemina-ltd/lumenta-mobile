import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../data/models/inbox_thread.dart';
import '../../../data/repos/tenant_repo.dart';
import '../../auth/auth_controller.dart';
import '../../inbox/inbox_controller.dart';
import '../chat_providers.dart';

/// Sentinels for the picker: distinguish "Assign to me" / "Unassign" from a
/// dismissed sheet and from real member ids.
const _kAssignMe = '__assign_me__';
const _kUnassign = '__unassign__';

/// Assign-to-team-member sheet for the chat screen — the same semantics as
/// the inbox tab's actions: everyone can claim a thread, OWNER/ADMIN can also
/// assign any member or unassign. Mutations go straight to the repo (the chat
/// screen holds no inbox list state) and the resolved-thread provider is
/// invalidated so the app-bar action reflects the new assignee.
Future<void> showAssignThreadSheet(
  BuildContext context,
  WidgetRef ref,
  InboxThread thread,
) async {
  final l10n = AppLocalizations.of(context);
  final auth = ref.read(authControllerProvider);
  final role = auth.activeTenant?.role?.toUpperCase();
  final isAdmin = role == 'OWNER' || role == 'ADMIN';
  final myId = auth.user?.id;

  // Member names label the current assignee for everyone; admins also get
  // the pick list. A failed fetch degrades to claim/unassign only.
  List<TenantMemberLite> members;
  try {
    members = await ref.read(tenantMembersProvider.future);
  } catch (_) {
    // Drop the cached failure so the next open can retry the fetch.
    ref.invalidate(tenantMembersProvider);
    members = const [];
  }
  if (!context.mounted) return;

  final assigneeName = thread.assignedUserId == null
      ? l10n.inboxAssigneeUnassigned
      : members
                .where((m) => m.userId == thread.assignedUserId)
                .firstOrNull
                ?.displayName ??
            thread.assignedUserId!.substring(0, 8);

  final picked = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              enabled: false,
              leading: const Icon(Icons.person_outline_rounded),
              title: Text(l10n.chatAssign),
              subtitle: Text(assigneeName),
            ),
            const Divider(height: 1),
            if (thread.assignedUserId != myId)
              ListTile(
                leading: const Icon(Icons.person_add_alt_1_rounded),
                title: Text(l10n.inboxAssignToMe),
                onTap: () => Navigator.pop(sheetContext, _kAssignMe),
              ),
            if (isAdmin) ...[
              for (final m in members)
                ListTile(
                  leading: CircleAvatar(
                    child: Text(m.displayName.characters.first.toUpperCase()),
                  ),
                  title: Text(m.displayName),
                  trailing: m.userId == thread.assignedUserId
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () => Navigator.pop(sheetContext, m.userId),
                ),
              if (thread.assignedUserId != null)
                ListTile(
                  leading: const Icon(Icons.person_off_outlined),
                  title: Text(l10n.inboxUnassign),
                  onTap: () => Navigator.pop(sheetContext, _kUnassign),
                ),
            ],
          ],
        ),
      ),
    ),
  );
  if (picked == null || picked == thread.assignedUserId) return;

  try {
    final repo = ref.read(inboxRepoProvider);
    if (picked == _kAssignMe) {
      await repo.assignToMe(thread.id);
    } else {
      await repo.assign(thread.id, picked == _kUnassign ? null : picked);
    }
    ref.invalidate(chatInboxThreadProvider);
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).inboxActionFailed)),
    );
  }
}
