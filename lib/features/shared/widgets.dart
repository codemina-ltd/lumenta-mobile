import 'package:flutter/material.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';

/// Circular avatar showing initials over a soft brand-tinted disc. The tint is
/// derived deterministically from the initials so a given contact always keeps
/// the same color.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({super.key, required this.initials, this.radius = 24});

  final String initials;
  final double radius;

  static const _palette = [
    AppColors.signal,
    AppColors.lilac,
    AppColors.amber,
    AppColors.ember,
    AppColors.signalDeep,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _palette[initials.hashCode.abs() % _palette.length];
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.26),
            color.withValues(alpha: 0.12),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Color.alphaBlend(
            color.withValues(alpha: 0.9),
            context.scheme.onSurface,
          ),
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.72,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Centered error state with an icon disc and a retry button.
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({super.key, required this.onRetry, this.message});

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _IconDisc(
              icon: Icons.cloud_off_rounded,
              color: AppColors.ember,
            ),
            const SizedBox(height: Insets.xl),
            Text(
              message ?? l10n.loadingError,
              textAlign: TextAlign.center,
              style: context.text.bodyLarge?.copyWith(
                color: context.scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Insets.xl),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Centered empty-state message with a friendly illustration disc.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.icon,
    this.title,
  });

  final String message;
  final IconData? icon;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _IconDisc(
              icon: icon ?? Icons.inbox_rounded,
              color: AppColors.signal,
            ),
            const SizedBox(height: Insets.xl),
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: context.text.titleMedium,
              ),
              const SizedBox(height: Insets.sm),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: context.scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconDisc extends StatelessWidget {
  const _IconDisc({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
      ),
      child: Icon(icon, size: 38, color: color),
    );
  }
}

/// A small pill used for status / severity labels.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    this.background,
    this.icon,
  });

  final String label;
  final Color color;
  final Color? background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: icon != null ? Insets.sm : Insets.md,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: context.text.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
