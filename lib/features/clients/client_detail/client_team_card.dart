import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repos/tenant_repo.dart';
import '../../chats/chat_providers.dart';
import '../../inbox/inbox_controller.dart';
import '../../shared/widgets.dart';
import 'client_detail_card.dart';
import 'client_detail_status.dart';

/// Ownership of the contact's Team Inbox thread — assignee, status, priority
/// and labels. Read-only on mobile: thread management happens on the web
/// portal. Shows an empty state when the contact has no thread yet.
class ClientTeamCard extends ConsumerWidget {
  const ClientTeamCard({super.key, required this.clientId});
  final String clientId;

  ({String clientId, String? senderId}) get _key =>
      (clientId: clientId, senderId: null);

  String _priorityLabel(AppLocalizations l10n, String p) => switch (p) {
    'low' => l10n.inboxPriorityLow,
    'high' => l10n.inboxPriorityHigh,
    _ => l10n.inboxPriorityNormal,
  };

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
        error: (_, _) => ClientDetailCardError(
          onRetry: () => ref.invalidate(chatInboxThreadProvider(_key)),
        ),
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
              ),
              _Row(
                label: l10n.clientDetailStatus,
                value: StatusPill(
                  label: threadStatusLabel(l10n, thread.status),
                  color: _statusColor(thread.status),
                ),
              ),
              _Row(
                label: l10n.inboxPriority,
                value: StatusPill(
                  label: _priorityLabel(l10n, thread.priority),
                  color: _priorityColor(thread.priority),
                ),
              ),
              const Divider(height: Insets.lg),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.inboxLabels,
                  style: context.text.labelMedium?.copyWith(
                    color: context.scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: Insets.xs),
              if (thread.labels.isEmpty)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ClientDetailEmpty(l10n.inboxNoLabels),
                )
              else
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Wrap(
                    spacing: Insets.sm,
                    runSpacing: Insets.xs,
                    children: [
                      for (final label in thread.labels)
                        Chip(
                          label: Text(label.name),
                          avatar: Icon(
                            Icons.circle,
                            size: 12,
                            color: _hex(label.color),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// A read-only label + value row for assignee/status/priority.
class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
        ],
      ),
    );
  }
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
