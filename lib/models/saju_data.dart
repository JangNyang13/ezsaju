//lib/models/saju_data.dart
class SajuData {
  final String year;
  final String month;
  final String day;
  final String hour;

  const SajuData({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
  });
}
/// ─────────────────────────────────────────
///  천간‧지지 1글자씩 쉽게 꺼내 쓰도록 확장
extension SajuSplit on SajuData {
  String get yearGan  => year.substring(0, 1);
  String get yearZhi  => year.substring(1);
  String get monthGan => month.substring(0, 1);
  String get monthZhi => month.substring(1);
  String get dayGan   => day.substring(0, 1);
  String get dayZhi   => day.substring(1);
  String get hourGan  => hour.substring(0, 1);
  String get hourZhi  => hour.substring(1);
}