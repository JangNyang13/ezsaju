// lib/services/simple_daeun_calculator.dart
import '../models/saju_data.dart';
import '../models/calendar_day.dart';
import '../models/profile_model.dart';

class DaeunPeriod {
  final int startAge;
  final int endAge;
  final String gan;
  final String zhi;
  final String ganzi;

  DaeunPeriod({
    required this.startAge,
    required this.endAge,
    required this.gan,
    required this.zhi,
  }) : ganzi = '$gan$zhi';
}

class YearUn {
  final int year;
  final String gan;
  final String zhi;
  YearUn(this.year, this.gan, this.zhi);
}

class MonthUn {
  final int year;
  final int month;
  final String gan;
  final String zhi;
  MonthUn(this.year, this.month, this.gan, this.zhi);
}

class DaeunInfo {
  final int startAge;
  final bool isForward;
  final List<DaeunPeriod> daeunList;
  final List<YearUn> yearUnList;
  final List<MonthUn> monthUnList;

  DaeunInfo({
    required this.startAge,
    required this.isForward,
    required this.daeunList,
    required this.yearUnList,
    required this.monthUnList,
  });
}

class SimpleDaeunCalculator {
  static Future<DaeunInfo> calculate(
      SajuData saju,
      Profile profile,
      List<CalendarDay> manse,
      ) async {
    final birth = profile.birthDate;
    final yangStems = ['甲','丙','戊','庚','壬'];
    final isYangYear = yangStems.contains(saju.yearStem);
    final isForward =
        (isYangYear && profile.gender == '남') ||
            (!isYangYear && profile.gender == '여');

    // 절기 중 월초 절기만 필터링
    final terms = _filterMainTerms(manse);
    final prevTerm = terms.lastWhere(
          (t) => DateTime(t.solarYear, t.solarMonth, t.solarDay).isBefore(birth),
      orElse: () => terms.first,
    );
    final nextTerm = terms.firstWhere(
          (t) => DateTime(t.solarYear, t.solarMonth, t.solarDay).isAfter(birth),
      orElse: () => terms.last,
    );

    final prevDate = DateTime(prevTerm.solarYear, prevTerm.solarMonth, prevTerm.solarDay);
    final nextDate = DateTime(nextTerm.solarYear, nextTerm.solarMonth, nextTerm.solarDay);

    final dayDiff = isForward
        ? nextDate.difference(birth).inDays
        : birth.difference(prevDate).inDays;

    int daeunValue = dayDiff ~/ 3;
    if (dayDiff % 3 == 2) daeunValue += 1;

    // --- 대운 ---
    final daeunList = List.generate(8, (i) {
      final (g, z) = _shiftGanZhi(
          saju.monthStem, saju.monthBranch, i + 1, isForward);
      return DaeunPeriod(
          startAge: daeunValue + i * 10,
          endAge: daeunValue + (i + 1) * 10 - 1,
          gan: g, zhi: z);
    });

    // --- 세운 ---
    final currentYear = DateTime.now().year;
    final yearUnList = List.generate(10, (i) {
      final y = currentYear - 5 + i;
      final rec = manse.firstWhere((d) => d.solarYear == y,
          orElse: () => manse.first);
      final gz = rec.hyGanJee;
      return YearUn(y, gz.isNotEmpty ? gz[0] : '-', gz.isNotEmpty ? gz[1] : '-');
    });

    // --- 월운 ---
    final monthUnList = List.generate(12, (m) {
      final rec = manse.firstWhere(
              (d) => d.solarYear == currentYear && d.solarMonth == m,
          orElse: () => manse.first);
      final gz = rec.hmGanJee;
      return MonthUn(currentYear, m, gz.isNotEmpty ? gz[0] : '-', gz.isNotEmpty ? gz[1] : '-');
    });

    return DaeunInfo(
      startAge: daeunValue,
      isForward: isForward,
      daeunList: daeunList,
      yearUnList: yearUnList,
      monthUnList: monthUnList,
    );
  }

  static (String,String) _shiftGanZhi(String gan, String zhi, int offset, bool forward) {
    final gList = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'];
    final zList = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];
    int g = gList.indexOf(gan);
    int z = zList.indexOf(zhi);
    if (g < 0 || z < 0) return (gan, zhi);
    int gNew = (forward ? g + offset : g - offset) % 10;
    int zNew = (forward ? z + offset : z - offset) % 12;
    if (gNew < 0) gNew += 10;
    if (zNew < 0) zNew += 12;
    return (gList[gNew], zList[zNew]);
  }

  static List<CalendarDay> _filterMainTerms(List<CalendarDay> list) {
    const mainTerms = [
      '입춘','경칩','청명','입하','망종','소서',
      '입추','백로','한로','입동','대설','소한'
    ];
    return list.where((e) =>
        mainTerms.any((t) => e.termName?.contains(t) ?? false)
    ).toList();
  }
}
