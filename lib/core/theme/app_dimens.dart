import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Spacing scale (4-pt grid). Use these instead of magic numbers so rhythm
/// stays consistent across every screen.
class Insets {
  const Insets._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;
}

/// Corner radii. The app leans on soft, generous rounding for a premium feel.
class Radii {
  const Radii._();

  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double pill = 999;

  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius field = BorderRadius.all(Radius.circular(md));
  static const BorderRadius sheet = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
}

/// Motion tokens — calm, confident easing. Short for feedback, medium for
/// transitions. Always pair [emphasized] with these durations.
class Motion {
  const Motion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 360);

  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve standard = Curves.easeInOut;
}

/// Brand-tinted elevation. Material's default grey shadows look muddy on the
/// warm paper surface, so shadows are tinted with deep forest at low alpha.
class Shadows {
  const Shadows._();

  /// Resting elevation for cards and list surfaces.
  static List<BoxShadow> soft(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 16,
          offset: Offset(0, 6),
        ),
      ];
    }
    return [
      BoxShadow(
        color: AppColors.deepForest.withValues(alpha: 0.06),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: AppColors.deepForest.withValues(alpha: 0.04),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ];
  }

  /// Stronger elevation for floating elements (FAB, raised composer).
  static List<BoxShadow> lifted(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const [
        BoxShadow(
          color: Color(0x4D000000),
          blurRadius: 24,
          offset: Offset(0, 10),
        ),
      ];
    }
    return [
      BoxShadow(
        color: AppColors.deepForest.withValues(alpha: 0.12),
        blurRadius: 28,
        offset: const Offset(0, 12),
      ),
    ];
  }
}
