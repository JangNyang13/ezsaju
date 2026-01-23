import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// 절기명과 날짜 경과(dayOffset)에 따른 오행 색상 반환
/// - primary: 주요 색 (첫 번째 파도)
/// - secondary: 보조 색 (두 번째 파도)
({Color primary, Color secondary}) getSolarTermColors(String termName, int dayOffset) {
  dayOffset = dayOffset.clamp(0, 30); // 안정화 (최대 30일까지만 계산)

  switch (termName) {
  // ❄️ 겨울~초봄
    case '소한':
      if (dayOffset < 7) return (primary: AppColors.water, secondary: AppColors.water);
      if (dayOffset < 15) return (primary: AppColors.metal, secondary: AppColors.metal);
      return (primary: AppColors.earth, secondary: AppColors.earth);

    case '대한':
      return (primary: AppColors.earth, secondary: AppColors.earth);

  // 🌱 봄
    case '입춘':
      if (dayOffset < 3) return (primary: AppColors.fire, secondary: AppColors.fire);
      return (primary: AppColors.wood, secondary: AppColors.wood);

    case '우수':
    case '경칩':
    case '춘분':
      return (primary: AppColors.wood, secondary: AppColors.wood);

    case '청명':
      if (dayOffset < 10) return (primary: AppColors.wood, secondary: AppColors.wood);
      if (dayOffset < 18) return (primary: AppColors.water, secondary: AppColors.water);
      return (primary: AppColors.wood, secondary: AppColors.wood);

    case '곡우':
      return (primary: AppColors.earth, secondary: AppColors.earth);

  // ☀️ 여름
    case '입하':
    case '소만':
    case '망종':
      return (primary: AppColors.earth, secondary: AppColors.earth);

    case '하지':
      if (dayOffset < 10) return (primary: AppColors.fire, secondary: AppColors.fire);
      return (primary: AppColors.earth, secondary: AppColors.earth);

    case '소서':
      if (dayOffset < 10) return (primary: AppColors.fire, secondary: AppColors.fire);
      if (dayOffset < 13) return (primary: AppColors.wood, secondary: AppColors.wood);
      return (primary: AppColors.fire, secondary: AppColors.fire);

    case '대서':
      return (primary: AppColors.wood, secondary: AppColors.wood);

  // 🍂 가을
    case '입추':
      if (dayOffset < 10) return (primary: AppColors.water, secondary: AppColors.water);
      return (primary: AppColors.metal, secondary: AppColors.metal);

    case '처서':
    case '백로':
    case '추분':
      return (primary: AppColors.metal, secondary: AppColors.metal);

    case '한로':
      if (dayOffset < 7) {
        return (primary: AppColors.metal, secondary: AppColors.metal);
      }
      // 이후 fire + water 이중 물결
      return (primary: AppColors.fire, secondary: AppColors.fire);

    case '상강':
      if (dayOffset < 15) return (primary: AppColors.earth, secondary: AppColors.earth);
      return (primary: AppColors.earth, secondary: AppColors.earth);

  // ❄️ 겨울
    case '입동':
      return (primary: AppColors.water, secondary: AppColors.water);
      //return (primary: AppColors.water, secondary: AppColors.water);

    case '소설':
      if (dayOffset < 7) return (primary: AppColors.water, secondary: AppColors.water);
      return (primary: AppColors.wood, secondary: AppColors.wood);

    case '대설':
    case '동지':
      return (primary: AppColors.water, secondary: AppColors.water);

    default:
      return (primary: AppColors.earth, secondary: AppColors.earth);
  }
}
