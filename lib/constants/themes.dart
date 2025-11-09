import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_styles.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'NotoSansKR',
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
  ),
  textTheme: const TextTheme(
    bodyMedium: AppTextStyles.body,
    titleMedium: AppTextStyles.titleMedium,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    elevation: 0,
    titleTextStyle: AppTextStyles.titleMedium,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.yin,
  fontFamily: 'NotoSansKR',
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.yang),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: AppColors.yang,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: AppColors.yang),
  ),
);
