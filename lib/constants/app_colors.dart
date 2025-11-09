import 'package:flutter/material.dart';

/// EZ 사주 앱의 전역 색상 시스템
/// 오행(목·화·토·금·수) + 음양 컬러 정의
class AppColors {
  // ─────────────────────────────
  // 오행(五行)
  // ─────────────────────────────
  static const wood  = Color(0xFFa0cbad); // 목
  static const fire  = Color(0xFFd53302); // 화
  static const earth = Color(0xFFfdc360); // 토
  static const metal = Color(0xFFa3aaad); // 금
  static const water = Color(0xFF2e2f3a); // 수

  // 음양(陰陽)
  static const yin  = Color(0xFF2B2B2B);   // 어두운 색 (陰)
  static const yang = Color(0xFFF6F3E7);   // 밝은 색 (陽)

  // UI 공통 색상
  static const primary     = Color(0xFF424242);
  static const secondary   = Color(0xFFcccccc);
  static const surface     = Color(0xFFfaf9f6);
  static const background  = Color(0xFFfaf9f6);
  static const card        = Color(0xFFfaf9f6);
  static const border      = Color(0xFFDAD5C2);
  static const textPrimary = Color(0xFF424242);
  static const textSecondary = Color(0xFF777777);
  static const error       = Color(0xFFB00020);

  // ─────────────────────────────
  // 🎨 오행 색상 매핑
  // ─────────────────────────────
  static Color elementColor(String element) {
    switch (element) {
      case '木':
      case '목': return wood;
      case '火':
      case '화': return fire;
      case '土':
      case '토': return earth;
      case '金':
      case '금': return metal;
      case '水':
      case '수': return water;
      default: return textSecondary;
    }
  }

  // ─────────────────────────────
  // ✅ 간지 → 오행 → 색상 자동 변환
  // ─────────────────────────────
  static Color fromGanji(String ganOrBranch) {
    const ganMap = {
      '甲': '목', '乙': '목', '丙': '화', '丁': '화',
      '戊': '토', '己': '토', '庚': '금', '辛': '금',
      '壬': '수', '癸': '수',
    };
    const branchMap = {
      '子': '수', '丑': '토', '寅': '목', '卯': '목',
      '辰': '토', '巳': '화', '午': '화', '未': '토',
      '申': '금', '酉': '금', '戌': '토', '亥': '수',
    };

    final element = ganMap[ganOrBranch] ?? branchMap[ganOrBranch] ?? '목';
    return elementColor(element);
  }
}
