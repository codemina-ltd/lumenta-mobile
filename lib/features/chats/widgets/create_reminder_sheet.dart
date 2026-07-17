import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/message.dart';
import '../../../data/repos/tenant_repo.dart';
import '../../auth/auth_controller.dart';
import '../../inbox/inbox_controller.dart';
import '../../reminders/reminders_controller.dart';

/// "Create reminder" from a long-pressed chat bubble — the reminder anchors
/// to the message so its notification can deep-link back to it. Assignment
/// mirrors the API rule: non-admins may only assign to themselves, OWNER/ADMIN
/// can pick any teammate (same gating as [showAssignThreadSheet]).
Future<void> showCreateReminderSheet(
  BuildContext context,
  WidgetRef ref, {
  required Message message,
  required String clientId,
}) async {
  final auth = ref.read(authControllerProvider);
  final role = auth.activeTenant?.role?.toUpperCase();
  final isAdmin = role == 'OWNER' || role == 'ADMIN';
  final myId = auth.user?.id;

  // Admins pick from the member list; a failed fetch degrades to self-assign
  // rather than blocking creation (mirrors the assign sheet's tolerance).
  var members = const <TenantMemberLite>[];
  if (isAdmin) {
    try {
      members = await ref.read(tenantMembersProvider.future);
    } catch (_) {
      ref.invalidate(tenantMembersProvider);
      members = const [];
    }
  }
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  final draft = await showModalBottomSheet<_ReminderDraft>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _CreateReminderSheet(
      initialTitle: _prefillTitle(message),
      members: members,
      myUserId: myId,
      canPickAssignee: isAdmin && members.isNotEmpty,
    ),
  );
  if (draft == null || !context.mounted) return;

  try {
    await ref
        .read(remindersRepoProvider)
        .create(
          title: draft.title,
          dueAtUtc: draft.dueAt,
          clientId: clientId,
          messageId: message.id,
          assignedToUserId: draft.assignedToUserId,
          notes: draft.notes,
        );
    // Keep the Reminders tab (and its badge) in sync when self-assigned.
    unawaited(ref.read(remindersControllerProvider.notifier).refresh());
    messenger.showSnackBar(SnackBar(content: Text(l10n.reminderCreated)));
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.reminderCreateFailed)));
  }
}

/// Title suggestion: the first ~60 characters of the message text (body, or
/// the authored media caption when the body is a placeholder-less blank).
String _prefillTitle(Message message) {
  final text = message.body.trim().isNotEmpty
      ? message.body.trim()
      : (message.mediaCaption?.trim() ?? '');
  if (text.length <= 60) return text;
  return text.substring(0, 60).trimRight();
}

/// What the sheet pops with; the caller performs the API call.
class _ReminderDraft {
  const _ReminderDraft({
    required this.title,
    required this.dueAt,
    this.assignedToUserId,
    this.notes,
  });

  final String title;
  final DateTime dueAt;
  final String? assignedToUserId;
  final String? notes;
}

/// Due-time choice: two presets (computed at submit so they stay in the
/// future) plus a custom date+time.
enum _DuePreset { in2h, tomorrow9, custom }

class _CreateReminderSheet extends StatefulWidget {
  const _CreateReminderSheet({
    required this.initialTitle,
    required this.members,
    required this.myUserId,
    required this.canPickAssignee,
  });

  final String initialTitle;
  final List<TenantMemberLite> members;
  final String? myUserId;
  final bool canPickAssignee;

  @override
  State<_CreateReminderSheet> createState() => _CreateReminderSheetState();
}

class _CreateReminderSheetState extends State<_CreateReminderSheet> {
  late final TextEditingController _title = TextEditingController(
    text: widget.initialTitle,
  );
  final _notes = TextEditingController();

  _DuePreset _preset = _DuePreset.in2h;
  DateTime? _customDue;
  String? _assigneeId;
  String? _titleError;
  String? _dueError;

  @override
  void initState() {
    super.initState();
    // Default assignee: me (when I'm in the pick list, or as the implicit
    // self-assign for non-admins).
    _assigneeId = widget.myUserId;
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  DateTime _tomorrowNine() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1, 9);
  }

  Future<void> _pickCustom() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _customDue ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _customDue ?? now.add(const Duration(hours: 1)),
      ),
    );
    if (time == null || !mounted) return;
    setState(() {
      _customDue = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      _preset = _DuePreset.custom;
      _dueError = null;
    });
  }

  void _submit() {
    final l10n = AppLocalizations.of(context);
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = l10n.reminderTitleRequired);
      return;
    }
    final DateTime due;
    switch (_preset) {
      case _DuePreset.in2h:
        due = DateTime.now().add(const Duration(hours: 2));
      case _DuePreset.tomorrow9:
        due = _tomorrowNine();
      case _DuePreset.custom:
        final custom = _customDue;
        if (custom == null || !custom.isAfter(DateTime.now())) {
          setState(() => _dueError = l10n.reminderDueMustBeFuture);
          return;
        }
        due = custom;
    }
    final notes = _notes.text.trim();
    Navigator.pop(
      context,
      _ReminderDraft(
        title: title,
        dueAt: due,
        assignedToUserId: _assigneeId,
        notes: notes.isEmpty ? null : notes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final customLabel = _customDue == null
        ? l10n.reminderDueCustom
        : DateFormat.MMMd(locale).add_jm().format(_customDue!);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(
            Insets.lg,
            0,
            Insets.lg,
            Insets.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.messageActionCreateReminder,
                style: context.text.titleMedium,
              ),
              const SizedBox(height: Insets.md),
              TextField(
                controller: _title,
                autofocus: widget.initialTitle.isEmpty,
                maxLength: 255,
                decoration: InputDecoration(
                  labelText: l10n.reminderTitleLabel,
                  errorText: _titleError,
                  counterText: '',
                ),
                onChanged: (_) {
                  if (_titleError != null) setState(() => _titleError = null);
                },
              ),
              const SizedBox(height: Insets.md),
              Text(
                l10n.createReminderDueLabel,
                style: context.text.labelLarge?.copyWith(
                  color: context.scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Insets.sm),
              Wrap(
                spacing: Insets.sm,
                children: [
                  ChoiceChip(
                    label: Text(l10n.reminderDueIn2h),
                    selected: _preset == _DuePreset.in2h,
                    onSelected: (_) => setState(() {
                      _preset = _DuePreset.in2h;
                      _dueError = null;
                    }),
                  ),
                  ChoiceChip(
                    label: Text(l10n.reminderDueTomorrow9),
                    selected: _preset == _DuePreset.tomorrow9,
                    onSelected: (_) => setState(() {
                      _preset = _DuePreset.tomorrow9;
                      _dueError = null;
                    }),
                  ),
                  ChoiceChip(
                    label: Text(customLabel),
                    selected: _preset == _DuePreset.custom,
                    onSelected: (_) => _pickCustom(),
                  ),
                ],
              ),
              if (_dueError != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: Insets.xs),
                  child: Text(
                    _dueError!,
                    style: context.text.bodySmall?.copyWith(
                      color: context.scheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: Insets.md),
              if (widget.canPickAssignee)
                DropdownButtonFormField<String>(
                  initialValue:
                      widget.members.any((m) => m.userId == _assigneeId)
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
                )
              else
                // Non-admins may only self-assign (API rule) — show it as a
                // fixed value rather than a one-item picker.
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.reminderAssignToLabel,
                  ),
                  child: Text(l10n.assigneeMe),
                ),
              const SizedBox(height: Insets.md),
              TextField(
                controller: _notes,
                maxLines: 2,
                maxLength: 2000,
                decoration: InputDecoration(
                  labelText: l10n.reminderNotesLabel,
                  counterText: '',
                ),
              ),
              const SizedBox(height: Insets.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: Insets.sm),
                  FilledButton(
                    onPressed: _submit,
                    child: Text(l10n.createAction),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
