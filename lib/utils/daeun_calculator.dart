// 대운(大運) 계산 - 단순/직관 버전
// 규칙
// 1) 순행: (남+양간) 또는 (여+음간)
// 2) 역행: 그 외
// 3) 순행 → (다음 절기 - 출생일).inDays / 3  (반올림)
//    역행 → (출생일 - 이전 절기).inDays / 3  (반올림)
// 4) 절기 판단: 월초 2~12일 사이의 cd_terms_time 만 허용(소한~대설 12개 구간)

import '../models/saju_data.dart';

class DaeunInfo {
  final int startAge;
  final List<DaeunPeriod> periods;
  final bool isForward;
  const DaeunInfo({
    required this.startAge,
    required this.periods,
    required this.isForward,
  });
}

class DaeunPeriod {
  final int startAge;
  final int endAge;
  final String ganzi;
  final String gan;
  final String zhi;
  const DaeunPeriod({
    required this.startAge,
    required this.endAge,
    required this.ganzi,
    required this.gan,
    required this.zhi,
  });
}

class DaeunCalculator {
  static const _gans = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'];
  static const _zhis = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];
  static const _yangGans = ['甲','丙','戊','庚','壬'];

  /// manseMap: yyyyMMdd -> { cd_terms_time, cd_hmganjee ... }
  static DaeunInfo calculate(
      SajuData saju,
      DateTime birth, // 사용자가 말한 그대로의 시간
      bool isMale,
      Map<String, Map<String, dynamic>> manseMap,
      ) {
    final isForward = _isForward(isMale, saju.year.substring(0, 1));

    final nextTerm = _findNextTerm(birth, manseMap);
    final prevTerm = _findPrevTerm(birth, manseMap);

    final int daeunSu;
    if (isForward) {
      final days = nextTerm == null ? 0 : nextTerm.difference(birth).inDays;
      daeunSu = (days / 3).round().clamp(1, 100);
    } else {
      final days = prevTerm == null ? 0 : birth.difference(prevTerm).inDays;
      daeunSu = (days / 3).round().clamp(1, 100);
    }

    final periods = _generatePeriods(
      saju.month, // 예: '乙丑'
      isForward,
      daeunSu,
    );

    return DaeunInfo(startAge: daeunSu, periods: periods, isForward: isForward);
  }

  static bool _isForward(bool isMale, String yearGan) {
    final isYang = _yangGans.contains(yearGan);
    return isMale ? isYang : !isYang;
  }

  // cd_terms_time: 'YYYYMMDDHHmm' → DateTime
  static DateTime? _parseTerms(dynamic raw) {
    if (raw == null) return null;
    final s = raw.toString().replaceAll(RegExp(r'\D'), '');
    if (s.length < 12) return null;
    final y = int.parse(s.substring(0, 4));
    final m = int.parse(s.substring(4, 6));
    final d = int.parse(s.substring(6, 8));
    final hh = int.parse(s.substring(8, 10));
    final mm = int.parse(s.substring(10, 12));
    return DateTime(y, m, d, hh, mm); // 타임존 신경 X: 숫자 그대로 비교
  }

  // 월초 2~12일만 절기로 인정 (소한~대설 구간)
  static bool _isAcceptedTermDate(DateTime dt) => dt.day >= 2 && dt.day <= 12;

  static DateTime? _findNextTerm(
      DateTime birth,
      Map<String, Map<String, dynamic>> manse,
      ) {
    DateTime? best;
    for (final rec in manse.values) {
      final dt = _parseTerms(rec['cd_terms_time']);
      if (dt == null || !_isAcceptedTermDate(dt)) continue;
      if (dt.isAfter(birth) && (best == null || dt.isBefore(best))) best = dt;
    }
    return best;
  }

  static DateTime? _findPrevTerm(
      DateTime birth,
      Map<String, Map<String, dynamic>> manse,
      ) {
    DateTime? best;
    for (final rec in manse.values) {
      final dt = _parseTerms(rec['cd_terms_time']);
      if (dt == null || !_isAcceptedTermDate(dt)) continue;
      if (dt.isBefore(birth) && (best == null || dt.isAfter(best))) best = dt;
    }
    return best;
  }

  static List<DaeunPeriod> _generatePeriods(
      String monthGanzi,
      bool isForward,
      int startAge,
      ) {
    final gi = _gans.indexOf(monthGanzi.substring(0, 1));
    final zi = _zhis.indexOf(monthGanzi.substring(1));
    final out = <DaeunPeriod>[];
    for (int i = 0; i < 8; i++) {
      final sAge = startAge + i * 10;
      final eAge = sAge + 9;
      final gIdx = isForward ? (gi + i + 1) % 10 : (gi - i - 1 + 10) % 10;
      final zIdx = isForward ? (zi + i + 1) % 12 : (zi - i - 1 + 12) % 12;
      final gan = _gans[gIdx], zhi = _zhis[zIdx];
      out.add(DaeunPeriod(
        startAge: sAge,
        endAge: eAge,
        ganzi: '$gan$zhi',
        gan: gan,
        zhi: zhi,
      ));
    }
    return out;
  }

  // 편의 함수들 (네 UI 그대로 사용)
  static int getCurrentAge(DateTime birth) {
    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age + 1; // 한국식
  }

  static DaeunPeriod? getDaeunAtAge(DaeunInfo info, int age) {
    for (final p in info.periods) {
      if (age >= p.startAge && age <= p.endAge) return p;
    }
    return null;
  }
}
