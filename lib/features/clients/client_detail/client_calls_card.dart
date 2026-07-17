import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/widgets.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';
import 'client_detail_status.dart';

/// SMP call log for the contact (read-only, newest first): who handled the
/// call, when, how long, and the direction/outcome as a pill.
class ClientCallsCard extends ConsumerWidget {
  const ClientCallsCard({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(clientCallsProvider(clientId));

    return ClientDetailCard(
      title: l10n.clientDetailCallsTitle,
      icon: Icons.phone_outlined,
      count: async.asData?.value.length,
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(
          onRetry: () => ref.invalidate(clientCallsProvider(clientId)),
        ),
        data: (calls) {
          if (calls.isEmpty) {
            return ClientDetailEmpty(l10n.clientDetailCallsEmpty);
          }
          return Column(
            children: [
              for (final c in calls)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.handlerName ?? '—',
                              style: context.text.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                final started = c.startedAtDate;
                                final parts = [
                                  if (started != null)
                                    Fmt.listTimestamp(context, started),
                                  if (c.inProgress)
                                    l10n.liveCallInProgress
                                  else
                                    Fmt.duration(c.durationSeconds),
                                ];
                                return Text(
                                  parts.join(' · '),
                                  style: context.text.labelSmall?.copyWith(
                                    color: context.scheme.onSurfaceVariant,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Insets.sm),
                      StatusPill(
                        label: callDirectionLabel(l10n, c.direction),
                        color: callDirectionColor(c.direction),
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
