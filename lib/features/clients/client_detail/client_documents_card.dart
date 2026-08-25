import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/tenant_features.dart';
import '../../shared/widgets.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

/// KAN-177 — the client's Document Center (read-only preview): estimation /
/// contract / other paperwork uploaded on the web portal. Tapping a row
/// fetches a short-lived signed URL and opens the file externally.
/// Upload/delete stay portal-only.
class ClientDocumentsCard extends ConsumerWidget {
  const ClientDocumentsCard({super.key, required this.clientId});
  final String clientId;

  String _categoryLabel(AppLocalizations l10n, String category) {
    return switch (category) {
      'estimation' => l10n.clientDetailDocumentCategoryEstimation,
      'contract' => l10n.clientDetailDocumentCategoryContract,
      _ => l10n.clientDetailDocumentCategoryOther,
    };
  }

  Future<void> _open(
    BuildContext context,
    WidgetRef ref,
    String documentId,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final url = await ref
          .read(contactsRepoProvider)
          .documentUrl(clientId, documentId);
      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!ok) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.clientDetailDocumentOpenFailed)),
        );
      }
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.clientDetailDocumentOpenFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // KAN-177 addendum — Console-enabled pilot flag, default OFF. Fail
    // closed: the card only renders once the flags resolve to an explicit
    // true (a hidden card is correct while the pilot is off or unknown).
    final flags = ref.watch(tenantFeaturesProvider).asData?.value;
    if (flags?['client_documents'] != true) {
      return const SizedBox.shrink();
    }
    final async = ref.watch(clientDocumentsProvider(clientId));

    return ClientDetailCard(
      title: l10n.clientDetailDocumentsTitle,
      icon: Icons.description_outlined,
      count: async.asData?.value.length,
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(
          onRetry: () => ref.invalidate(clientDocumentsProvider(clientId)),
        ),
        data: (documents) {
          if (documents.isEmpty) {
            return ClientDetailEmpty(l10n.clientDetailDocumentsEmpty);
          }
          return Column(
            children: [
              for (final d in documents)
                InkWell(
                  onTap: () => _open(context, ref, d.id),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.insert_drive_file_outlined,
                          size: 18,
                          color: context.scheme.primary,
                        ),
                        const SizedBox(width: Insets.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d.fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.text.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                [
                                  _formatBytes(d.sizeBytes),
                                  if (d.createdAt != null)
                                    Fmt.listTimestamp(context, d.createdAt!),
                                ].join(' · '),
                                style: context.text.labelSmall?.copyWith(
                                  color: context.scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: Insets.sm),
                        StatusPill(
                          label: _categoryLabel(l10n, d.category),
                          color: context.scheme.primary,
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
