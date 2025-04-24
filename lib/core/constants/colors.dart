import 'package:flutter/material.dart';

class AppColors {
  // Primary Color
  static const Color primary = Color(0xFF0687C9);
  static const Color primaryLight = Color(0xFF53A9D8);
  static const Color primaryDark = Color(0xFF0568A0);

  // Secondary colors
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryLight = Color(0xFF80E27E);
  static const Color secondaryDark = Color(0xFF087F23);

  // Text colors
  static const Color textPrimary = Color(0xFF303030);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);

  // Basic colors
  static const Color black = Color(0xFF000000);
  static const Color white = Colors.white;
  static const Color grey = Color(0xFFDDDDDD);
  static const Color darkGrey = Color(0xFF757575);

  // Background colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error2 = Color(0xFFFF5252);
  static const Color info = Color(0xFF2196F3);

  // Gradient colors for primary
  static List<Color> primaryGradient = [
    primary,
    const Color(0xFF0568A0),
  ];
}
