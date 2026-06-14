import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/providers.dart';
import '../../data/repos/commerce_repo.dart';

const _statuses = [
  'pending',
  'confirmed',
  'paid',
  'shipped',
  'completed',
  'cancelled',
];

/// Opens a contact's WhatsApp orders with inline status update
/// (LUMENTA_GROWTH plan §14).
Future<void> showOrdersSheet(BuildContext context, String clientId) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _OrdersSheet(clientId: clientId),
  );
}

class _OrdersSheet extends ConsumerStatefulWidget {
  const _OrdersSheet({required this.clientId});
  final String clientId;

  @override
  ConsumerState<_OrdersSheet> createState() => _OrdersSheetState();
}

class _OrdersSheetState extends ConsumerState<_OrdersSheet> {
  List<CommerceOrder> _orders = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final orders =
          await ref.read(commerceRepoProvider).ordersForClient(widget.clientId);
      if (mounted) {
        setState(() {
          _orders = orders;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _setStatus(CommerceOrder order, String status) async {
    try {
      await ref.read(commerceRepoProvider).updateStatus(order.id, status);
      await _load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).ordersActionFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.ordersTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_orders.isEmpty)
            Text(l10n.ordersEmpty)
          else
            ..._orders.map(
              (o) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(o.subtotalDisplay),
                subtitle: Text(o.placedAt ?? ''),
                trailing: DropdownButton<String>(
                  value: o.status,
                  underline: const SizedBox.shrink(),
                  items: [
                    for (final s in _statuses)
                      DropdownMenuItem(value: s, child: Text(s)),
                  ],
                  onChanged: (s) {
                    if (s != null) _setStatus(o, s);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
