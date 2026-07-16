import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/contact_field.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';

/// CRM profile section — lifecycle stage + marketing opt-in quick-edit and the
/// contact's custom fields. Mirrors the portal's `ContactProfilePanel`: every
/// custom field is editable with a type-appropriate input (text/number/url/
/// email dialog, select picker, multiselect checklist, date picker, or an
/// inline boolean toggle), each persisted via `PUT /contacts/:id/fields`.
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

  /// Persists a custom field value then refreshes the bundle.
  Future<void> _setField(
    BuildContext context,
    WidgetRef ref,
    String key,
    Object? value,
  ) async {
    try {
      await ref.read(contactsRepoProvider).setFieldValue(clientId, key, value);
      ref.invalidate(contactProfileBundleProvider(clientId));
    } catch (_) {
      if (context.mounted) _snackFailed(context);
    }
  }

  /// Opens the type-appropriate editor for a custom field and, if a value comes
  /// back, persists it. Boolean fields toggle inline and don't reach here.
  Future<void> _editField(
    BuildContext context,
    WidgetRef ref,
    ContactField field,
    String current,
  ) async {
    final String? next;
    final type = field.type;
    if (type == 'date') {
      next = await _pickDate(context, current);
    } else if (type == 'select') {
      next = await _pickSelect(context, field, current);
    } else if (type == 'multiselect') {
      next = await _pickMultiSelect(context, field, current);
    } else {
      next = await _editText(context, field, current);
    }
    if (next == null || !context.mounted) return;
    await _setField(context, ref, field.key, next);
  }

  void _snackFailed(BuildContext context) {
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
                  (f) => _CustomFieldRow(
                    field: f,
                    value: values[f.key] ?? '',
                    onEdit: () =>
                        _editField(context, ref, f, values[f.key] ?? ''),
                    onToggle: (v) =>
                        _setField(context, ref, f.key, v ? 'true' : 'false'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// One editable custom-field row. Boolean fields show an inline switch; every
/// other type opens an editor on tap and shows the current value (or "—").
class _CustomFieldRow extends StatelessWidget {
  const _CustomFieldRow({
    required this.field,
    required this.value,
    required this.onEdit,
    required this.onToggle,
  });

  final ContactField field;
  final String value;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.text.bodyMedium?.copyWith(
      color: context.scheme.onSurfaceVariant,
    );

    if (field.type == 'boolean') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(child: Text(field.label, style: labelStyle)),
            Switch(value: value == 'true', onChanged: onToggle),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(child: Text(field.label, style: labelStyle)),
            const SizedBox(width: Insets.md),
            Flexible(
              child: Text(
                value.isEmpty ? '—' : value,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodyMedium,
              ),
            ),
            const SizedBox(width: Insets.xs),
            Icon(
              Icons.edit_outlined,
              size: 16,
              color: context.scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Per-type editors ────────────────────────────────────────────────────────

/// Text / number / url / email — a single-field dialog. Returns the (trimmed)
/// text, or null when cancelled.
Future<String?> _editText(
  BuildContext context,
  ContactField field,
  String current,
) {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController(text: current);
  final keyboard = switch (field.type) {
    'number' => const TextInputType.numberWithOptions(decimal: true),
    'email' => TextInputType.emailAddress,
    'url' => TextInputType.url,
    _ => TextInputType.text,
  };
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(field.label),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: keyboard,
        decoration: InputDecoration(hintText: field.label),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, controller.text.trim()),
          child: Text(l10n.inboxSave),
        ),
      ],
    ),
  );
}

/// Date field — the OS date picker. Stores an ISO `YYYY-MM-DD` string.
Future<String?> _pickDate(BuildContext context, String current) async {
  final initial = DateTime.tryParse(current) ?? DateTime.now();
  final picked = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (picked == null) return null;
  return picked.toIso8601String().split('T').first;
}

/// Single-choice select — a bottom sheet of the field's options plus a clear
/// action. Returns the chosen option, '' to clear, or null when dismissed.
Future<String?> _pickSelect(
  BuildContext context,
  ContactField field,
  String current,
) {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final o in field.options ?? const [])
            ListTile(
              title: Text(o),
              trailing: o == current ? const Icon(Icons.check_rounded) : null,
              onTap: () => Navigator.pop(sheetContext, o),
            ),
          ListTile(
            leading: const Icon(Icons.clear_rounded),
            title: Text(l10n.clientDetailClear),
            onTap: () => Navigator.pop(sheetContext, ''),
          ),
        ],
      ),
    ),
  );
}

/// Multi-choice select — a checklist bottom sheet. Returns the selected values
/// joined by ', ' (the portal's storage format), or null when dismissed.
Future<String?> _pickMultiSelect(
  BuildContext context,
  ContactField field,
  String current,
) {
  final initial = current.isEmpty
      ? <String>{}
      : current.split(', ').where((e) => e.isNotEmpty).toSet();
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) =>
        _MultiSelectSheet(options: field.options ?? const [], initial: initial),
  );
}

class _MultiSelectSheet extends StatefulWidget {
  const _MultiSelectSheet({required this.options, required this.initial});
  final List<String> options;
  final Set<String> initial;

  @override
  State<_MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<_MultiSelectSheet> {
  late final Set<String> _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final o in widget.options)
                  CheckboxListTile(
                    value: _selected.contains(o),
                    title: Text(o),
                    onChanged: (v) => setState(
                      () => v == true ? _selected.add(o) : _selected.remove(o),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Insets.md),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, _selected.join(', ')),
                child: Text(l10n.inboxSave),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
