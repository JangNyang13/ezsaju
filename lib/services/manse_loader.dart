// lib/services/manse_loader.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/calendar_day.dart';

class ManseLoader {
  static const List<String> _solarTerms = [
    '소한', '대한', '입춘', '우수', '경칩', '춘분',
    '청명', '곡우', '입하', '소만', '망종', '하지',
    '소서', '대서', '입추', '처서', '백로', '추분',
    '한로', '상강', '입동', '소설', '대설', '동지',
  ];

  static List<CalendarDay>? cachedData;

  /// 🔹 만세력 데이터 로드 (캐싱)
  static Future<List<CalendarDay>> load() async {
    if (cachedData != null) return cachedData!;

    final jsonString = await rootBundle.loadString('assets/data/manse_1900_2100.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    final List<CalendarDay> days = [];
    int termIndex = 0;

    for (final e in jsonList) {
      final hasTerm = e['cd_terms_time'] != null && e['cd_terms_time'] != '';
      final termName = hasTerm ? _solarTerms[termIndex % _solarTerms.length] : null;

      days.add(CalendarDay(
        solarYear: e['cd_sy'] as int,
        solarMonth: int.parse(e['cd_sm']),
        solarDay: int.parse(e['cd_sd']),
        lunarYear: e['cd_ly'] as int,
        lunarMonth: int.parse(e['cd_lm']),
        lunarDay: int.parse(e['cd_ld']),
        hyGanJee: e['cd_hyganjee'] as String,
        hmGanJee: e['cd_hmganjee'] as String,
        hdGanJee: e['cd_hdganjee'] as String,
        termName: termName,
        termsTime: e['cd_terms_time'] as String?,
        isLeapMonth: e['cd_leap_month'] == 1,
        isHoliday: e['holiday'] == 1,
      ));

      if (hasTerm) termIndex++;
    }

    cachedData = days;
    return days;
  }

  /// 🔹 음력 → 양력 변환 함수 (윤달 포함)
  static Future<DateTime?> lunarToSolar({
    required int lunarYear,
    required int lunarMonth,
    required int lunarDay,
    bool isLeapMonth = false,
  }) async {
    final data = await load();

    // 윤달 여부 포함해서 정확히 매칭
    final match = data.firstWhere(
          (d) =>
      d.lunarYear == lunarYear &&
          d.lunarMonth == lunarMonth &&
          d.lunarDay == lunarDay &&
          d.isLeapMonth == isLeapMonth,
      orElse: () => CalendarDay(
        solarYear: -1,
        solarMonth: -1,
        solarDay: -1,
        lunarYear: lunarYear,
        lunarMonth: lunarMonth,
        lunarDay: lunarDay,
        isLeapMonth: isLeapMonth,
        hyGanJee: '',
        hmGanJee: '',
        hdGanJee: '',
        isHoliday: false,
      ),
    );

    if (match.solarYear < 0) return null;

    return DateTime(match.solarYear, match.solarMonth, match.solarDay);
  }
}
