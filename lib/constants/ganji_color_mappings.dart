// lib/constants/ganji_color_mappings.dart
// ------------------------------------------------------------
// 60갑자 ‘한 글자 단위’ 색 매핑 전용.
//    • 천간 10자 + 지지 12자 = 총 22자 색상 표만 유지
//    • 두 글자(갑자‧병인…) 혼합 색 로직은 제거했습니다.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'colors.dart';

/// 천간·지지 글자 하나를 넣으면 대응 색을 돌려준다.
Color colorOfGanjiChar(String char) => _ganjiColorMap[char] ?? Colors.white;

const Map<String, Color> _ganjiColorMap = {
  // ─── 천간 ───
  '甲': AppColors.wood,
  '乙': AppColors.wood,
  '丙': AppColors.fire,
  '丁': AppColors.fire,
  '戊': AppColors.earth,
  '己': AppColors.earth,
  '庚': AppColors.metal,
  '辛': AppColors.metal,
  '壬': AppColors.water,
  '癸': AppColors.water,
  // ─── 지지 ───
  '子': AppColors.water,
  '丑': AppColors.earth,
  '寅': AppColors.wood,
  '卯': AppColors.wood,
  '辰': AppColors.earth,
  '巳': AppColors.fire,
  '午': AppColors.fire,
  '未': AppColors.earth,
  '申': AppColors.metal,
  '酉': AppColors.metal,
  '戌': AppColors.earth,
  '亥': AppColors.water,
};
