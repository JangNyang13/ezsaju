// lib/services/saju_calculator.dart

import '../models/saju_data.dart';

/// SajuCalculator
/// -------------------------------
/// - fromDateTime: DateTime → SajuData (연‧월‧일‧시주)
/// - 시지 블록은 한국식 23:00 자시 기준 2시간 블럭으로 변경
///
class SajuCalculator {
  static SajuData fromDateTime(
      DateTime dt, Map<String, Map<String, dynamic>> manse) {
    final key =
        '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}';
    final row = manse[key];
    if (row == null) {
      throw Exception('만세력에 날짜($key)가 존재하지 않습니다');
    }

    final year = row['cd_hyganjee'] as String;
    final month = row['cd_hmganjee'] as String;
    final day = row['cd_hdganjee'] as String;
    final hour = _calcHourGanji(day, dt);

    return SajuData(year: year, month: month, day: day, hour: hour);
  }

  /// 시주 계산 (천간‧지지)
  /// -----------------------------------------------------------
  /// 1. 시지: 23:00~01:00 → 子, 이후 120분마다 순환 (丑→寅→…→亥)
  /// 2. 시간: 일간(日干)에 따른 자시 헤드 천간에서 12지지 순환
  static String _calcHourGanji(String dayGanji, DateTime dt) {
    final zhi = _hourZhiFromDateTime(dt);
    final gan = _hourGanFromDayGan(dayGanji[0], zhi);
    return '$gan$zhi';
  }

  /// 시지(地支) 계산 – 분단위까지 정확 (23:00 기준)
  static String _hourZhiFromDateTime(DateTime dt) {
    final totalMin = dt.hour * 60 + dt.minute;

    // 각 시지 블록의 시작(분)과 끝(분) – 끝은 exclusive
    // 23:00(1380) ~ 01:00(60) 자시, 이후 120분 단위
    const blocks = [
      [1410, 90],   // 子 (23:30 ~ 01:30)
      [90, 210],    // 丑 (01:30 ~ 03:30)
      [210, 330],   // 寅
      [330, 450],   // 卯
      [450, 570],   // 辰
      [570, 690],   // 巳
      [690, 810],   // 午
      [810, 930],   // 未
      [930, 1050],  // 申
      [1050, 1170], // 酉
      [1170, 1290], // 戌
      [1290, 1410], // 亥
    ];
    const zhiList = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

    for (var i = 0; i < blocks.length; i++) {
      final start = blocks[i][0];
      final end = blocks[i][1];
      if (start < end) {
        if (totalMin >= start && totalMin < end) return zhiList[i];
      } else {
        if (totalMin >= start || totalMin < end) return zhiList[i];
      }
    }
    return '子';
  }

  /// 시간(天干) 계산 – 일간 기준 헤드 간지 → 12지지 순환
  static String _hourGanFromDayGan(String dayGan, String hourZhi) {
    const headMap = {
      '甲': '甲', '己': '甲',
      '乙': '丙', '庚': '丙',
      '丙': '戊', '辛': '戊',
      '丁': '庚', '壬': '庚',
      '戊': '壬', '癸': '壬',
    };
    final headGan = headMap[dayGan] ?? '甲';

    const ganSeq = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    const zhiSeq = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

    final headIdx = ganSeq.indexOf(headGan);
    final zhiIdx = zhiSeq.indexOf(hourZhi);
    final ganIdx = (headIdx + zhiIdx) % 10;
    return ganSeq[ganIdx];
  }
}
