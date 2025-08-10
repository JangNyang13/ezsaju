// lib/constants/text_styles.dart
import 'package:flutter/material.dart';

class AppTextStyles {
  static const String fontFamily = 'NotoSansKR';

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  // ✅ 헬퍼: 색상/굵기 적용
  static TextStyle bodyW500(Color color) =>
      body.copyWith(color: color, fontWeight: FontWeight.w500);

  static TextStyle captionW500(Color color) =>
      caption.copyWith(color: color, fontWeight: FontWeight.w500);

  static TextStyle titleLargeColor(Color color) =>
      titleLarge.copyWith(color: color);
}
