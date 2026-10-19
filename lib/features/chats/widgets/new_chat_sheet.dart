import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/skeletons.dart';
import '../../shared/widgets.dart';
import '../chats_controller.dart';
import '../new_chat_controller.dart';

/// Opens the WhatsApp-style "New chat" sheet from the chats "+" button: a
/// search box, the most recent chats, then every client (server search +
/// pagination). Picking a client closes the sheet and opens the thread.
Future<void> showNewChatSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: context.scheme.surface,
    builder: (_) => const _NewChatSheet(),
  );
}

class _NewChatSheet extends ConsumerStatefulWidget {
  const _NewChatSheet();

  @override
  ConsumerState<_NewChatSheet> createState() => _NewChatSheetState();
}

class _NewChatSheetState extends ConsumerState<_NewChatSheet> {
  final _searchCtrl = TextEditingController();
  final _scroll = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 320) {
        ref.read(newChatClientsProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {}); // keep the clear button + section layout in sync
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(newChatClientsProvider.notifier).setSearch(value.trim());
    });
  }

  void _open(String clientId) {
    Navigator.of(context).pop();
    context.push('/chats/$clientId');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final clients = ref.watch(newChatClientsProvider);
    final controller = ref.read(newChatClientsProvider.notifier);
    final searching = _searchCtrl.text.trim().isNotEmpty;
    // Recent chats come straight from the chats tab's loaded list.
    final recent = searching
        ? const <_Entry>[]
        : [
            for (final c in ref.watch(chatsControllerProvider).items.take(5))
              _Entry(
                id: c.clientId,
                name: c.displayName,
                initials: c.initials,
                phone: c.phoneNumber,
              ),
          ];
    final all = [
      for (final c in clients.items)
        _Entry(
          id: c.id,
          name: c.displayName,
          initials: c.initials,
          phone: c.phoneNumber,
        ),
    ];

    final height = MediaQuery.sizeOf(context).height * 0.92;
    return SizedBox(
      height: height,
      child: Column(
        children: [
          _SheetHeader(title: l10n.chatsNewChat),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.lg,
              Insets.xs,
              Insets.lg,
              Insets.md,
            ),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              onChanged: _onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.newChatSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                isDense: true,
                fillColor: context.scheme.surfaceContainerHigh,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(Radii.pill)),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(Radii.pill)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(Radii.pill)),
                  borderSide: BorderSide(color: AppColors.signal, width: 1.6),
                ),
                suffixIcon: _searchCtrl.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () {
                          _searchCtrl.clear();
                          _onChanged('');
                        },
                      ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scroll,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(
                Insets.lg,
                0,
                Insets.lg,
                Insets.xxl,
              ),
              children: [
                if (!searching) ...[
                  _GroupCard(
                    children: [
                      _ActionTile(
                        icon: Icons.manage_search_rounded,
                        label: l10n.newChatSearchEverything,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.push('/search');
                        },
                      ),
                    ],
                  ),
                  if (recent.isNotEmpty) ...[
                    _SectionLabel(l10n.newChatRecent),
                    _GroupCard(
                      children: [
                        for (final e in recent)
                          _ClientTile(entry: e, onTap: () => _open(e.id)),
                      ],
                    ),
                  ],
                  _SectionLabel(l10n.newChatAllClients),
                ],
                if (clients.loading)
                  const _GroupCard(children: [SkeletonList(count: 6, lines: 1)])
                else if (clients.error != null && clients.items.isEmpty)
                  ErrorRetry(onRetry: controller.refresh)
                else if (all.isEmpty)
                  EmptyState(
                    message: searching
                        ? l10n.newChatNoResults
                        : l10n.clientsEmpty,
                    icon: Icons.person_search_rounded,
                  )
                else
                  _GroupCard(
                    children: [
                      for (final e in all)
                        _ClientTile(entry: e, onTap: () => _open(e.id)),
                      if (clients.hasMore)
                        const Padding(
                          padding: EdgeInsets.all(Insets.lg),
                          child: Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Entry {
  const _Entry({
    required this.id,
    required this.name,
    required this.initials,
    this.phone,
  });

  final String id;
  final String name;
  final String initials;
  final String? phone;
}

/// Centered title with a round close button on the end side.
class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Insets.lg,
        Insets.md,
        Insets.lg,
        Insets.sm,
      ),
      // Full width: a loose Stack would shrink to the title and park the
      // close button on the title's edge.
      child: SizedBox(
        width: double.infinity,
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(title, style: context.text.titleLarge?.copyWith(fontSize: 20)),
            PositionedDirectional(
              end: 0,
              child: Material(
                color: context.scheme.surfaceContainerHigh,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: context.scheme.onSurface,
                      semanticLabel: l10n.close,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Insets.xs,
        Insets.xl,
        Insets.xs,
        Insets.sm,
      ),
      child: Text(
        text,
        style: context.text.titleMedium?.copyWith(
          color: context.scheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// iOS-style grouped list card.
class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.scheme.surfaceContainerLow,
      borderRadius: Radii.card,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: Insets.lg + 40 + Insets.md,
                color: context.scheme.outlineVariant,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.md,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Icon(icon, color: AppColors.signalDeep, size: 24),
            ),
            const SizedBox(width: Insets.md),
            Expanded(child: Text(label, style: context.text.titleMedium)),
          ],
        ),
      ),
    );
  }
}

class _ClientTile extends StatelessWidget {
  const _ClientTile({required this.entry, required this.onTap});

  final _Entry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final phone = entry.phone;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.sm + 2,
        ),
        child: Row(
          children: [
            InitialsAvatar(initials: entry.initials, radius: 20),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: Fmt.textDirectionFor(entry.name),
                    textAlign: Directionality.of(context) == TextDirection.rtl
                        ? TextAlign.right
                        : TextAlign.left,
                    style: context.text.titleMedium,
                  ),
                  if (phone != null && phone.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      '+$phone',
                      style: context.text.bodySmall?.copyWith(
                        color: context.scheme.onSurfaceVariant,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
