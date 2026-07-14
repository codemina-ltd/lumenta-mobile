import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../data/models/inbox_thread.dart';

/// Internal-note dialog for the chat screen — same semantics as the inbox
/// tab's "Add internal note": the note attaches to the Team Inbox thread
/// behind this chat and the customer never sees it. Notes don't render in
/// the chat timeline, so success is confirmed with a snackbar.
Future<void> showAddNoteDialog(
  BuildContext context,
  WidgetRef ref,
  InboxThread thread,
) async {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController();
  final body = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.inboxAddNote),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLines: 4,
        decoration: InputDecoration(hintText: l10n.inboxNoteHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.inboxCancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(dialogContext, controller.text.trim()),
          child: Text(l10n.inboxSave),
        ),
      ],
    ),
  );
  if (body == null || body.isEmpty || !context.mounted) return;

  try {
    await ref.read(inboxRepoProvider).addNote(thread.id, body);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).chatNoteAdded)),
    );
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).inboxActionFailed)),
    );
  }
}
