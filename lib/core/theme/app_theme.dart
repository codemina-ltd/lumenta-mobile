import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_dimens.dart';

/// Brand chat-bubble colors, exposed via [ThemeExtension] so widgets can read
/// inbound/outbound tints without hard-coding palette values.
@immutable
class ChatColors extends ThemeExtension<ChatColors> {
  const ChatColors({
    required this.outboundBubble,
    required this.outboundText,
    required this.inboundBubble,
    required this.inboundText,
  });

  final Color outboundBubble;
  final Color outboundText;
  final Color inboundBubble;
  final Color inboundText;

  @override
  ChatColors copyWith({
    Color? outboundBubble,
    Color? outboundText,
    Color? inboundBubble,
    Color? inboundText,
  }) => ChatColors(
    outboundBubble: outboundBubble ?? this.outboundBubble,
    outboundText: outboundText ?? this.outboundText,
    inboundBubble: inboundBubble ?? this.inboundBubble,
    inboundText: inboundText ?? this.inboundText,
  );

  @override
  ChatColors lerp(ThemeExtension<ChatColors>? other, double t) {
    if (other is! ChatColors) return this;
    return ChatColors(
      outboundBubble: Color.lerp(outboundBubble, other.outboundBubble, t)!,
      outboundText: Color.lerp(outboundText, other.outboundText, t)!,
      inboundBubble: Color.lerp(inboundBubble, other.inboundBubble, t)!,
      inboundText: Color.lerp(inboundText, other.inboundText, t)!,
    );
  }
}

/// Brand surface accents that aren't part of the Material [ColorScheme] —
/// gradients for brand moments and the hairline used for soft separators.
@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  const BrandColors({
    required this.brandGradient,
    required this.accentGradient,
    required this.hairline,
    required this.raisedSurface,
  });

  final List<Color> brandGradient;
  final List<Color> accentGradient;
  final Color hairline;
  final Color raisedSurface;

  LinearGradient get brand => LinearGradient(
    colors: brandGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get accent => LinearGradient(
    colors: accentGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  BrandColors copyWith({
    List<Color>? brandGradient,
    List<Color>? accentGradient,
    Color? hairline,
    Color? raisedSurface,
  }) => BrandColors(
    brandGradient: brandGradient ?? this.brandGradient,
    accentGradient: accentGradient ?? this.accentGradient,
    hairline: hairline ?? this.hairline,
    raisedSurface: raisedSurface ?? this.raisedSurface,
  );

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) {
    if (other is! BrandColors) return this;
    return BrandColors(
      brandGradient: [
        Color.lerp(brandGradient.first, other.brandGradient.first, t)!,
        Color.lerp(brandGradient.last, other.brandGradient.last, t)!,
      ],
      accentGradient: [
        Color.lerp(accentGradient.first, other.accentGradient.first, t)!,
        Color.lerp(accentGradient.last, other.accentGradient.last, t)!,
      ],
      hairline: Color.lerp(hairline, other.hairline, t)!,
      raisedSurface: Color.lerp(raisedSurface, other.raisedSurface, t)!,
    );
  }
}

/// Convenience accessors so screens read `context.brand` / `context.chat`.
extension ThemeX on BuildContext {
  BrandColors get brand => Theme.of(this).extension<BrandColors>()!;
  ChatColors get chat => Theme.of(this).extension<ChatColors>()!;
  ColorScheme get scheme => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}

class AppTheme {
  const AppTheme._();

  static TextStyle get monoStyle => GoogleFonts.jetBrainsMono();

  /// Inter Tight throughout, with tightened tracking on display/headline sizes
  /// for a more deliberate, premium masthead feel.
  static TextTheme _textTheme(TextTheme base, Color color) {
    final t = GoogleFonts.interTightTextTheme(base).apply(
      bodyColor: color,
      displayColor: color,
    );
    return t.copyWith(
      displaySmall: t.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: t.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      headlineSmall: t.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleLarge: t.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: t.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelSmall: t.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
    );
  }

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.signal,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.signal,
          onPrimary: AppColors.deepForest,
          secondary: AppColors.signalDeep,
          tertiary: AppColors.ember,
          surface: isDark ? AppColors.deepForest : AppColors.paper,
          onSurface: isDark ? AppColors.onDarkHigh : AppColors.inkHigh,
          surfaceContainerLowest: isDark
              ? AppColors.deepForest
              : AppColors.paper,
          surfaceContainerLow: isDark ? AppColors.forest2 : AppColors.paperRaised,
          surfaceContainer: isDark ? AppColors.forest2 : AppColors.paperRaised,
          surfaceContainerHigh: isDark
              ? AppColors.forest3
              : AppColors.paperWarm,
          surfaceContainerHighest: isDark
              ? AppColors.forest3
              : AppColors.paperWarm,
          onSurfaceVariant: isDark ? AppColors.onDarkMed : AppColors.inkMed,
          outline: isDark ? AppColors.forestLine : AppColors.hairline,
          outlineVariant: isDark ? AppColors.forestLine : AppColors.hairline,
          error: AppColors.ember,
        );

    final onSurface = scheme.onSurface;
    final textTheme = _textTheme(
      ThemeData(brightness: brightness).textTheme,
      onSurface,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor: scheme.surface,
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      textTheme: textTheme,
      visualDensity: VisualDensity.standard,
      dividerColor: scheme.outlineVariant,
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontSize: 22),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: Radii.card),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.xs,
        ),
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        shape: const RoundedRectangleBorder(borderRadius: Radii.card),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.forest2 : AppColors.paperRaised,
        hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.md,
        ),
        prefixIconColor: scheme.onSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: Radii.field,
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Radii.field,
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: Radii.field,
          borderSide: BorderSide(color: AppColors.signal, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radii.field,
          borderSide: const BorderSide(color: AppColors.ember),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Radii.field,
          borderSide: const BorderSide(color: AppColors.ember, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.signal,
          foregroundColor: AppColors.deepForest,
          disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
          minimumSize: const Size.fromHeight(54),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 15),
          shape: const RoundedRectangleBorder(borderRadius: Radii.field),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          minimumSize: const Size.fromHeight(50),
          side: BorderSide(color: scheme.outline),
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: Radii.field),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.signalDeep,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: isDark ? AppColors.forest2 : AppColors.paperRaised,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.signal.withValues(alpha: isDark ? 0.22 : 0.18),
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radii.pill)),
        ),
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected
                ? (isDark ? AppColors.signal : AppColors.signalDeep)
                : scheme.onSurfaceVariant,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        side: BorderSide.none,
        labelStyle: textTheme.labelSmall?.copyWith(color: onSurface),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: scheme.outline,
        shape: const RoundedRectangleBorder(borderRadius: Radii.sheet),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radii.xl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepForest,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.onDarkHigh,
        ),
        actionTextColor: AppColors.signal,
        shape: const RoundedRectangleBorder(borderRadius: Radii.field),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.signal,
        foregroundColor: AppColors.deepForest,
        elevation: 2,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.signal,
        circularTrackColor: Colors.transparent,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.deepForest,
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        textStyle: textTheme.labelSmall?.copyWith(color: AppColors.onDarkHigh),
      ),
      extensions: [
        isDark
            ? const ChatColors(
                outboundBubble: AppColors.signalDeep,
                outboundText: AppColors.onDarkHigh,
                inboundBubble: AppColors.forest3,
                inboundText: AppColors.onDarkHigh,
              )
            : const ChatColors(
                outboundBubble: AppColors.signalTint,
                outboundText: AppColors.deepForest,
                inboundBubble: AppColors.paperRaised,
                inboundText: AppColors.deepForest,
              ),
        BrandColors(
          brandGradient: const [Color(0xFF0E2A25), AppColors.deepForest],
          accentGradient: const [AppColors.signal, AppColors.signalDeep],
          hairline: scheme.outlineVariant,
          raisedSurface: scheme.surfaceContainerLow,
        ),
      ],
    );
  }
}
