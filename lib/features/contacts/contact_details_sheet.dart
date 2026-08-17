import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/providers.dart';
import '../../data/models/contact_field.dart';
import '../../data/models/contact_profile.dart';
import '../../data/repos/contacts_repo.dart';

/// Opens the contact-CRM detail sheet for a client (LUMENTA_GROWTH plan §14):
/// a read-only preview of lifecycle, opt-in and custom field values — profile
/// editing happens on the web portal, not on mobile.
Future<void> showContactDetailsSheet(BuildContext context, String clientId) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _ContactDetailsSheet(clientId: clientId),
  );
}

class _ContactDetailsSheet extends ConsumerStatefulWidget {
  const _ContactDetailsSheet({required this.clientId});
  final String clientId;

  @override
  ConsumerState<_ContactDetailsSheet> createState() => _SheetState();
}

class _SheetState extends ConsumerState<_ContactDetailsSheet> {
  ContactProfileResponse? _data;
  List<ContactLifecycleStage> _stages = const [];
  List<ContactField> _fields = const [];
  List<CtwaReferral> _ctwa = const [];
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final repo = ref.read(contactsRepoProvider);
      final results = await Future.wait([
        repo.profile(widget.clientId),
        repo.lifecycleStages(),
        repo.fields(),
        repo.ctwa(widget.clientId),
      ]);
      if (!mounted) return;
      setState(() {
        _data = results[0] as ContactProfileResponse;
        _stages = results[1] as List<ContactLifecycleStage>;
        _fields = results[2] as List<ContactField>;
        _ctwa = results[3] as List<CtwaReferral>;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = _data?.profile;
    final values = _data?.fieldValues ?? const {};

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: _loading
          ? const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          : _error
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.contactLoadError),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.contactDetails,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_ctwa.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.campaign_outlined, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${l10n.contactCameFrom} ${_ctwa.first.label}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.contactLifecycle),
                      Flexible(
                        child: Text(
                          _stages
                                  .where(
                                    (s) => s.id == profile?.lifecycleStageId,
                                  )
                                  .firstOrNull
                                  ?.label ??
                              l10n.contactNoStage,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.contactOptIn),
                      Text(
                        (profile?.optInMarketing ?? false)
                            ? l10n.commonYes
                            : l10n.commonNo,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Text(
                  l10n.contactFields,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                if (_fields.isEmpty)
                  Text(l10n.contactNoFields)
                else
                  ..._fields.map(
                    (f) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(f.label),
                          Flexible(
                            child: Text(
                              values[f.key] ?? '—',
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
