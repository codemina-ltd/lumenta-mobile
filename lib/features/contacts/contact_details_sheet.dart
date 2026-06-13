import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/providers.dart';
import '../../data/models/contact_field.dart';
import '../../data/models/contact_profile.dart';

/// Opens the contact-CRM detail sheet for a client (LUMENTA_GROWTH plan §14):
/// lifecycle + opt-in quick-edit and read of custom field values.
Future<void> showContactDetailsSheet(
  BuildContext context,
  String clientId,
) {
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
      ]);
      if (!mounted) return;
      setState(() {
        _data = results[0] as ContactProfileResponse;
        _stages = results[1] as List<ContactLifecycleStage>;
        _fields = results[2] as List<ContactField>;
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

  Future<void> _setLifecycle(String? stageId) async {
    try {
      await ref
          .read(contactsRepoProvider)
          .updateProfile(widget.clientId, lifecycleStageId: stageId);
      await _load();
    } catch (_) {
      _snack();
    }
  }

  Future<void> _setOptIn(bool value) async {
    try {
      await ref
          .read(contactsRepoProvider)
          .updateProfile(widget.clientId, optInMarketing: value);
      await _load();
    } catch (_) {
      _snack();
    }
  }

  void _snack() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.contactSaveFailed)));
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
                    const SizedBox(height: 16),
                    Text(l10n.contactLifecycle,
                        style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 4),
                    DropdownButton<String?>(
                      isExpanded: true,
                      value: profile?.lifecycleStageId,
                      hint: Text(l10n.contactNoStage),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.contactNoStage),
                        ),
                        for (final s in _stages)
                          DropdownMenuItem<String?>(
                            value: s.id,
                            child: Text(s.label),
                          ),
                      ],
                      onChanged: _setLifecycle,
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.contactOptIn),
                      value: profile?.optInMarketing ?? false,
                      onChanged: _setOptIn,
                    ),
                    const Divider(),
                    Text(l10n.contactFields,
                        style: Theme.of(context).textTheme.labelMedium),
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
