// lib/utils/daeun_calculator.dart
// 대운(大運) 계산 로직 - 개선 버전 (절기 termName 기반 판정 포함)

import '../models/saju_data.dart';

class DaeunInfo {
  final int startAge;
  final List<DaeunPeriod> periods;
  final bool isForward;
  final String? detailInfo;

  const DaeunInfo({
    required this.startAge,
    required this.periods,
    required this.isForward,
    this.detailInfo,
  });
}

class DaeunStartInfo {
  final int startAge;
  final DateTime startDate;
  final String detailInfo;

  const DaeunStartInfo({
    required this.startAge,
    required this.startDate,
    required this.detailInfo,
  });
}

class DaeunPeriod {
  final int startAge;
  final int endAge;
  final String ganzi;
  final String gan;
  final String zhi;
  final DateTime? startDate;
  final DateTime? endDate;

  const DaeunPeriod({
    required this.startAge,
    required this.endAge,
    required this.ganzi,
    required this.gan,
    required this.zhi,
    this.startDate,
    this.endDate,
  });
}

class SolarTerm {
  final String name;
  final DateTime dateTime;

  const SolarTerm({
    required this.name,
    required this.dateTime,
  });
}

class DaeunCalculator {
  static const List<String> gans = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  static const List<String> zhis = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
  static const List<String> yangGans = ['甲', '丙', '戊', '庚', '壬'];
  static const List<String> yinGans = ['乙', '丁', '己', '辛', '癸'];
  static const List<String> ripJeolTerms = [
    '입춘','경칩','청명','입하','망종','소서','입추','백로','한로','입동','대설','소한'
  ];

  static DaeunInfo calculate(SajuData saju, DateTime birthDate, bool isMale, Map<String, Map<String, dynamic>> manseData) {
    final isForward = _isForwardDirection(isMale, saju.yearGan);
    final daeunSu = _calculateDaeunSu(birthDate, isForward, manseData);
    final periods = _generateDaeunPeriods(saju.month, isForward, daeunSu);
    return DaeunInfo(startAge: daeunSu, periods: periods, isForward: isForward);
  }

  static bool _isForwardDirection(bool isMale, String yearGan) {
    final isYangGan = yangGans.contains(yearGan);
    return isMale ? isYangGan : !isYangGan;
  }

  static int _calculateDaeunSu(DateTime birthDate, bool isForward, Map<String, Map<String, dynamic>> manseData) {
    if (isForward) {
      final next = _findNextRipJeol(birthDate, manseData);
      if (next == null) return 1;
      final days = next.difference(birthDate).inDays;
      return (days / 3.0).round().clamp(1, 100);
    } else {
      final prev = _findPreviousRipJeol(birthDate, manseData);
      if (prev == null) return 1;
      final days = birthDate.difference(prev).inDays;
      return (days / 3.0).round().clamp(1, 100);
    }
  }

  static DateTime? _findNextRipJeol(DateTime birthDate, Map<String, Map<String, dynamic>> manseData) {
    DateTime? next;
    for (final entry in manseData.entries) {
      final data = entry.value;
      final tStr = data['cd_terms_time']?.toString();
      final name = data['term_name']?.toString();
      if (tStr == null || tStr.length != 12) continue;
      try {
        final d = DateTime(
          int.parse(tStr.substring(0, 4)),
          int.parse(tStr.substring(4, 6)),
          int.parse(tStr.substring(6, 8)),
          int.parse(tStr.substring(8, 10)),
          int.parse(tStr.substring(10, 12)),
        );
        if (d.isAfter(birthDate) && _isRipJeolDate(d, termName: name)) {
          if (next == null || d.isBefore(next)) next = d;
        }
      } catch (_) {}
    }
    return next;
  }

  static DateTime? _findPreviousRipJeol(DateTime birthDate, Map<String, Map<String, dynamic>> manseData) {
    DateTime? prev;
    for (final entry in manseData.entries) {
      final data = entry.value;
      final tStr = data['cd_terms_time']?.toString();
      final name = data['term_name']?.toString();
      if (tStr == null || tStr.length != 12) continue;
      try {
        final d = DateTime(
          int.parse(tStr.substring(0, 4)),
          int.parse(tStr.substring(4, 6)),
          int.parse(tStr.substring(6, 8)),
          int.parse(tStr.substring(8, 10)),
          int.parse(tStr.substring(10, 12)),
        );
        if (d.isBefore(birthDate) && _isRipJeolDate(d, termName: name)) {
          if (prev == null || d.isAfter(prev)) prev = d;
        }
      } catch (_) {}
    }
    return prev;
  }

  static bool _isRipJeolDate(DateTime date, {String? termName}) {
    if (termName != null) return ripJeolTerms.any((r) => termName.contains(r));
    final m = date.month, d = date.day;
    switch (m) {
      case 2: return d >= 3 && d <= 6;
      case 3: return d >= 4 && d <= 7;
      case 4: return d >= 4 && d <= 7;
      case 5: return d >= 4 && d <= 8;
      case 6: return d >= 4 && d <= 8;
      case 7: return d >= 6 && d <= 9;
      case 8: return d >= 6 && d <= 9;
      case 9: return d >= 6 && d <= 9;
      case 10: return d >= 7 && d <= 10;
      case 11: return d >= 6 && d <= 9;
      case 12: return d >= 6 && d <= 9;
      case 1: return d >= 4 && d <= 7;
      default: return false;
    }
  }

  static List<DaeunPeriod> _generateDaeunPeriods(String monthGanzi, bool isForward, int startAge) {
    final ganIndex = gans.indexOf(monthGanzi.substring(0, 1));
    final zhiIndex = zhis.indexOf(monthGanzi.substring(1));
    final List<DaeunPeriod> list = [];
    for (int i = 0; i < 8; i++) {
      final sAge = startAge + (i * 10);
      final eAge = sAge + 9;
      final gIdx = isForward ? (ganIndex + i + 1) % 10 : (ganIndex - i - 1 + 10) % 10;
      final zIdx = isForward ? (zhiIndex + i + 1) % 12 : (zhiIndex - i - 1 + 12) % 12;
      final gan = gans[gIdx];
      final zhi = zhis[zIdx];
      list.add(DaeunPeriod(startAge: sAge, endAge: eAge, ganzi: '$gan$zhi', gan: gan, zhi: zhi));
    }
    return list;
  }

  static DaeunPeriod? getDaeunAtAge(DaeunInfo info, int age) {
    try {
      return info.periods.firstWhere(
            (p) => age >= p.startAge && age <= p.endAge,
      );
    } catch (_) {
      return null;
    }
  }

  static int getCurrentAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) age--;
    return age + 1;
  }
}
