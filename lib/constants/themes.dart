// lib/constants/themes.dart
// --------------------------------------------------------------
// Custom Theme – unified black text + slightly thicker body font
//   • primary    : 청록 (#008080)
//   • secondary  : 황금 (#FFC107)
//   • background : 연미색 (#FAF9F6)
//   • 모든 본문 텍스트 색상 = 검정, weight = w500
// --------------------------------------------------------------

import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  /// ✅ Light Theme (앱 전체에서 사용)
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: Colors.black, // 통일: pure black
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,

      /// AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        titleTextStyle: AppTextStyles.titleLargeColor(colorScheme.onPrimary),
      ),

      /// Material3 NavigationBar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.08),
        iconTheme: WidgetStateProperty.all(IconThemeData(color: colorScheme.primary)),
        labelTextStyle: WidgetStateProperty.all(
          AppTextStyles.captionW500(colorScheme.onSurface),
        ),
      ),

      /// BottomNavigationBar (Material2 호환)
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: AppTextStyles.captionW500(Colors.black),
        unselectedLabelStyle: AppTextStyles.captionW500(Colors.black),
      ),

      /* Card */
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      /// Text Theme
      textTheme: TextTheme(
        bodyLarge: AppTextStyles.bodyW500(Colors.black),
        bodyMedium: AppTextStyles.captionW500(Colors.black),
      ),

      /// Default Icon Theme
      iconTheme: IconThemeData(color: colorScheme.primary),
    );
  }
}
