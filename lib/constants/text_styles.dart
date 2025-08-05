//lib/constants/text_styles.dart
import 'package:flutter/material.dart';

/// 폰트는 pubspec.yaml 에 등록된 `NotoSansKR` 를 기본으로 사용
class AppTextStyles {
  static const String _fontFamily = 'NotoSansKR';

  static TextStyle get headline => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get body => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get caption => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

}
