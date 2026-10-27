import 'package:flutter/material.dart';

/// Brand colours for SXM.EDITX.
class AppColors {
  static const blue = Color(0xFF2596BE);

  /// Darker blue for small text on white (passes WCAG AA contrast).
  static const blueInk = Color(0xFF156B8A);
  static const blueSoft = Color(0xFFE8F4F9);
  static const ink = Color(0xFF0D0D0D);
  static const ink2 = Color(0xFF4A4A4A);
  static const muted = Color(0xFF6B6B6B);
  static const line = Color(0xFFE6E6E6);
  static const bg = Color(0xFFFFFFFF);
  static const bg2 = Color(0xFFF5F7F8);
}

class AppText {
  /// Display / headings.
  static TextStyle display({
    double size = 48,
    FontWeight weight = FontWeight.w800,
    Color color = AppColors.ink,
    double height = 1.02,
  }) => TextStyle(
    fontFamily: 'Bricolage',
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: -size * 0.03,
  );

  /// Body copy.
  static TextStyle body({
    double size = 17,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.ink2,
    double height = 1.6,
  }) => TextStyle(
    fontFamily: 'Manrope',
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Manrope',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      primary: AppColors.blue,
      surface: AppColors.bg,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.blue,
      selectionColor: Color(0x552596BE),
    ),
  );
}

/// Responsive breakpoints.
class Breakpoints {
  static const mobile = 700.0;
  static const tablet = 1024.0;
  static const maxContent = 1200.0;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isMobile => screenWidth < Breakpoints.mobile;
  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;
  bool get isDesktop => screenWidth >= Breakpoints.tablet;

  /// Picks a value based on the current breakpoint.
  T responsive<T extends Object>({
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isMobile) return mobile;
    if (isTablet) return tablet ?? desktop;
    return desktop;
  }

  bool get reduceMotion => MediaQuery.of(this).disableAnimations;
}
