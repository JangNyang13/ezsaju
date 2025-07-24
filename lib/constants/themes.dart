import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.woodYang,
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'NotoSansKR',
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.surface,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.waterYang,
    ),
  ),
  dividerColor: AppColors.divider,
);
