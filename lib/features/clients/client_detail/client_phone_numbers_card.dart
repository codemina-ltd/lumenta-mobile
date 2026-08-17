import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../chats/chat_providers.dart';
import '../../shared/widgets.dart';
import 'client_detail_card.dart';

/// The WhatsApp numbers a unified client profile can be reached on (KAN-28):
/// the canonical primary plus any numbers folded on by merging two WhatsApp
/// contacts. Read-only on mobile — add/promote/detach/merge happen on the web
/// portal. Hidden for phone-less contacts (Instagram/Messenger-only).
class ClientPhoneNumbersCard extends ConsumerWidget {
  const ClientPhoneNumbersCard({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final numbersAsync = ref.watch(clientPhoneNumbersProvider(clientId));

    return numbersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (numbers) {
        // Phone-less contacts have no numbers to show.
        if (numbers.isEmpty) return const SizedBox.shrink();
        return ClientDetailCard(
          title: l10n.clientPhoneNumbersTitle,
          icon: Icons.phone_outlined,
          count: numbers.length > 1 ? numbers.length : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final num in numbers)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              num.phoneNumber,
                              style: context.text.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (num.isPrimary) ...[
                            const SizedBox(width: Insets.sm),
                            StatusPill(
                              label: l10n.clientPhoneNumberPrimary,
                              color: AppColors.signal,
                            ),
                          ],
                        ],
                      ),
                      if (num.label != null && num.label!.isNotEmpty)
                        Text(
                          num.label!,
                          style: context.text.bodySmall?.copyWith(
                            color: context.scheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
