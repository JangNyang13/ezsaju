import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/calendar_day.dart';

// lib/services/manse_loader.dart
class ManseLoader {
  // 24절기 이름 목록 (고정 순서)
  static const List<String> _solarTerms = [
    '소한', '대한', '입춘', '우수', '경칩', '춘분',
    '청명', '곡우', '입하', '소만', '망종', '하지',
    '소서', '대서', '입추', '처서', '백로', '추분',
    '한로', '상강', '입동', '소설', '대설', '동지',
  ];

  /// 캐시용 변수
  static List<CalendarDay>? cachedData;

  /// 데이터 로드 함수 (캐싱 지원)
  static Future<List<CalendarDay>> load() async {
    // 이미 로드된 데이터 있으면 그대로 반환
    if (cachedData != null) return cachedData!;

    final jsonString = await rootBundle.loadString('assets/data/manse_1900_2100.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    final List<CalendarDay> days = [];
    int termIndex = 0; // 절기 순서 카운터

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

    // 캐싱 저장
    cachedData = days;
    return days;
  }
}
