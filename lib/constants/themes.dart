// lib/constants/themes.dart
// --------------------------------------------------------------
// App-wide Theme
//  - AppBar: always black text/icons (light & dark)
//  - Light: background = #FAF9F6, surface = #FFFFFF
//  - NavBar: 기존 요구사항 유지(secondary 배경, indicator=primary)
// --------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  /// Light Theme
  static ThemeData light() {
    final base = ThemeData(useMaterial3: true);
    final scheme = ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.primary,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      surface: AppColors.surface,       // #FFFFFF
      onSurface: Colors.black,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,

      // ✅ 모든 화면 AppBar = 검정 글자/아이콘
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          fontFamily: 'NotoSansKR',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        toolbarTextStyle: TextStyle(
          fontFamily: 'NotoSansKR',
          fontSize: 16,
          color: Colors.black,
        ),
        // 상태표시줄 아이콘도 어둡게
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // Android
          statusBarBrightness: Brightness.light,    // iOS
        ),
      ),

      // NavigationBar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.secondary,   // 비활성 배경
        indicatorColor: scheme.primary,      // 활성 배경
        height: 64,
        iconTheme: WidgetStateProperty.resolveWith(
              (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.secondary
                : scheme.primary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
              (states) => AppTextStyles.captionW500(
            states.contains(WidgetState.selected)
                ? scheme.secondary
                : scheme.primary,
          ),
        ),
      ),

      // (구 M2) BottomNavigationBar 필요 시
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.secondary,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.primary,
        selectedLabelStyle: AppTextStyles.captionW500(scheme.primary),
        unselectedLabelStyle: AppTextStyles.captionW500(scheme.primary),
      ),

      // Text
      textTheme: base.textTheme.copyWith(
        bodyLarge: AppTextStyles.bodyW500(Colors.black),
        bodyMedium: AppTextStyles.captionW500(Colors.black),
      ),

      // Default Icon
      iconTheme: IconThemeData(color: scheme.primary),
    );
  }

  /// Dark Theme (요청대로 AppBar도 검정 글자 유지)
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final scheme = base.colorScheme.copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: const Color(0xFF121212),
      onSurface: Colors.white,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,

      // ✅ 다크에서도 AppBar 글자/아이콘 = 검정(요청 사항)
      // (가독성 이슈가 있으면 foreground를 Colors.white로만 바꾸면 됨)
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          fontFamily: 'NotoSansKR',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        toolbarTextStyle: TextStyle(
          fontFamily: 'NotoSansKR',
          fontSize: 16,
          color: Colors.black,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
    );
  }
}
