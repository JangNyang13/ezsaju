import 'package:flutter/material.dart';

class AppTextStyle {
  // 기본 한글 스타일
  static const TextStyle title = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  // 천간지지/한자 전용
  static const TextStyle hanjaTitle = TextStyle(
    fontFamily: 'SourceHanSansSC',
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle hanjaSmall = TextStyle(
    fontFamily: 'SourceHanSansSC',
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
}