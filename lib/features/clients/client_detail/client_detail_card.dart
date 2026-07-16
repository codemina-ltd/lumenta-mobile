import 'package:flutter/material.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';

/// Shared shell for every client-detail section — a titled card with an
/// optional leading icon and trailing action, mirroring the portal's Ant
/// `Card` sections. Keeps all sections visually consistent.
class ClientDetailCard extends StatelessWidget {
  const ClientDetailCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.trailing,
    this.count,
  });

  final String title;
  final Widget child;
  final IconData? icon;
  final Widget? trailing;

  /// Optional count shown next to the title (e.g. number of segments).
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: context.scheme.onSurfaceVariant),
                  const SizedBox(width: Insets.sm),
                ],
                Flexible(
                  child: Text(
                    title,
                    style: context.text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: Insets.sm),
                  Text(
                    '$count',
                    style: context.text.labelMedium?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const Spacer(),
                ?trailing,
              ],
            ),
            const SizedBox(height: Insets.md),
            child,
          ],
        ),
      ),
    );
  }
}

/// A short muted line used as a card's empty state.
class ClientDetailEmpty extends StatelessWidget {
  const ClientDetailEmpty(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: context.text.bodySmall?.copyWith(
        color: context.scheme.onSurfaceVariant,
      ),
    );
  }
}

/// Compact inline error + retry used inside a section card when its own query
/// fails (the rest of the screen stays usable).
class ClientDetailCardError extends StatelessWidget {
  const ClientDetailCardError({super.key, required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded, size: 18),
        label: Text(AppLocalizations.of(context).retry),
      ),
    );
  }
}
