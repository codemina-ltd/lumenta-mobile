import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/providers.dart';
import '../../data/models/inbox_thread.dart';
import '../../data/repos/inbox_repo.dart';
import '../../data/repos/tenant_repo.dart';
import '../auth/auth_controller.dart';
import '../chats/widgets/add_note_dialog.dart';
import '../commerce/orders_sheet.dart';
import '../contacts/contact_details_sheet.dart';
import '../shared/skeletons.dart';
import '../shared/widgets.dart';
import 'inbox_controller.dart';

/// Sentinel for the assignee picker: distinguishes "Unassign" from a
/// dismissed sheet (both would otherwise be `null`).
const _kUnassign = '__unassign__';

/// Operator inbox tab (LUMENTA_GROWTH plan §1.4 / §14): saved-view filters,
/// per-thread assign-to-me / status / internal note. Tapping a thread opens
/// the existing chat detail (threads are keyed by client, decision 14-A).
///
/// OWNER/ADMIN additionally get the portal's supervise actions: assign to
/// any member, snooze, priority, and labels.
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 320) {
        ref.read(inboxControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  String _viewLabel(AppLocalizations l10n, InboxView v) => switch (v) {
    InboxView.mine => l10n.inboxViewMine,
    InboxView.unassigned => l10n.inboxViewUnassigned,
    InboxView.open => l10n.inboxViewOpen,
    InboxView.snoozed => l10n.inboxViewSnoozed,
    InboxView.all => l10n.inboxViewAll,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(inboxControllerProvider);
    final controller = ref.read(inboxControllerProvider.notifier);

    return Column(
      children: [
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              for (final v in InboxView.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_viewLabel(l10n, v)),
                    selected: state.view == v,
                    onSelected: (_) => controller.setView(v),
                  ),
                ),
            ],
          ),
        ),
        Expanded(child: _body(context, l10n, state, controller)),
      ],
    );
  }

  Widget _body(
    BuildContext context,
    AppLocalizations l10n,
    InboxState state,
    InboxController controller,
  ) {
    if (state.loading) return const SkeletonList(count: 8);
    if (state.error != null) {
      return ErrorRetry(onRetry: controller.refresh);
    }
    if (state.items.isEmpty) {
      return Center(child: Text(l10n.inboxEmpty));
    }
    final memberNames = {
      for (final m
          in ref.watch(tenantMembersProvider).asData?.value ??
              const <TenantMemberLite>[])
        m.userId: m.displayName,
    };
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.builder(
        controller: _scroll,
        itemCount: state.items.length,
        itemBuilder: (context, i) {
          final t = state.items[i];
          return _ThreadTile(
            thread: t,
            assigneeName: _assigneeName(l10n, memberNames, t.assignedUserId),
            onOpen: () {
              controller.markReadOnOpen(t);
              context.push('/chats/${t.clientId}');
            },
            onActions: () => _showActions(context, l10n, t),
          );
        },
      ),
    );
  }

  /// Assignee display name for a tile: member name, a short id while the
  /// members list is still loading (or for a since-removed member), or the
  /// localized "Unassigned".
  String _assigneeName(
    AppLocalizations l10n,
    Map<String, String> memberNames,
    String? userId,
  ) {
    if (userId == null) return l10n.inboxAssigneeUnassigned;
    return memberNames[userId] ?? userId.substring(0, 8);
  }

  bool get _isAdmin {
    final role = ref
        .read(authControllerProvider)
        .activeTenant
        ?.role
        ?.toUpperCase();
    return role == 'OWNER' || role == 'ADMIN';
  }

  Future<void> _showActions(
    BuildContext context,
    AppLocalizations l10n,
    InboxThread thread,
  ) async {
    final controller = ref.read(inboxControllerProvider.notifier);
    final isAdmin = _isAdmin;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add_alt_1_rounded),
                title: Text(l10n.inboxAssignToMe),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _run(() => controller.assignToMe(thread.id));
                },
              ),
              if (isAdmin)
                ListTile(
                  leading: const Icon(Icons.group_outlined),
                  title: Text(l10n.inboxAssignToMember),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickAssignee(l10n, thread);
                  },
                ),
              if (thread.status != 'open')
                ListTile(
                  leading: const Icon(Icons.mark_email_unread_outlined),
                  title: Text(l10n.inboxReopen),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _run(() => controller.setStatus(thread.id, 'open'));
                  },
                ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline_rounded),
                title: Text(l10n.inboxStatusResolved),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _run(() => controller.setStatus(thread.id, 'resolved'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule_rounded),
                title: Text(l10n.inboxStatusPending),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _run(() => controller.setStatus(thread.id, 'pending'));
                },
              ),
              if (isAdmin) ...[
                ListTile(
                  leading: const Icon(Icons.snooze_rounded),
                  title: Text(l10n.inboxSnoozeUntil),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickSnooze(thread);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: Text(l10n.inboxPriority),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickPriority(l10n, thread);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.label_outline_rounded),
                  title: Text(l10n.inboxLabels),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _editLabels(l10n, thread);
                  },
                ),
              ],
              ListTile(
                leading: const Icon(Icons.sticky_note_2_outlined),
                title: Text(l10n.inboxAddNote),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showAddNoteDialog(context, ref, thread);
                },
              ),
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: Text(l10n.contactDetails),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showContactDetailsSheet(context, thread.clientId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: Text(l10n.ordersTitle),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showOrdersSheet(context, thread.clientId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Admin pickers ─────────────────────────────────────────────────────────

  Future<void> _pickAssignee(AppLocalizations l10n, InboxThread thread) async {
    final List<TenantMemberLite> members;
    try {
      members = await ref.read(tenantMembersProvider.future);
    } catch (_) {
      // Drop the cached failure so the next attempt (and the tile names)
      // can retry the fetch.
      ref.invalidate(tenantMembersProvider);
      _showError();
      return;
    }
    if (!mounted) return;

    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            if (thread.assignedUserId != null)
              ListTile(
                leading: const Icon(Icons.person_off_outlined),
                title: Text(l10n.inboxUnassign),
                onTap: () => Navigator.pop(sheetContext, _kUnassign),
              ),
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
          ],
        ),
      ),
    );
    if (picked == null || picked == thread.assignedUserId) return;
    await _run(
      () => ref
          .read(inboxControllerProvider.notifier)
          .assignTo(thread.id, picked == _kUnassign ? null : picked),
    );
  }

  Future<void> _pickSnooze(InboxThread thread) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null) return;
    final until = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    await _run(
      () => ref
          .read(inboxControllerProvider.notifier)
          .setStatus(
            thread.id,
            'snoozed',
            snoozedUntil: until.toUtc().toIso8601String(),
          ),
    );
  }

  Future<void> _pickPriority(AppLocalizations l10n, InboxThread thread) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (value, label) in [
              ('low', l10n.inboxPriorityLow),
              ('normal', l10n.inboxPriorityNormal),
              ('high', l10n.inboxPriorityHigh),
            ])
              ListTile(
                leading: Icon(
                  Icons.flag_rounded,
                  color: switch (value) {
                    'high' => Theme.of(sheetContext).colorScheme.error,
                    'low' => Theme.of(sheetContext).disabledColor,
                    _ => null,
                  },
                ),
                title: Text(label),
                trailing: value == thread.priority
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.pop(sheetContext, value),
              ),
          ],
        ),
      ),
    );
    if (picked == null || picked == thread.priority) return;
    await _run(
      () => ref
          .read(inboxControllerProvider.notifier)
          .setPriority(thread.id, picked),
    );
  }

  Future<void> _editLabels(AppLocalizations l10n, InboxThread thread) async {
    final List<InboxLabelLite> all;
    try {
      all = await ref.read(inboxRepoProvider).labels();
    } catch (_) {
      _showError();
      return;
    }
    if (!mounted) return;

    // Local mirror of the applied set so the sheet updates instantly while
    // each toggle round-trips (the controller folds the server result into
    // the list behind the sheet).
    final applied = thread.labels.map((l) => l.id).toSet();
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: all.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.inboxNoLabels),
              )
            : StatefulBuilder(
                builder: (_, setSheetState) => ListView(
                  shrinkWrap: true,
                  children: [
                    for (final label in all)
                      CheckboxListTile(
                        value: applied.contains(label.id),
                        title: Text(label.name),
                        secondary: Icon(
                          Icons.label_rounded,
                          color: _parseHex(label.color),
                        ),
                        onChanged: (checked) {
                          setSheetState(() {
                            if (checked == true) {
                              applied.add(label.id);
                            } else {
                              applied.remove(label.id);
                            }
                          });
                          final controller = ref.read(
                            inboxControllerProvider.notifier,
                          );
                          _run(
                            () => checked == true
                                ? controller.applyLabel(thread.id, label.id)
                                : controller.removeLabel(thread.id, label.id),
                          );
                        },
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  static Color? _parseHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    if (cleaned.length != 6) return null;
    final value = int.tryParse(cleaned, radix: 16);
    return value == null ? null : Color(0xFF000000 | value);
  }

  // ── Shared plumbing ───────────────────────────────────────────────────────

  /// Runs a mutation; the controller folds the server response into the
  /// list state, so no list refetch happens here (see InboxController).
  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      _showError();
    }
  }

  void _showError() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.inboxActionFailed)));
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({
    required this.thread,
    required this.assigneeName,
    required this.onOpen,
    required this.onActions,
  });

  final InboxThread thread;
  final String assigneeName;
  final VoidCallback onOpen;
  final VoidCallback onActions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onOpen,
      leading: CircleAvatar(child: Text(thread.displayName.characters.first)),
      title: Text(
        thread.displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Wrap(
        spacing: 6,
        runSpacing: 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Chip(
            label: Text(thread.status),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 14,
                color: theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 2),
              Text(assigneeName, style: theme.textTheme.bodySmall),
            ],
          ),
          for (final l in thread.labels)
            Chip(
              label: Text(l.name),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (thread.unreadCount > 0)
            Badge(label: Text('${thread.unreadCount}')),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: onActions,
          ),
        ],
      ),
    );
  }
}
