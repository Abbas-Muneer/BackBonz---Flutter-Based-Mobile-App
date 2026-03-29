import 'package:flutter/material.dart';

class AppColors {
  static const Color canvas = Color(0xFFF8FAFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF0F4FF);
  static const Color primary = Color(0xFF7D8EF7);
  static const Color primaryDark = Color(0xFF5C6BE2);
  static const Color secondary = Color(0xFF8ED8C9);
  static const Color accent = Color(0xFFFFB7A1);
  static const Color textPrimary = Color(0xFF24314D);
  static const Color textMuted = Color(0xFF7080A0);
  static const Color success = Color(0xFF56B58A);
  static const Color error = Color(0xFFE46F7A);
  static const Color border = Color(0xFFD9E1F4);

  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF9F4FF), Color(0xFFF5FBFF), Color(0xFFF6FFF9)],
  );
}
