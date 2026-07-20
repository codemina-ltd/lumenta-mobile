import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
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
  const ClientNotesCard({
    super.key,
    required this.clientId,
    this.highlightNoteId,
  });
  final String clientId;

  /// Deep-link target from a mention/assignment notification — scrolled to
  /// and briefly highlighted once the notes list loads.
  final String? highlightNoteId;

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
            : _NotesList(threadId: t.id, highlightNoteId: highlightNoteId),
      ),
    );
  }
}

class _NotesList extends ConsumerStatefulWidget {
  const _NotesList({required this.threadId, this.highlightNoteId});
  final String threadId;
  final String? highlightNoteId;

  @override
  ConsumerState<_NotesList> createState() => _NotesListState();
}

class _NotesListState extends ConsumerState<_NotesList> {
  /// Keys the deep-linked note's row while set so [Scrollable.ensureVisible]
  /// can find it. Mirrors the chat screen's `?messageId=` highlight flow.
  final GlobalKey _highlightKey = GlobalKey();
  String? _highlightId;
  bool _highlightOn = false;
  bool _handled = false;
  Timer? _fadeTimer;
  Timer? _clearTimer;

  @override
  void initState() {
    super.initState();
    _highlightId = widget.highlightNoteId;
  }

  @override
  void dispose() {
    _fadeTimer?.cancel();
    _clearTimer?.cancel();
    super.dispose();
  }

  void _maybeStartHighlight(List<InboxNote> notes) {
    final id = _highlightId;
    if (id == null || _handled || !notes.any((n) => n.id == id)) return;
    _handled = true;
    setState(() => _highlightOn = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNote());
    _fadeTimer = Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      setState(() => _highlightOn = false);
      _clearTimer = Timer(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _highlightId = null);
      });
    });
  }

  /// The card is force-built via `ClientDetailScreen`'s large cacheExtent
  /// when a highlight target is present, so a couple of retries are enough
  /// to cover the first-frame layout race.
  void _scrollToNote([int attempt = 0]) {
    if (!mounted) return;
    final ctx = _highlightKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.3,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
      return;
    }
    if (attempt >= 10) return;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToNote(attempt + 1),
    );
  }

  Future<void> _delete(String noteId) async {
    try {
      await ref.read(inboxRepoProvider).deleteNote(widget.threadId, noteId);
      ref.invalidate(threadNotesProvider(widget.threadId));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).inboxActionFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notesAsync = ref.watch(threadNotesProvider(widget.threadId));
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
        onRetry: () => ref.invalidate(threadNotesProvider(widget.threadId)),
      ),
      data: (notes) {
        if (notes.isEmpty) return ClientDetailEmpty(l10n.clientDetailNoNotes);
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _maybeStartHighlight(notes),
        );
        return Column(
          children: [
            for (final n in notes)
              _NoteTile(
                key: n.id == _highlightId ? _highlightKey : null,
                note: n,
                members: members,
                canDelete: n.authorUserId == myId,
                onDelete: () => _delete(n.id),
                highlighted: _highlightOn && n.id == _highlightId,
              ),
          ],
        );
      },
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({
    super.key,
    required this.note,
    required this.members,
    required this.canDelete,
    required this.onDelete,
    this.highlighted = false,
  });

  final InboxNote note;
  final List<TenantMemberLite> members;
  final bool canDelete;
  final VoidCallback onDelete;

  /// Briefly tinted amber when this is the note a mention/assignment
  /// notification deep-linked to.
  final bool highlighted;

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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: -6),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.amber.withValues(alpha: 0.28)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
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
