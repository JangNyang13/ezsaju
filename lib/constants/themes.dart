//lib/constants/themes.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  /// Light Theme
  static ThemeData light() {
    // Material 3 권장: seedColor 로 컬러스킴 생성
    final colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.primary,
    ).copyWith(
      secondary: AppColors.secondary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // scaffold 배경은 surface(또는 직접 색 지정) 사용
      scaffoldBackgroundColor: colorScheme.surface,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        titleTextStyle: AppTextStyles.headline.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),

      // Text
      textTheme: TextTheme(
        bodyLarge: AppTextStyles.body.apply(color: colorScheme.onSurface),
        bodyMedium: AppTextStyles.caption.apply(color: colorScheme.onSurface),
      ),

      // CardThemeData 사용
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      iconTheme: IconThemeData(color: colorScheme.primary),
    );
  }

  /// Dark Theme
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),
      textTheme: base.textTheme.apply(fontFamily: 'NotoSansKR'),
    );
  }
}
