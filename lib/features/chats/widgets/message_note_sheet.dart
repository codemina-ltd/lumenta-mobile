import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../data/models/message.dart';
import '../../../data/repos/tenant_repo.dart';
import '../../auth/auth_controller.dart';
import '../../inbox/inbox_controller.dart';

/// "Add internal note" from a long-pressed chat bubble — the note anchors to
/// the message (the server resolves the inbox thread from it) and can be
/// assigned to any teammate; the assignee is notified with a deep link back
/// to the message. Unlike reminders, every member may assign to any member.
Future<void> showMessageNoteSheet(
  BuildContext context,
  WidgetRef ref, {
  required Message message,
}) async {
  final myId = ref.read(authControllerProvider).user?.id;

  // The assignee picker needs the member list; a failed fetch degrades to a
  // self-assigned note rather than blocking (mirrors the add-note dialog).
  List<TenantMemberLite> members;
  try {
    members = await ref.read(tenantMembersProvider.future);
  } catch (_) {
    ref.invalidate(tenantMembersProvider);
    members = const [];
  }
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  final draft = await showDialog<_MessageNoteDraft>(
    context: context,
    builder: (_) => _MessageNoteDialog(members: members, myUserId: myId),
  );
  if (draft == null || !context.mounted) return;

  try {
    await ref
        .read(inboxRepoProvider)
        .addMessageNote(
          message.id,
          draft.body,
          assignedToUserId: draft.assignedToUserId,
        );
    messenger.showSnackBar(SnackBar(content: Text(l10n.chatNoteAdded)));
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.inboxActionFailed)));
  }
}

/// What the dialog pops with; the caller performs the API call.
class _MessageNoteDraft {
  const _MessageNoteDraft(this.body, this.assignedToUserId);
  final String body;
  final String? assignedToUserId;
}

class _MessageNoteDialog extends StatefulWidget {
  const _MessageNoteDialog({required this.members, required this.myUserId});

  final List<TenantMemberLite> members;
  final String? myUserId;

  @override
  State<_MessageNoteDialog> createState() => _MessageNoteDialogState();
}

class _MessageNoteDialogState extends State<_MessageNoteDialog> {
  final _body = TextEditingController();
  String? _assigneeId;

  @override
  void initState() {
    super.initState();
    _assigneeId = widget.myUserId;
  }

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  void _submit() {
    final body = _body.text.trim();
    Navigator.pop(
      context,
      body.isEmpty ? null : _MessageNoteDraft(body, _assigneeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.inboxAddNote),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _body,
              autofocus: true,
              maxLines: 4,
              maxLength: 4000,
              decoration: InputDecoration(
                hintText: l10n.inboxNoteHint,
                counterText: '',
              ),
            ),
            if (widget.members.isNotEmpty) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: widget.members.any((m) => m.userId == _assigneeId)
                    ? _assigneeId
                    : null,
                decoration: InputDecoration(
                  labelText: l10n.reminderAssignToLabel,
                ),
                items: [
                  for (final m in widget.members)
                    DropdownMenuItem(
                      value: m.userId,
                      child: Text(
                        m.userId == widget.myUserId
                            ? l10n.assigneeMe
                            : m.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _assigneeId = v),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.inboxCancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.inboxSave)),
      ],
    );
  }
}
