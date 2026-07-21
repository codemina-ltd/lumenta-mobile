import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../shared/live_call_badge.dart';
import '../shared/skeletons.dart';
import '../shared/widgets.dart';
import 'clients_controller.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  final _scroll = ScrollController();
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >=
        _scroll.position.maxScrollExtent - 320) {
      ref.read(clientsControllerProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(clientsControllerProvider.notifier).setSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(clientsControllerProvider);
    final controller = ref.read(clientsControllerProvider.notifier);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Insets.lg,
            Insets.sm,
            Insets.lg,
            Insets.md,
          ),
          child: TextField(
            controller: _searchCtrl,
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.searchClients,
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
              suffixIcon: _searchCtrl.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () {
                        _searchCtrl.clear();
                        _onSearchChanged('');
                        setState(() {});
                      },
                    ),
              border: const OutlineInputBorder(borderRadius: Radii.field),
            ),
          ),
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              if (state.loading) {
                return const SkeletonList(count: 9, lines: 1);
              }
              if (state.error != null && state.items.isEmpty) {
                return ErrorRetry(onRetry: controller.refresh);
              }
              if (state.items.isEmpty) {
                return EmptyState(
                  title: l10n.clientsEmpty,
                  message: l10n.searchClients,
                  icon: Icons.people_alt_outlined,
                );
              }
              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView.separated(
                  controller: _scroll,
                  padding: const EdgeInsets.only(bottom: Insets.lg),
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    indent: 76,
                    endIndent: Insets.lg,
                    color: context.scheme.outlineVariant,
                  ),
                  itemBuilder: (context, i) {
                    if (i >= state.items.length) {
                      return const _LoadingMore();
                    }
                    final c = state.items[i];
                    return _ClientRow(
                      clientId: c.id,
                      initials: c.initials,
                      name: c.displayName,
                      phone: '+${c.phoneNumber}',
                      onTap: () => context.push('/chats/${c.id}'),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ClientRow extends StatelessWidget {
  const _ClientRow({
    required this.clientId,
    required this.initials,
    required this.name,
    required this.phone,
    required this.onTap,
  });

  final String clientId;
  final String initials;
  final String name;
  final String phone;
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
            InitialsAvatar(initials: initials),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    phone,
                    style: context.text.bodySmall?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                      fontFeatures: const [],
                      letterSpacing: 0.2,
                    ),
                  ),
                  LiveCallBadge(clientId: clientId),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 20,
              color: context.scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingMore extends StatelessWidget {
  const _LoadingMore();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(Insets.lg),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.4),
        ),
      ),
    );
  }
}
