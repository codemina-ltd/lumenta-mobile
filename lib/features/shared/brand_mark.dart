import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';

/// The shipped app launcher icon (`assets/images/app_icon.png`), rounded to the
/// launcher squircle and lifted with the signal glow. Use this where the real
/// brand icon is wanted rather than the abstract [LumentaMark] glyph.
class AppIconMark extends StatelessWidget {
  const AppIconMark({super.key, this.size = 64, this.radius = Radii.lg});

  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.onDarkHigh.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.signal.withValues(alpha: 0.30),
            blurRadius: size * 0.42,
            offset: Offset(0, size * 0.14),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/app_icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.deepForest
      ..style = PaintingStyle.fill;

    // Four-point sparkle: concave diamond built from the center to each tip.
    final rx = size.width / 2;
    final ry = size.height / 2;
    final waist = rx * 0.36;
    final path = Path()
      ..moveTo(c.dx, c.dy - ry) // top
      ..quadraticBezierTo(
        c.dx + waist * 0.4,
        c.dy - waist * 0.4,
        c.dx + rx,
        c.dy,
      ) // right
      ..quadraticBezierTo(
        c.dx + waist * 0.4,
        c.dy + waist * 0.4,
        c.dx,
        c.dy + ry,
      ) // bottom
      ..quadraticBezierTo(
        c.dx - waist * 0.4,
        c.dy + waist * 0.4,
        c.dx - rx,
        c.dy,
      ) // left
      ..quadraticBezierTo(
        c.dx - waist * 0.4,
        c.dy - waist * 0.4,
        c.dx,
        c.dy - ry,
      )
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// The "Lumenta" wordmark with a tracking tuned for headers.
class LumentaWordmark extends StatelessWidget {
  const LumentaWordmark({super.key, this.fontSize = 28, this.color});

  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Lumenta',
      style: context.text.headlineSmall?.copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: color ?? context.scheme.onSurface,
      ),
    );
  }
}
