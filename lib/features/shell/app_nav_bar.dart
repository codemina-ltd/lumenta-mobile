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
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int badgeCount;
}

/// Branded bottom navigation dock: a raised surface with rounded top corners
/// and an upward brand shadow, an animated pill indicator behind the active
/// icon, and ember count badges. Pure presentation — route switching stays
/// with the caller.
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

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Radii.xl),
        ),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: Shadows.dock(brightness),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
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
                              scale: Tween(begin: 0.7, end: 1.0)
                                  .animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            ),
                        child: Icon(
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
