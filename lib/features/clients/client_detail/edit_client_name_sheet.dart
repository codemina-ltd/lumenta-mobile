import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/client.dart';
import '../../chats/chat_providers.dart';
import '../../chats/chats_controller.dart';
import '../../inbox/inbox_controller.dart';
import '../clients_controller.dart';
import 'client_detail_providers.dart';

/// KAN-301 — the API answered 403 to a display-name edit (the member's role
/// is below the tenant's `display_name` field ACL). Remembered for the
/// session so the edit affordance disappears instead of failing again.
final clientNameEditForbiddenProvider =
    NotifierProvider<ClientNameEditForbidden, bool>(
      ClientNameEditForbidden.new,
    );

class ClientNameEditForbidden extends Notifier<bool> {
  @override
  bool build() => false;

  void markForbidden() => state = true;
}

/// KAN-301 — "Edit name": sets the name THIS workspace shows for a client
/// (`PATCH /contacts/:id/profile { displayName }`). The customer's WhatsApp
/// profile name is never touched; clearing the field falls back to it.
Future<void> showEditClientNameSheet(
  BuildContext context,
  WidgetRef ref, {
  required Client client,
}) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  final result = await showModalBottomSheet<_NameEdit>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _EditClientNameSheet(client: client),
  );
  if (result == null || !context.mounted) return;

  try {
    await ref
        .read(contactsRepoProvider)
        .updateProfile(client.id, displayName: result.value);
  } on DioException catch (e) {
    if (e.response?.statusCode == 403) {
      ref.read(clientNameEditForbiddenProvider.notifier).markForbidden();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.clientDetailNameForbidden)),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.clientDetailNameSaveFailed)),
      );
    }
    return;
  } catch (_) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.clientDetailNameSaveFailed)),
    );
    return;
  }

  // The name is read from several places — refresh them all so the header,
  // the chats list, the clients list and the inbox agree.
  ref.invalidate(clientProvider(client.id));
  ref.invalidate(contactProfileBundleProvider(client.id));
  // The list controllers reload on rebuild; invalidating is a no-op when a
  // list isn't alive (autoDispose), so nothing is created just to refresh.
  ref.invalidate(chatsControllerProvider);
  ref.invalidate(clientsControllerProvider);
  ref.invalidate(inboxControllerProvider);
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        result.value.isEmpty
            ? l10n.clientDetailNameReset
            : l10n.clientDetailNameSaved,
      ),
    ),
  );
}

/// '' means "clear the workspace name" (fall back to the WhatsApp name).
class _NameEdit {
  const _NameEdit(this.value);
  final String value;
}

class _EditClientNameSheet extends StatefulWidget {
  const _EditClientNameSheet({required this.client});
  final Client client;

  @override
  State<_EditClientNameSheet> createState() => _EditClientNameSheetState();
}

class _EditClientNameSheetState extends State<_EditClientNameSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.client.workspaceName?.trim() ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final whatsAppName = widget.client.profileName?.trim();
    final hasWhatsAppName = whatsAppName != null && whatsAppName.isNotEmpty;
    final hasWorkspaceName =
        (widget.client.workspaceName?.trim().isNotEmpty) ?? false;

    return Padding(
      padding: EdgeInsets.only(
        left: Insets.lg,
        right: Insets.lg,
        top: Insets.sm,
        bottom: MediaQuery.viewInsetsOf(context).bottom + Insets.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.clientDetailEditName, style: context.text.titleLarge),
          const SizedBox(height: Insets.xs),
          Text(
            l10n.clientDetailEditNameHint,
            style: context.text.bodySmall?.copyWith(
              color: context.scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Insets.lg),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: 255,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n.clientDetailNameLabel,
              hintText: hasWhatsAppName ? whatsAppName : null,
              counterText: '',
            ),
            onSubmitted: (_) => _save(),
          ),
          if (hasWhatsAppName) ...[
            const SizedBox(height: Insets.sm),
            Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 16,
                  color: context.scheme.onSurfaceVariant,
                ),
                const SizedBox(width: Insets.xs),
                Expanded(
                  child: Text(
                    l10n.clientDetailWhatsAppName(whatsAppName),
                    style: context.text.bodySmall?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasWorkspaceName)
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(const _NameEdit('')),
                    child: Text(l10n.clientDetailUseWhatsAppName),
                  ),
              ],
            ),
          ],
          const SizedBox(height: Insets.lg),
          // Theme buttons are full-width (minimumSize infinity), so stack them.
          FilledButton(
            onPressed: _save,
            child: Text(l10n.clientDetailNameSave),
          ),
          const SizedBox(height: Insets.xs),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.clientDetailNameCancel),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    Navigator.of(context).pop(_NameEdit(_controller.text.trim()));
  }
}
