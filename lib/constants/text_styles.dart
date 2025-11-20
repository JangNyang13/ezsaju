import 'package:flutter/material.dart';
import 'app_colors.dart';

/// EZ 사주 앱의 전역 텍스트 스타일 모음
class AppTextStyles {
  static const titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const bodySecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );

  static TextStyle sixtyGapja(Color color) {
    return TextStyle(
      fontFamily: 'SourceHanSansSC',
      fontSize: 36,
      fontWeight: FontWeight.w900,
      color: color,
      height: 1.0,
      letterSpacing: 0.5,
    );
  }

}
