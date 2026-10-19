import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';

/// WhatsApp-style tab masthead: a row of round action buttons (leading on
/// the start side, trailing on the end side) above a large bold title. Each
/// tab renders its own, so the shell has no Material app bar.
class TabHeader extends StatelessWidget {
  const TabHeader({
    super.key,
    required this.title,
    this.leading = const [],
    this.trailing = const [],
    this.bottom,
  });

  final String title;
  final List<Widget> leading;
  final List<Widget> trailing;

  /// Optional content under the title (e.g. the chats filter chips).
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final hasActions = leading.isNotEmpty || trailing.isNotEmpty;
    return ColoredBox(
      color: context.scheme.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            Insets.lg,
            Insets.sm,
            Insets.lg,
            0,
          ),
          // Full width even without an actions row, otherwise a lone title
          // would size the column to itself and sit centered in the shell.
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasActions)
                  SizedBox(
                    height: HeaderCircleButton.size,
                    child: Row(
                      children: [
                        for (final w in leading) ...[
                          w,
                          const SizedBox(width: Insets.sm),
                        ],
                        const Spacer(),
                        for (final w in trailing) ...[
                          const SizedBox(width: Insets.sm),
                          w,
                        ],
                      ],
                    ),
                  ),
                SizedBox(height: hasActions ? Insets.lg : Insets.sm),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.displaySmall?.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    height: 1.1,
                  ),
                ),
                if (bottom != null) ...[
                  const SizedBox(height: Insets.md),
                  bottom!,
                ],
                const SizedBox(height: Insets.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Round 44pt header action. [primary] paints it signal-green (the "+"
/// button); otherwise it's a soft surface disc.
class HeaderCircleButton extends StatelessWidget {
  const HeaderCircleButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.primary = false,
    this.badge = false,
  });

  static const double size = 44;

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool primary;

  /// Small ember dot on the disc (e.g. unread items behind the action).
  final bool badge;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = primary ? AppColors.signal : context.scheme.surfaceContainerHigh;
    final fg = primary
        ? AppColors.deepForest
        : (isDark ? AppColors.onDarkHigh : AppColors.inkHigh);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: 22, color: fg),
                if (badge)
                  PositionedDirectional(
                    top: 9,
                    end: 9,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: AppColors.ember,
                        shape: BoxShape.circle,
                        border: Border.all(color: bg, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Header disc that opens a popup menu ("⋯" on the chats tab).
class HeaderMenuButton<T> extends StatelessWidget {
  const HeaderMenuButton({
    super.key,
    required this.tooltip,
    required this.items,
    required this.onSelected,
    this.icon = Icons.more_horiz_rounded,
  });

  final String tooltip;
  final IconData icon;
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PopupMenuButton<T>(
      tooltip: tooltip,
      position: PopupMenuPosition.under,
      offset: const Offset(0, Insets.sm),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Radii.md)),
      ),
      onSelected: onSelected,
      itemBuilder: (_) => items,
      child: Container(
        width: HeaderCircleButton.size,
        height: HeaderCircleButton.size,
        decoration: BoxDecoration(
          color: context.scheme.surfaceContainerHigh,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 22,
          color: isDark ? AppColors.onDarkHigh : AppColors.inkHigh,
        ),
      ),
    );
  }
}

/// A row in a [HeaderMenuButton] menu: icon + label.
PopupMenuItem<T> headerMenuItem<T>(
  T value,
  IconData icon,
  String label, {
  Color? color,
}) => PopupMenuItem<T>(
  value: value,
  child: Row(
    children: [
      Icon(icon, size: 20, color: color),
      const SizedBox(width: Insets.md),
      Text(label, style: color == null ? null : TextStyle(color: color)),
    ],
  ),
);
