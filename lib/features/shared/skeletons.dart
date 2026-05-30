import 'package:flutter/material.dart';

import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';

/// Animated shimmer that sweeps a highlight across its [child]. Wrap a tree of
/// [SkeletonBox]es in a single [Shimmer] so they pulse in unison.
class Shimmer extends StatefulWidget {
  const Shimmer({super.key, required this.child});

  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.scheme.surfaceContainerHigh;
    final highlight = Color.lerp(
      base,
      context.scheme.onSurface,
      context.scheme.brightness == Brightness.dark ? 0.06 : 0.04,
    )!;

    return AnimatedBuilder(
      animation: _ctrl,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final dx = bounds.width * (2 * _ctrl.value - 1) * 1.4;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlideGradient(dx),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.dx);
  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(dx, 0, 0);
}

/// A single placeholder block. Pre-tinted to the shimmer base color so it
/// reads as a skeleton even before the sweep animates.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = Radii.sm,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double height;
  final double radius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.scheme.surfaceContainerHigh,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(radius),
      ),
    );
  }
}

/// Skeleton placeholder for an avatar + two text lines list row.
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key, this.lines = 2});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SkeletonBox(width: 48, height: 48, shape: BoxShape.circle),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(width: 150, height: 13),
                const SizedBox(height: Insets.sm),
                SkeletonBox(
                  width: lines > 1 ? 220 : 90,
                  height: 11,
                ),
              ],
            ),
          ),
          const SizedBox(width: Insets.md),
          const SkeletonBox(width: 34, height: 10),
        ],
      ),
    );
  }
}

/// A full list of shimmering rows for first-load states.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 8, this.lines = 2});

  final int count;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: Insets.sm),
        itemCount: count,
        itemBuilder: (_, _) => SkeletonListTile(lines: lines),
      ),
    );
  }
}
