// lib/models/today_fortune.dart
enum FortuneLevel { veryBad, bad, neutral, good, veryGood }

class TodayFortune {
  final DateTime date;
  final List<int> hourly;   // 길이 12, 각 -2..+2
  final double average;     // 일 평균 점수
  final FortuneLevel level; // 종합 레벨

  const TodayFortune({
    required this.date,
    required this.hourly,
    required this.average,
    required this.level,
  });
}
