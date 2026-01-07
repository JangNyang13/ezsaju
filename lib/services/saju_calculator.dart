//lib/services/saju_calculator.dart
import '../models/calendar_day.dart';
import '../models/saju_data.dart';

class SajuCalculator {
  final List<CalendarDay> manse;
  SajuCalculator(this.manse);

  SajuData calculate(DateTime dateTime, {bool isLunar = false, bool isLeapMonth = false}) {
    // 23:30 이후면 다음날 데이터를 불러옴
    final isNextDay = (dateTime.hour == 23 && dateTime.minute >= 30);
    final targetDate = isNextDay
        ? dateTime.add(const Duration(days: 1))
        : dateTime;

    final day = manse.firstWhere(
          (d) =>
      d.solarYear == targetDate.year &&
          d.solarMonth == targetDate.month &&
          d.solarDay == targetDate.day,
      orElse: () => throw Exception('해당 날짜의 만세력 데이터를 찾을 수 없습니다.'),
    );

    // 기준 일주의 간지 추출
    final hy = day.hyGanJee;
    final hm = day.hmGanJee;
    final hd = day.hdGanJee;

    final yearStem = hy.substring(0, 1);
    final yearBranch = hy.substring(1, 2);
    final monthStem = hm.substring(0, 1);
    final monthBranch = hm.substring(1, 2);
    final dayStem = hd.substring(0, 1);
    final dayBranch = hd.substring(1, 2);

    // 시주 계산
    final hour = _getHourPillar(dateTime, dayStem, dateTime.minute);
    final hourStem = hour.$1;
    final hourBranch = hour.$2;

    return SajuData(
      yearStem: yearStem,
      yearBranch: yearBranch,
      monthStem: monthStem,
      monthBranch: monthBranch,
      dayStem: dayStem,
      dayBranch: dayBranch,
      hourStem: hourStem,
      hourBranch: hourBranch,
    );
  }

  /// 시주 계산 (23:30 이후 = 다음날 일주)
  (String, String) _getHourPillar(DateTime dateTime, String dayStem, int minute) {
    final hourBranch = _hourBranchFromTime(dateTime.hour, minute);
    final hourStem = _calculateHourStem(dayStem, hourBranch);
    return (hourStem, hourBranch);
  }

  /// 시간 → 지지 변환
  String _hourBranchFromTime(int hour, int minute) {
    const branches = [
      '子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'
    ];

    // 기준: 23:30부터 자시 시작
    int totalMinutes = hour * 60 + minute;
    int startOfZi = 23 * 60 + 30; // 23:30 in minutes

    // 자시 이전(0~23:29)은 하루의 마지막 구간으로 간주
    if (totalMinutes < startOfZi) totalMinutes += 24 * 60;

    // 23:30을 0으로 맞춰서 2시간(120분) 단위로 인덱스 계산
    final branchIndex = ((totalMinutes - startOfZi) ~/ 120) % 12;

    return branches[branchIndex];
  }

  /// 시지 → 시간 계산
  String _calculateHourStem(String dayStem, String hourBranch) {
    const mapping = {
      '甲': '甲', '己': '甲',
      '乙': '丙', '庚': '丙',
      '丙': '戊', '辛': '戊',
      '丁': '庚', '壬': '庚',
      '戊': '壬', '癸': '壬',
    };

    final baseStem = mapping[dayStem] ?? '甲';
    const stems = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'];
    const branches = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];

    final baseIndex = stems.indexOf(baseStem);
    final branchIndex = branches.indexOf(hourBranch);
    return stems[(baseIndex + branchIndex) % 10];
  }
}
