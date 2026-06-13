import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/providers.dart';
import '../../data/models/inbox_thread.dart';
import '../commerce/orders_sheet.dart';
import '../contacts/contact_details_sheet.dart';
import '../shared/skeletons.dart';
import '../shared/widgets.dart';
import 'inbox_controller.dart';

/// Operator inbox tab (LUMENTA_GROWTH plan §1.4 / §14): saved-view filters,
/// per-thread assign-to-me / status / internal note. Tapping a thread opens
/// the existing chat detail (threads are keyed by client, decision 14-A).
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
        Expanded(
          child: _body(context, l10n, state, controller),
        ),
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
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.builder(
        controller: _scroll,
        itemCount: state.items.length,
        itemBuilder: (context, i) {
          final t = state.items[i];
          return _ThreadTile(
            thread: t,
            onOpen: () => context.go('/chats/${t.clientId}'),
            onActions: () => _showActions(context, l10n, t),
          );
        },
      ),
    );
  }

  Future<void> _showActions(
    BuildContext context,
    AppLocalizations l10n,
    InboxThread thread,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_add_alt_1_rounded),
              title: Text(l10n.inboxAssignToMe),
              onTap: () {
                Navigator.pop(sheetContext);
                _run(() => ref.read(inboxRepoProvider).assignToMe(thread.id));
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline_rounded),
              title: Text(l10n.inboxStatusResolved),
              onTap: () {
                Navigator.pop(sheetContext);
                _run(() => ref
                    .read(inboxRepoProvider)
                    .changeStatus(thread.id, 'resolved'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule_rounded),
              title: Text(l10n.inboxStatusPending),
              onTap: () {
                Navigator.pop(sheetContext);
                _run(() => ref
                    .read(inboxRepoProvider)
                    .changeStatus(thread.id, 'pending'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.sticky_note_2_outlined),
              title: Text(l10n.inboxAddNote),
              onTap: () {
                Navigator.pop(sheetContext);
                _addNote(context, l10n, thread);
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
    );
  }

  Future<void> _addNote(
    BuildContext context,
    AppLocalizations l10n,
    InboxThread thread,
  ) async {
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
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(l10n.inboxSave),
          ),
        ],
      ),
    );
    if (body == null || body.isEmpty) return;
    await _run(() => ref.read(inboxRepoProvider).addNote(thread.id, body));
  }

  Future<void> _run(Future<void> Function() action) async {
    final l10n = AppLocalizations.of(context);
    try {
      await action();
      ref.read(inboxControllerProvider.notifier).refresh();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.inboxActionFailed)),
        );
      }
    }
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({
    required this.thread,
    required this.onOpen,
    required this.onActions,
  });

  final InboxThread thread;
  final VoidCallback onOpen;
  final VoidCallback onActions;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onOpen,
      leading: CircleAvatar(child: Text(thread.displayName.characters.first)),
      title: Text(thread.displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
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
