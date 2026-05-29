import 'package:flutter/material.dart';

/// Lumenta brand palette (Brand Identity v1).
class AppColors {
  const AppColors._();

  // Chrome / dark surfaces
  static const deepForest = Color(0xFF0A1F1C); // primary / chrome
  static const forest2 = Color(0xFF112B27); // surface (dark)

  // Accents
  static const signal = Color(0xFF00C896); // accent
  static const signalDeep = Color(0xFF00A578); // accent hover/pressed
  static const ember = Color(0xFFFF6B4A); // counter-accent

  // Light surfaces
  static const paper = Color(0xFFF5F1E8); // light background
  static const paperWarm = Color(0xFFEDE7D8); // card

  // Text / lines
  static const slate = Color(0xFF4F5A56); // body text
  static const mist = Color(0xFFB8BCB5); // divider

  // Data / status
  static const lilac = Color(0xFFB8A4FF); // data
  static const amber = Color(0xFFF2B33D); // premium

  // Convenience light text colors on dark chrome
  static const onDarkHigh = Color(0xFFF5F1E8);
  static const onDarkMed = Color(0xFFB8BCB5);
}
