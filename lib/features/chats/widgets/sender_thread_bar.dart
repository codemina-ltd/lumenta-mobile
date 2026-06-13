import 'package:flutter/material.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/conversation_sender.dart';
import '../../../data/models/sender.dart';

/// Per-sender thread bar under the chat header: one pill per sender that has
/// history with this client (plus the active sender when it has none yet),
/// and a trailing "+" that starts a conversation via a sender without
/// history. Mobile counterpart of the portal's `SenderThreadTabs`.
class SenderThreadBar extends StatelessWidget {
  const SenderThreadBar({
    super.key,
    required this.conversationSenders,
    required this.senders,
    required this.activeSenderId,
    required this.onSelect,
  });

  final List<ConversationSender> conversationSenders;
  final List<Sender> senders;
  final String? activeSenderId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final tabs = <_TabItem>[
      for (final cs in conversationSenders)
        _TabItem(
          senderId: cs.senderId,
          label: cs.label,
          isDefault: cs.isDefault,
          isActiveSender: cs.isActive,
        ),
    ];
    // A thread started via "Start via…" has no history yet — give the active
    // sender a pill anyway so the empty thread it owns is visibly selected.
    if (activeSenderId != null &&
        !tabs.any((t) => t.senderId == activeSenderId)) {
      final s = senders.where((s) => s.id == activeSenderId).firstOrNull;
      if (s != null) {
        tabs.add(_TabItem(
          senderId: s.id,
          label: s.label,
          isDefault: s.isDefault,
          isActiveSender: s.isActive,
        ));
      }
    }
    final startVia = senders
        .where((s) => !tabs.any((t) => t.senderId == s.id))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: context.scheme.surface,
        border: Border(
          bottom: BorderSide(color: context.scheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: Insets.md,
                vertical: Insets.sm,
              ),
              child: Row(
                children: [
                  for (final tab in tabs) ...[
                    _SenderPill(
                      tab: tab,
                      selected: tab.senderId == activeSenderId,
                      onTap: () => onSelect(tab.senderId),
                    ),
                    const SizedBox(width: Insets.sm),
                  ],
                ],
              ),
            ),
          ),
          if (startVia.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: Insets.xs),
              child: IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded),
                color: context.scheme.onSurfaceVariant,
                tooltip: l10n.senderStartVia,
                onPressed: () => _openStartViaSheet(context, startVia),
              ),
            ),
        ],
      ),
    );
  }

  void _openStartViaSheet(BuildContext context, List<Sender> startVia) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.lg,
                Insets.lg,
                Insets.lg,
                Insets.sm,
              ),
              child: Text(l10n.senderStartVia, style: context.text.titleMedium),
            ),
            for (final s in startVia)
              ListTile(
                enabled: s.isActive,
                onTap: () {
                  Navigator.pop(sheetCtx);
                  onSelect(s.id);
                },
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.signal.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(Radii.md),
                  ),
                  child: const Icon(
                    Icons.phone_iphone_rounded,
                    color: AppColors.signal,
                    size: 22,
                  ),
                ),
                title: Text(s.label, style: context.text.titleMedium),
                subtitle: Text(
                  s.isActive ? (s.number ?? '') : l10n.senderInactive,
                  style: context.text.bodySmall?.copyWith(
                    color: context.scheme.onSurfaceVariant,
                  ),
                ),
                trailing: s.isDefault ? const _DefaultTag() : null,
              ),
            const SizedBox(height: Insets.md),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.senderId,
    required this.label,
    required this.isDefault,
    required this.isActiveSender,
  });

  final String senderId;
  final String label;
  final bool isDefault;
  final bool isActiveSender;
}

class _SenderPill extends StatelessWidget {
  const _SenderPill({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _TabItem tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Inactive senders stay tappable — the thread is readable; only the
    // composer is disabled (handled by ChatComposer).
    return Opacity(
      opacity: tab.isActiveSender ? 1 : 0.55,
      child: Material(
        color: selected
            ? AppColors.signalTint
            : context.scheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.pill),
          side: selected
              ? const BorderSide(color: AppColors.signal)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Radii.pill),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.md,
              vertical: 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!tab.isActiveSender) ...[
                  Icon(
                    Icons.do_not_disturb_on_outlined,
                    size: 14,
                    color: context.scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: Insets.xs),
                ],
                Text(
                  tab.label,
                  style: context.text.labelLarge?.copyWith(
                    color: selected
                        ? AppColors.signalDeep
                        : context.scheme.onSurface,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (tab.isDefault) ...[
                  const SizedBox(width: Insets.sm),
                  const _DefaultTag(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultTag extends StatelessWidget {
  const _DefaultTag();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.sm, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.lilac.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        l10n.senderDefaultTag,
        style: context.text.labelSmall?.copyWith(
          color: context.scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
