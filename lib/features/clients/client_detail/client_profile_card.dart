import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';

/// CRM profile section — lifecycle stage + marketing opt-in quick-edit and a
/// read-out of the contact's custom field values. Mirrors the portal's
/// `ContactProfilePanel` (and reuses the same endpoints as the mobile contact
/// sheet), promoted to an inline card.
class ClientProfileCard extends ConsumerWidget {
  const ClientProfileCard({super.key, required this.clientId});
  final String clientId;

  Future<void> _setLifecycle(WidgetRef ref, String? stageId) async {
    await ref
        .read(contactsRepoProvider)
        .updateProfile(clientId, lifecycleStageId: stageId);
    ref.invalidate(contactProfileBundleProvider(clientId));
  }

  Future<void> _setOptIn(WidgetRef ref, bool value) async {
    await ref
        .read(contactsRepoProvider)
        .updateProfile(clientId, optInMarketing: value);
    ref.invalidate(contactProfileBundleProvider(clientId));
  }

  void _snackFailed(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).contactSaveFailed)),
    );
  }

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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.contactLifecycle,
                style: context.text.labelMedium?.copyWith(
                  color: context.scheme.onSurfaceVariant,
                ),
              ),
              DropdownButton<String?>(
                isExpanded: true,
                value: profile?.lifecycleStageId,
                hint: Text(l10n.contactNoStage),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.contactNoStage),
                  ),
                  for (final s in bundle.stages)
                    DropdownMenuItem<String?>(
                      value: s.id,
                      child: Text(s.label),
                    ),
                ],
                onChanged: (stageId) async {
                  try {
                    await _setLifecycle(ref, stageId);
                  } catch (_) {
                    if (context.mounted) _snackFailed(context);
                  }
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.contactOptIn),
                value: profile?.optInMarketing ?? false,
                onChanged: (value) async {
                  try {
                    await _setOptIn(ref, value);
                  } catch (_) {
                    if (context.mounted) _snackFailed(context);
                  }
                },
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
                  (f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            f.label,
                            style: context.text.bodyMedium?.copyWith(
                              color: context.scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: Insets.md),
                        Expanded(
                          child: Text(
                            (values[f.key]?.isNotEmpty ?? false)
                                ? values[f.key]!
                                : '—',
                            textAlign: TextAlign.end,
                            style: context.text.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
