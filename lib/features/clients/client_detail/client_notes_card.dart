import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/inbox_note.dart';
import '../../../data/repos/tenant_repo.dart';
import '../../auth/auth_controller.dart';
import '../../chats/chat_providers.dart';
import '../../chats/widgets/add_note_dialog.dart';
import '../../inbox/inbox_controller.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';

/// Internal notes for the contact — lists the Team Inbox thread's notes with
/// @mention highlighting and an author line, and opens the shared mention
/// composer to add one. Mirrors the portal's `ClientNotesCard`; renders an
/// empty state when the contact has no thread yet.
class ClientNotesCard extends ConsumerWidget {
  const ClientNotesCard({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final threadAsync = ref.watch(
      chatInboxThreadProvider((clientId: clientId, senderId: null)),
    );
    final thread = threadAsync.asData?.value;

    return ClientDetailCard(
      title: l10n.clientDetailNotes,
      icon: Icons.sticky_note_2_outlined,
      trailing: thread == null
          ? null
          : TextButton.icon(
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(l10n.clientDetailAddNote),
              onPressed: () async {
                await showAddNoteDialog(context, ref, thread);
                ref.invalidate(threadNotesProvider(thread.id));
              },
            ),
      child: threadAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(
          onRetry: () => ref.invalidate(
            chatInboxThreadProvider((clientId: clientId, senderId: null)),
          ),
        ),
        data: (t) => t == null
            ? ClientDetailEmpty(l10n.clientDetailNoThread)
            : _NotesList(threadId: t.id),
      ),
    );
  }
}

class _NotesList extends ConsumerWidget {
  const _NotesList({required this.threadId});
  final String threadId;

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    String noteId,
  ) async {
    try {
      await ref.read(inboxRepoProvider).deleteNote(threadId, noteId);
      ref.invalidate(threadNotesProvider(threadId));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).inboxActionFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notesAsync = ref.watch(threadNotesProvider(threadId));
    final members =
        ref.watch(tenantMembersProvider).asData?.value ??
        const <TenantMemberLite>[];
    final myId = ref.watch(authControllerProvider).user?.id;

    return notesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: Insets.sm),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => ClientDetailCardError(
        onRetry: () => ref.invalidate(threadNotesProvider(threadId)),
      ),
      data: (notes) {
        if (notes.isEmpty) return ClientDetailEmpty(l10n.clientDetailNoNotes);
        return Column(
          children: [
            for (final n in notes)
              _NoteTile(
                note: n,
                members: members,
                canDelete: n.authorUserId == myId,
                onDelete: () => _delete(context, ref, n.id),
              ),
          ],
        );
      },
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({
    required this.note,
    required this.members,
    required this.canDelete,
    required this.onDelete,
  });

  final InboxNote note;
  final List<TenantMemberLite> members;
  final bool canDelete;
  final VoidCallback onDelete;

  String _authorName() {
    for (final m in members) {
      if (m.userId == note.authorUserId) return m.displayName;
    }
    return note.authorUserId.length > 8
        ? note.authorUserId.substring(0, 8)
        : note.authorUserId;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final created = note.createdAtDate;
    final meta = created == null
        ? _authorName()
        : '${_authorName()} · ${Fmt.listTimestamp(context, created)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta,
                  style: context.text.labelSmall?.copyWith(
                    color: context.scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    children: _highlightMentions(
                      note.body,
                      members,
                      context.scheme.primary,
                    ),
                  ),
                  textDirection: Fmt.textDirectionFor(note.body),
                  style: context.text.bodyMedium,
                ),
              ],
            ),
          ),
          if (canDelete)
            IconButton(
              tooltip: l10n.clientDetailDeleteNote,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}

/// Highlights every `@MemberName` token in [body] against the current member
/// list (longest names first so "@John Smith" wins over "@John"). Matching the
/// live roster keeps highlights accurate without needing the note's stored
/// mention ids — the same visual result as the portal's `MentionText`.
List<InlineSpan> _highlightMentions(
  String body,
  List<TenantMemberLite> members,
  Color color,
) {
  final names =
      members
          .map((m) => m.displayName)
          .where((n) => n.trim().isNotEmpty)
          .toList()
        ..sort((a, b) => b.length - a.length);
  if (names.isEmpty) return [TextSpan(text: body)];

  String esc(String s) =>
      s.replaceAllMapped(RegExp(r'[.*+?^${}()|[\]\\]'), (m) => '\\${m[0]}');
  final re = RegExp('@(?:${names.map(esc).join('|')})');

  final spans = <InlineSpan>[];
  var last = 0;
  for (final match in re.allMatches(body)) {
    if (match.start > last) {
      spans.add(TextSpan(text: body.substring(last, match.start)));
    }
    spans.add(
      TextSpan(
        text: match[0],
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
    last = match.end;
  }
  if (last < body.length) spans.add(TextSpan(text: body.substring(last)));
  return spans;
}
