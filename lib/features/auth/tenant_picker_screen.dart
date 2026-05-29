import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../data/models/tenant.dart';
import 'auth_controller.dart';

/// Workspace picker shown when a user belongs to >1 tenant (or none active yet).
class TenantPickerScreen extends ConsumerWidget {
  const TenantPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tenants = ref.watch(
      authControllerProvider.select((s) => s.tenants),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tenantPickerTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: tenants.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final TenantSummary t = tenants[i];
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                t.name.isNotEmpty ? t.name[0].toUpperCase() : '?',
              ),
            ),
            title: Text(t.name),
            subtitle: t.role != null ? Text(t.role!) : null,
            trailing: const Icon(Icons.chevron_right),
            enabled: t.isActive,
            onTap: () => ref
                .read(authControllerProvider.notifier)
                .selectTenant(t.id),
          );
        },
      ),
    );
  }
}
