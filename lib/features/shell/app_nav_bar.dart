import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';

/// A destination in [AppNavBar].
class AppNavDestination {
  const AppNavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount = 0,
    this.avatar,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int badgeCount;

  /// Rendered instead of the icon when set (the "You" tab shows the signed-in
  /// user's picture, like WhatsApp). Should be ~24pt and circular.
  final Widget? avatar;
}

/// Branded bottom navigation dock, WhatsApp-style: a floating pill inset
/// from the screen edges with an upward brand shadow, an animated pill
/// indicator behind the active icon, and ember count badges. Pure
/// presentation — route switching stays with the caller.
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final List<AppNavDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final brightness = Theme.of(context).brightness;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: Insets.sm),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.xs),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(Radii.pill),
            border: Border.all(color: scheme.outlineVariant),
            boxShadow: Shadows.dock(brightness),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              for (var i = 0; i < destinations.length; i++)
                Expanded(
                  child: _NavItem(
                    destination: destinations[i],
                    selected: i == selectedIndex,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onSelect(i);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final AppNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion ? Duration.zero : Motion.normal;
    final fast = reduceMotion ? Duration.zero : Motion.fast;

    final d = widget.destination;
    final selected = widget.selected;

    // Mirrors the filled-button pairing: signal surface, deep-forest glyph.
    final indicatorColor = isDark
        ? AppColors.signal.withValues(alpha: 0.22)
        : AppColors.signalTint;
    final iconColor = selected
        ? (isDark ? AppColors.signal : AppColors.deepForest)
        : scheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.92 : 1,
          duration: fast,
          curve: Curves.easeOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: duration,
                    curve: Motion.emphasized,
                    width: 56,
                    height: 30,
                    decoration: BoxDecoration(
                      color: selected ? indicatorColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(Radii.pill),
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: fast,
                        switchInCurve: Motion.emphasized,
                        switchOutCurve: Motion.standard,
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(
                              scale: Tween(
                                begin: 0.7,
                                end: 1.0,
                              ).animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            ),
                        child: d.avatar != null
                            ? Container(
                                key: ValueKey(selected),
                                padding: const EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected
                                        ? iconColor
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: ClipOval(child: d.avatar),
                                ),
                              )
                            : Icon(
                                selected ? d.selectedIcon : d.icon,
                                key: ValueKey(selected),
                                size: 23,
                                color: iconColor,
                              ),
                      ),
                    ),
                  ),
                  if (d.badgeCount > 0)
                    PositionedDirectional(
                      top: -4,
                      end: -2,
                      child: _CountBadge(
                        count: d.badgeCount,
                        ringColor: scheme.surfaceContainerLow,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: Insets.xs),
              AnimatedDefaultTextStyle(
                duration: fast,
                curve: Motion.standard,
                style: (context.text.labelSmall ?? const TextStyle()).copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.xs),
                  child: Text(
                    d.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ember count badge with a surface-colored ring so it reads as cut out of
/// the icon pill underneath.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.ringColor});

  final int count;
  final Color ringColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 18),
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.ember,
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(color: ringColor, width: 1.5),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          fontSize: 10,
          height: 1,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
