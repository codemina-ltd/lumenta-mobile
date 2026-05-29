import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

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

class AppTheme {
  const AppTheme._();

  static TextTheme _textTheme(TextTheme base) {
    // Inter Tight for everything; JetBrains Mono is applied ad-hoc for codes.
    return GoogleFonts.interTightTextTheme(base);
  }

  static TextStyle get monoStyle => GoogleFonts.jetBrainsMono();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.signal,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.signal,
      secondary: AppColors.signalDeep,
      tertiary: AppColors.ember,
      surface: AppColors.paper,
      surfaceContainerHighest: AppColors.paperWarm,
      onSurface: AppColors.deepForest,
      outlineVariant: AppColors.mist,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.paper,
    );
    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepForest,
        foregroundColor: AppColors.onDarkHigh,
        elevation: 0,
      ),
      dividerColor: AppColors.mist,
      extensions: const [
        ChatColors(
          outboundBubble: Color(0xFFCFF3E6), // Signal tint
          outboundText: AppColors.deepForest,
          inboundBubble: AppColors.paperWarm,
          inboundText: AppColors.deepForest,
        ),
      ],
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.signal,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.signal,
      secondary: AppColors.signalDeep,
      tertiary: AppColors.ember,
      surface: AppColors.deepForest,
      surfaceContainerHighest: AppColors.forest2,
      onSurface: AppColors.onDarkHigh,
      outlineVariant: const Color(0xFF24403A),
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.deepForest,
    );
    return base.copyWith(
      textTheme: _textTheme(base.textTheme).apply(
        bodyColor: AppColors.onDarkHigh,
        displayColor: AppColors.onDarkHigh,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepForest,
        foregroundColor: AppColors.onDarkHigh,
        elevation: 0,
      ),
      dividerColor: const Color(0xFF24403A),
      extensions: const [
        ChatColors(
          outboundBubble: AppColors.signalDeep,
          outboundText: AppColors.onDarkHigh,
          inboundBubble: AppColors.forest2,
          inboundText: AppColors.onDarkHigh,
        ),
      ],
    );
  }
}
