import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/inbox_thread.dart';
import '../../../data/repos/tenant_repo.dart';
import '../../chats/chat_providers.dart';
import '../../chats/widgets/assign_thread_sheet.dart';
import '../../inbox/inbox_controller.dart';
import '../../shared/widgets.dart';
import 'client_detail_card.dart';
import 'client_detail_status.dart';

const _statuses = ['open', 'pending', 'resolved', 'snoozed'];
const _priorities = ['low', 'normal', 'high'];

/// Ownership of the contact's Team Inbox thread — assignee, status, priority and
/// labels. Mirrors the portal's `TeamCard`; all state lives on the thread, so
/// the card shows an empty state when the contact has no thread yet.
class ClientTeamCard extends ConsumerWidget {
  const ClientTeamCard({super.key, required this.clientId});
  final String clientId;

  ({String clientId, String? senderId}) get _key =>
      (clientId: clientId, senderId: null);

  void _refresh(WidgetRef ref) => ref.invalidate(chatInboxThreadProvider(_key));

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    try {
      await action();
      _refresh(ref);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).inboxActionFailed)),
      );
    }
  }

  String _priorityLabel(AppLocalizations l10n, String p) => switch (p) {
    'low' => l10n.inboxPriorityLow,
    'high' => l10n.inboxPriorityHigh,
    _ => l10n.inboxPriorityNormal,
  };

  Future<void> _editStatus(
    BuildContext context,
    WidgetRef ref,
    InboxThread thread,
  ) async {
    final l10n = AppLocalizations.of(context);
    final picked = await _pickOption(
      context,
      _statuses,
      thread.status,
      (s) => threadStatusLabel(l10n, s),
    );
    if (picked == null || picked == thread.status) return;
    if (!context.mounted) return;
    String? snoozedUntil;
    if (picked == 'snoozed') {
      final until = await _pickSnooze(context);
      if (until == null) return;
      snoozedUntil = until.toUtc().toIso8601String();
    }
    if (!context.mounted) return;
    await _run(
      context,
      ref,
      () => ref
          .read(inboxRepoProvider)
          .changeStatus(thread.id, picked, snoozedUntil: snoozedUntil),
    );
  }

  Future<void> _editPriority(
    BuildContext context,
    WidgetRef ref,
    InboxThread thread,
  ) async {
    final l10n = AppLocalizations.of(context);
    final picked = await _pickOption(
      context,
      _priorities,
      thread.priority,
      (p) => _priorityLabel(l10n, p),
    );
    if (picked == null || picked == thread.priority) return;
    if (!context.mounted) return;
    await _run(
      context,
      ref,
      () => ref.read(inboxRepoProvider).changePriority(thread.id, picked),
    );
  }

  Future<void> _addLabel(
    BuildContext context,
    WidgetRef ref,
    InboxThread thread,
  ) async {
    final l10n = AppLocalizations.of(context);
    final all = await ref.read(inboxRepoProvider).labels();
    final applied = thread.labels.map((l) => l.id).toSet();
    final available = all.where((l) => !applied.contains(l.id)).toList();
    if (!context.mounted) return;
    if (available.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.inboxNoLabels)));
      return;
    }
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final label in available)
              ListTile(
                leading: Icon(Icons.circle, size: 14, color: _hex(label.color)),
                title: Text(label.name),
                onTap: () => Navigator.pop(sheetContext, label.id),
              ),
          ],
        ),
      ),
    );
    if (picked == null || !context.mounted) return;
    await _run(
      context,
      ref,
      () => ref.read(inboxRepoProvider).applyLabel(thread.id, picked),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final threadAsync = ref.watch(chatInboxThreadProvider(_key));

    return ClientDetailCard(
      title: l10n.clientDetailTeam,
      icon: Icons.groups_2_outlined,
      child: threadAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(onRetry: () => _refresh(ref)),
        data: (thread) {
          if (thread == null) {
            return ClientDetailEmpty(l10n.clientDetailNoThread);
          }
          final members =
              ref.watch(tenantMembersProvider).asData?.value ??
              const <TenantMemberLite>[];
          final assigneeName = thread.assignedUserId == null
              ? l10n.inboxAssigneeUnassigned
              : members
                        .where((m) => m.userId == thread.assignedUserId)
                        .firstOrNull
                        ?.displayName ??
                    thread.assignedUserId!.substring(0, 8);

          return Column(
            children: [
              _Row(
                label: l10n.clientDetailAssignee,
                value: Text(assigneeName, style: context.text.bodyMedium),
                onEdit: () => showAssignThreadSheet(context, ref, thread),
              ),
              _Row(
                label: l10n.clientDetailStatus,
                value: StatusPill(
                  label: threadStatusLabel(l10n, thread.status),
                  color: _statusColor(thread.status),
                ),
                onEdit: () => _editStatus(context, ref, thread),
              ),
              _Row(
                label: l10n.inboxPriority,
                value: StatusPill(
                  label: _priorityLabel(l10n, thread.priority),
                  color: _priorityColor(thread.priority),
                ),
                onEdit: () => _editPriority(context, ref, thread),
              ),
              const Divider(height: Insets.lg),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.inboxLabels,
                      style: context.text.labelMedium?.copyWith(
                        color: context.scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(l10n.inboxLabels),
                    onPressed: () => _addLabel(context, ref, thread),
                  ),
                ],
              ),
              const SizedBox(height: Insets.xs),
              if (thread.labels.isEmpty)
                ClientDetailEmpty(l10n.inboxNoLabels)
              else
                Wrap(
                  spacing: Insets.sm,
                  runSpacing: Insets.xs,
                  children: [
                    for (final label in thread.labels)
                      InputChip(
                        label: Text(label.name),
                        avatar: Icon(
                          Icons.circle,
                          size: 12,
                          color: _hex(label.color),
                        ),
                        onDeleted: () => _run(
                          context,
                          ref,
                          () => ref
                              .read(inboxRepoProvider)
                              .removeLabel(thread.id, label.id),
                        ),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

/// A label + value row with an "edit" pencil, used for assignee/status/priority.
class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, required this.onEdit});
  final String label;
  final Widget value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: context.text.labelMedium?.copyWith(
                color: context.scheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: value,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

Future<String?> _pickOption(
  BuildContext context,
  List<String> options,
  String current,
  String Function(String) label,
) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final o in options)
            ListTile(
              title: Text(label(o)),
              trailing: o == current ? const Icon(Icons.check_rounded) : null,
              onTap: () => Navigator.pop(sheetContext, o),
            ),
        ],
      ),
    ),
  );
}

Future<DateTime?> _pickSnooze(BuildContext context) async {
  final now = DateTime.now();
  final date = await showDatePicker(
    context: context,
    initialDate: now.add(const Duration(days: 1)),
    firstDate: now,
    lastDate: now.add(const Duration(days: 365)),
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: const TimeOfDay(hour: 9, minute: 0),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

Color _statusColor(String status) => switch (status) {
  'open' => AppColors.signal,
  'pending' => AppColors.amber,
  'resolved' => AppColors.slate,
  'snoozed' => AppColors.lilac,
  _ => AppColors.slate,
};

Color _priorityColor(String priority) => switch (priority) {
  'high' => AppColors.ember,
  'low' => AppColors.slate,
  _ => AppColors.signalDeep,
};

Color _hex(String value) {
  var h = value.replaceAll('#', '').trim();
  if (h.length == 6) h = 'FF$h';
  return Color(int.tryParse(h, radix: 16) ?? 0xFF00C896);
}
