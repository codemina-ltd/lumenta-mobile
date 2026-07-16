import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/inbox_thread.dart';
import '../../../data/repos/tenant_repo.dart';
import '../../inbox/inbox_controller.dart';

/// Internal-note dialog for the chat + inbox screens — same semantics as the
/// portal's client-detail notes card: the note attaches to the Team Inbox
/// thread behind this chat and the customer never sees it. Typing `@` opens a
/// teammate picker; picked members ride along as `mentions` so the server can
/// notify them. Notes don't render in the chat timeline, so success is
/// confirmed with a snackbar.
Future<void> showAddNoteDialog(
  BuildContext context,
  WidgetRef ref,
  InboxThread thread,
) async {
  // Team members drive the @mention picker. A failed fetch degrades to a
  // plain note (no suggestions) rather than blocking note-taking — mirrors
  // how the assign sheet tolerates a members outage.
  List<TenantMemberLite> members;
  try {
    members = await ref.read(tenantMembersProvider.future);
  } catch (_) {
    ref.invalidate(tenantMembersProvider);
    members = const [];
  }
  if (!context.mounted) return;

  final draft = await showDialog<_NoteDraft>(
    context: context,
    builder: (dialogContext) => _AddNoteDialog(members: members),
  );
  if (draft == null || draft.body.isEmpty || !context.mounted) return;

  try {
    await ref
        .read(inboxRepoProvider)
        .addNote(thread.id, draft.body, mentions: draft.mentions);
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

/// The composed note plus the teammates tagged in it (`[{ user_id }]`).
class _NoteDraft {
  const _NoteDraft(this.body, this.mentions);
  final String body;
  final List<Map<String, dynamic>> mentions;
}

class _AddNoteDialog extends StatefulWidget {
  const _AddNoteDialog({required this.members});
  final List<TenantMemberLite> members;

  @override
  State<_AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<_AddNoteDialog> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  /// Teammates the author picked from the dropdown. Kept separate from the raw
  /// text so a shorter name ("@John") can't be flagged as a substring of a
  /// longer one the author actually chose ("@John Smith") — see
  /// [_resolveMentions]. Mirrors the portal composer's `mentionIds` set.
  final Set<String> _mentioned = <String>{};

  List<TenantMemberLite> _suggestions = const [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_syncSuggestions);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// The `@token` currently under the caret, or null when the caret isn't in a
  /// mention. A token runs from an `@` at a word boundary up to the caret and
  /// may not contain whitespace — mirrors the portal composer's trigger.
  String? _activeQuery() {
    final sel = _controller.selection;
    if (!sel.isValid || !sel.isCollapsed) return null;
    final caret = sel.baseOffset;
    final text = _controller.text;
    if (caret < 0 || caret > text.length) return null;
    final upToCaret = text.substring(0, caret);
    final at = upToCaret.lastIndexOf('@');
    if (at < 0) return null;
    // The `@` must start the note or follow whitespace, so an email address
    // ("a@b") never opens the picker.
    if (at > 0 && upToCaret[at - 1].trim().isNotEmpty) return null;
    final query = upToCaret.substring(at + 1);
    if (query.contains(RegExp(r'\s'))) return null;
    return query;
  }

  void _syncSuggestions() {
    if (widget.members.isEmpty) return;
    final query = _activeQuery();
    if (query == null) {
      if (_suggestions.isNotEmpty) setState(() => _suggestions = const []);
      return;
    }
    final needle = query.toLowerCase();
    final matches = widget.members
        .where((m) => m.displayName.toLowerCase().contains(needle))
        .take(6)
        .toList();
    setState(() => _suggestions = matches);
  }

  /// Replaces the active `@token` with `@DisplayName ` and records the pick.
  void _pick(TenantMemberLite member) {
    final caret = _controller.selection.baseOffset;
    final text = _controller.text;
    final at = text.substring(0, caret).lastIndexOf('@');
    if (at < 0) return;
    final token = '@${member.displayName} ';
    final next = text.replaceRange(at, caret, token);
    _mentioned.add(member.userId);
    _controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: at + token.length),
    );
    setState(() => _suggestions = const []);
    _focus.requestFocus();
  }

  /// Builds the `mentions` payload: a picked teammate only counts while their
  /// `@name` token is still present in the body, so erasing the token drops the
  /// mention (mirrors the portal's `resolveMentions`). The API re-validates
  /// every id, so a stray one is harmless.
  List<Map<String, dynamic>> _resolveMentions(String body) {
    final out = <Map<String, dynamic>>[];
    final seen = <String>{};
    for (final m in widget.members) {
      if (_mentioned.contains(m.userId) &&
          !seen.contains(m.userId) &&
          body.contains('@${m.displayName}')) {
        seen.add(m.userId);
        out.add({'user_id': m.userId});
      }
    }
    return out;
  }

  void _submit() {
    final body = _controller.text.trim();
    Navigator.pop(
      context,
      body.isEmpty ? null : _NoteDraft(body, _resolveMentions(body)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasMembers = widget.members.isNotEmpty;
    return AlertDialog(
      title: Text(l10n.inboxAddNote),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              focusNode: _focus,
              autofocus: true,
              maxLines: 4,
              maxLength: 4000,
              decoration: InputDecoration(
                hintText: l10n.inboxNoteHint,
                helperText: hasMembers ? l10n.inboxMentionHint : null,
                counterText: '',
              ),
            ),
            if (_suggestions.isNotEmpty)
              _MentionSuggestions(members: _suggestions, onPick: _pick),
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

/// The dropdown of teammates matching the active `@token`.
class _MentionSuggestions extends StatelessWidget {
  const _MentionSuggestions({required this.members, required this.onPick});

  final List<TenantMemberLite> members;
  final ValueChanged<TenantMemberLite> onPick;

  @override
  Widget build(BuildContext context) {
    // A Material (not a decorated Container) so the tiles' ink/splash render —
    // a background-coloured Container would hide them.
    return Padding(
      padding: const EdgeInsets.only(top: Insets.sm),
      child: Material(
        color: context.scheme.surfaceContainerHigh,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          side: BorderSide(color: context.scheme.outlineVariant),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 180),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: members.length,
            itemBuilder: (context, i) {
              final m = members[i];
              return ListTile(
                dense: true,
                leading: CircleAvatar(
                  radius: 14,
                  child: Text(m.displayName.characters.first.toUpperCase()),
                ),
                title: Text(
                  m.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => onPick(m),
              );
            },
          ),
        ),
      ),
    );
  }
}
