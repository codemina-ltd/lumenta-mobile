import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/contact_field.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';

/// CRM profile section — read-only view of the lifecycle stage, marketing
/// opt-in and the contact's custom field values. Profile management happens on
/// the web portal; the mobile app only previews the contact.
class ClientProfileCard extends ConsumerWidget {
  const ClientProfileCard({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(contactProfileBundleProvider(clientId));

    return ClientDetailCard(
      title: l10n.clientDetailProfile,
      icon: Icons.badge_outlined,
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.md),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(
          onRetry: () => ref.invalidate(contactProfileBundleProvider(clientId)),
        ),
        data: (bundle) {
          final profile = bundle.response.profile;
          final values = bundle.response.fieldValues;
          final stageLabel = bundle.stages
              .where((s) => s.id == profile?.lifecycleStageId)
              .firstOrNull
              ?.label;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReadOnlyRow(
                label: l10n.contactLifecycle,
                value: stageLabel ?? l10n.contactNoStage,
              ),
              _ReadOnlyRow(
                label: l10n.contactOptIn,
                value: (profile?.optInMarketing ?? false)
                    ? l10n.commonYes
                    : l10n.commonNo,
              ),
              const Divider(height: Insets.lg),
              Text(
                l10n.contactFields,
                style: context.text.labelMedium?.copyWith(
                  color: context.scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Insets.xs),
              if (bundle.fields.isEmpty)
                ClientDetailEmpty(l10n.contactNoFields)
              else
                ...bundle.fields.map(
                  (f) => _ReadOnlyRow(
                    label: f.label,
                    value: _display(l10n, f, values[f.key] ?? ''),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Human-readable value for a custom field — booleans render as Yes/No,
  /// everything else shows its stored text (or "—" when empty).
  String _display(AppLocalizations l10n, ContactField field, String value) {
    if (field.type == 'boolean') {
      return value == 'true' ? l10n.commonYes : l10n.commonNo;
    }
    return value.isEmpty ? '—' : value;
  }
}

/// One read-only label/value row.
class _ReadOnlyRow extends StatelessWidget {
  const _ReadOnlyRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.text.bodyMedium?.copyWith(
                color: context.scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: Insets.md),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
