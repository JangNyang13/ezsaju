import 'package:flutter/material.dart';
import 'app_colors.dart';

/// EZ 사주 앱의 전역 텍스트 스타일 모음 (테마 대응 버전)
class AppTextStyles {
  // 기본 스타일 - context 기반 버전
  static TextStyle titleLarge(BuildContext context) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryOf(context),
  );

  static TextStyle titleMedium(BuildContext context) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryOf(context),
  );

  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryOf(context),
  );

  static TextStyle bodySecondary(BuildContext context) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryOf(context),
  );

  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondaryOf(context),
  );

  // 육십갑자용 (기존 그대로 유지)
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
