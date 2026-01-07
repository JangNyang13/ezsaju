//lib/models/saju_data.dart
class SajuData {
  final String yearStem;
  final String yearBranch;
  final String monthStem;
  final String monthBranch;
  final String dayStem;
  final String dayBranch;
  final String hourStem;
  final String hourBranch;

  const SajuData({
    required this.yearStem,
    required this.yearBranch,
    required this.monthStem,
    required this.monthBranch,
    required this.dayStem,
    required this.dayBranch,
    required this.hourStem,
    required this.hourBranch,
  });

  // getter (기존처럼 간지 조합)
  String get yearPillar => '$yearStem$yearBranch';
  String get monthPillar => '$monthStem$monthBranch';
  String get dayPillar => '$dayStem$dayBranch';
  String get hourPillar => '$hourStem$hourBranch';

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'yearStem': yearStem,
      'yearBranch': yearBranch,
      'monthStem': monthStem,
      'monthBranch': monthBranch,
      'dayStem': dayStem,
      'dayBranch': dayBranch,
      'hourStem': hourStem,
      'hourBranch': hourBranch,
    };
  }

  // JSON 역직렬화
  factory SajuData.fromJson(Map<String, dynamic> json) {
    return SajuData(
      yearStem: json['yearStem'] as String,
      yearBranch: json['yearBranch'] as String,
      monthStem: json['monthStem'] as String,
      monthBranch: json['monthBranch'] as String,
      dayStem: json['dayStem'] as String,
      dayBranch: json['dayBranch'] as String,
      hourStem: json['hourStem'] as String,
      hourBranch: json['hourBranch'] as String,
    );
  }
}
