import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/client.dart';
import '../../chats/chat_providers.dart';
import '../../shared/widgets.dart';
import 'client_detail_card.dart';

/// The WhatsApp numbers a unified client profile can be reached on (KAN-28):
/// the canonical primary plus any numbers folded on by merging two WhatsApp
/// contacts. Lets an agent add a free number, promote one to primary, detach
/// an additional one, or merge another contact into this profile. Hidden for
/// phone-less contacts (Instagram/Messenger-only) — they have no numbers.
class ClientPhoneNumbersCard extends ConsumerWidget {
  const ClientPhoneNumbersCard({
    super.key,
    required this.clientId,
    this.locked = false,
  });
  final String clientId;

  /// KAN-63: an active `all`-scope suppression locks contact-info editing.
  final bool locked;

  void _refresh(WidgetRef ref) =>
      ref.invalidate(clientPhoneNumbersProvider(clientId));

  Future<void> _snack(BuildContext context, String message) async {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final phoneCtrl = TextEditingController();
    final labelCtrl = TextEditingController();
    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clientPhoneNumberAddTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              autofocus: true,
              decoration: InputDecoration(hintText: l10n.clientPhoneNumberHint),
            ),
            const SizedBox(height: Insets.md),
            TextField(
              controller: labelCtrl,
              maxLength: 120,
              decoration: InputDecoration(
                hintText: l10n.clientPhoneNumberLabelHint,
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.clientPhoneNumberSave),
          ),
        ],
      ),
    );
    final phone = phoneCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    final label = labelCtrl.text.trim();
    phoneCtrl.dispose();
    labelCtrl.dispose();
    if (submitted != true || phone.isEmpty) return;
    try {
      await ref
          .read(clientPhoneNumbersRepoProvider)
          .add(
            clientId: clientId,
            phoneNumber: phone,
            label: label.isEmpty ? null : label,
          );
      _refresh(ref);
      if (context.mounted) await _snack(context, l10n.clientPhoneNumberAdded);
    } catch (e) {
      if (context.mounted) {
        await _snack(context, _errorText(e, l10n.clientPhoneNumberActionFailed));
      }
    }
  }

  Future<void> _makePrimary(
    BuildContext context,
    WidgetRef ref,
    String phoneNumberId,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(clientPhoneNumbersRepoProvider)
          .setPrimary(clientId: clientId, phoneNumberId: phoneNumberId);
      _refresh(ref);
      // The canonical number changed — refresh the header/profile too.
      ref.invalidate(clientProvider(clientId));
      if (context.mounted) {
        await _snack(context, l10n.clientPhoneNumberPrimarySet);
      }
    } catch (e) {
      if (context.mounted) {
        await _snack(context, _errorText(e, l10n.clientPhoneNumberActionFailed));
      }
    }
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    String phoneNumberId,
    String phone,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clientPhoneNumberRemove),
        content: Text(l10n.clientPhoneNumberRemoveConfirm(phone)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.ember),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.clientPhoneNumberRemove),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(clientPhoneNumbersRepoProvider)
          .remove(clientId: clientId, phoneNumberId: phoneNumberId);
      _refresh(ref);
      if (context.mounted) await _snack(context, l10n.clientPhoneNumberRemoved);
    } catch (e) {
      if (context.mounted) {
        await _snack(context, _errorText(e, l10n.clientPhoneNumberActionFailed));
      }
    }
  }

  Future<void> _merge(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final loser = await showModalBottomSheet<Client>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _MergeSearchSheet(excludeClientId: clientId),
    );
    if (loser == null) return;
    try {
      await ref
          .read(clientPhoneNumbersRepoProvider)
          .merge(winnerClientId: clientId, loserClientId: loser.id);
      _refresh(ref);
      ref.invalidate(clientProvider(clientId));
      if (context.mounted) await _snack(context, l10n.mergeContactDone);
    } catch (e) {
      if (context.mounted) {
        await _snack(context, _errorText(e, l10n.mergeContactFailed));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final numbersAsync = ref.watch(clientPhoneNumbersProvider(clientId));

    return numbersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (numbers) {
        // Phone-less contacts have no numbers to manage.
        if (numbers.isEmpty) return const SizedBox.shrink();
        return ClientDetailCard(
          title: l10n.clientPhoneNumbersTitle,
          icon: Icons.phone_outlined,
          count: numbers.length > 1 ? numbers.length : null,
          trailing: TextButton.icon(
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(l10n.clientPhoneNumberAdd),
            onPressed: locked ? null : () => _add(context, ref),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final num in numbers)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
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
                      if (!num.isPrimary && !locked)
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 20),
                          onSelected: (value) {
                            if (value == 'primary') {
                              _makePrimary(context, ref, num.id);
                            } else if (value == 'remove') {
                              _remove(context, ref, num.id, num.phoneNumber);
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'primary',
                              child: Text(l10n.clientPhoneNumberMakePrimary),
                            ),
                            PopupMenuItem(
                              value: 'remove',
                              child: Text(l10n.clientPhoneNumberRemove),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              const Divider(height: Insets.lg),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  icon: const Icon(Icons.merge_rounded, size: 18),
                  label: Text(l10n.mergeContactAction),
                  // Merge is explicitly out of scope for the KAN-63 lock.
                  onPressed: () => _merge(context, ref),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Surface the server's message (e.g. "This number already belongs to another
/// contact") when present, else a generic fallback.
String _errorText(Object error, String fallback) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
  }
  return fallback;
}

/// Bottom-sheet contact search for the merge action: type ≥2 chars, pick the
/// contact to fold INTO this profile.
class _MergeSearchSheet extends ConsumerStatefulWidget {
  const _MergeSearchSheet({required this.excludeClientId});
  final String excludeClientId;

  @override
  ConsumerState<_MergeSearchSheet> createState() => _MergeSearchSheetState();
}

class _MergeSearchSheetState extends ConsumerState<_MergeSearchSheet> {
  String _query = '';
  List<Client> _results = const [];
  bool _loading = false;

  Future<void> _search(String q) async {
    setState(() => _query = q);
    if (q.trim().length < 2) {
      setState(() => _results = const []);
      return;
    }
    setState(() => _loading = true);
    try {
      final page = await ref
          .read(clientsRepoProvider)
          .list(search: q.trim(), limit: 10);
      if (!mounted) return;
      setState(() {
        _results = page.data
            .where((c) => c.id != widget.excludeClientId)
            .toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: Insets.lg,
        right: Insets.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + Insets.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.mergeContactTitle,
            style: context.text.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Insets.xs),
          Text(
            l10n.mergeContactExplainer,
            style: context.text.bodySmall?.copyWith(
              color: context.scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Insets.md),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: l10n.mergeContactSearchHint,
            ),
            onChanged: _search,
          ),
          const SizedBox(height: Insets.md),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(Insets.lg),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: _query.trim().length < 2
                  ? const SizedBox.shrink()
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        for (final c in _results)
                          ListTile(
                            leading: InitialsAvatar(
                              initials: c.initials,
                              radius: 18,
                            ),
                            title: Text(c.displayName),
                            subtitle: c.phoneNumber != null
                                ? Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text('+${c.phoneNumber}'),
                                  )
                                : null,
                            onTap: () => Navigator.pop(context, c),
                          ),
                      ],
                    ),
            ),
        ],
      ),
    );
  }
}
