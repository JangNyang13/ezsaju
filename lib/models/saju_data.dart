// lib/models/saju_data.dart
import '../utils/elemental_relations.dart';

class SajuData {
  final String year;   // 예: '甲子'
  final String month;  // 예: '乙丑'
  final String day;    // 예: '丙寅'
  final String? hour;  // ✅ '丁卯' 또는 null(시간 모름)

  const SajuData({
    required this.year,
    required this.month,
    required this.day,
    this.hour, // ✅
  });

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'day': day,
    if (hour != null) 'hour': hour, // ✅ 없으면 저장 안 함
  };

  factory SajuData.fromJson(Map<String, dynamic> j) => SajuData(
    year:  j['year']  as String,
    month: j['month'] as String,
    day:   j['day']   as String,
    hour:  j['hour']  as String?, // ✅
  );

  /// 오행 리스트(천간 기준). 시주가 없으면 3개만.
  List<String> get elements {
    final out = <String>[
      stemToElement[yearGan]  ?? '-',
      stemToElement[monthGan] ?? '-',
      stemToElement[dayGan]   ?? '-',
    ];
    if (hasHour) out.add(stemToElement[hourGan] ?? '-');
    return out;
  }
}

extension SajuSplit on SajuData {
  String get yearGan  => year.substring(0, 1);
  String get yearZhi  => year.substring(1);
  String get monthGan => month.substring(0, 1);
  String get monthZhi => month.substring(1);
  String get dayGan   => day.substring(0, 1);
  String get dayZhi   => day.substring(1);

  bool   get hasHour  => hour != null && hour!.length >= 2;
  String get hourGan  => hasHour ? hour!.substring(0, 1) : '';
  String get hourZhi  => hasHour ? hour!.substring(1)     : '';
}
