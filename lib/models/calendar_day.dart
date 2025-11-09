class CalendarDay {
  // 🌞 양력 (Solar)
  final int solarYear;
  final int solarMonth;
  final int solarDay;
  // 🌙 음력 (Lunar)
  final int lunarYear;
  final int lunarMonth;
  final int lunarDay;
  // 🔢 천간지지
  final String hyGanJee; // 연간지 (cd_hyganjee)
  final String hmGanJee; // 월간지 (cd_hmganjee)
  final String hdGanJee; // 일간지 (cd_hdganjee)
  // 🌸 절기 (입절 시간)
  final String? termsTime;
  final String? termName;  // 🔹 절기 이름
  // 🈯 윤달 여부
  final bool isLeapMonth;

  // 🚫 공휴일 (0: 평일, 1: 휴일)
  final bool isHoliday;

  const CalendarDay({
    required this.solarYear,
    required this.solarMonth,
    required this.solarDay,
    required this.lunarYear,
    required this.lunarMonth,
    required this.lunarDay,
    required this.hyGanJee,
    required this.hmGanJee,
    required this.hdGanJee,
    this.termName,
    this.termsTime,
    this.isLeapMonth = false,
    this.isHoliday = false,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      solarYear: json['cd_sy'] as int,
      solarMonth: int.parse(json['cd_sm']),
      solarDay: int.parse(json['cd_sd']),
      lunarYear: json['cd_ly'] as int,
      lunarMonth: int.parse(json['cd_lm']),
      lunarDay: int.parse(json['cd_ld']),
      hyGanJee: json['cd_hyganjee'] as String,
      hmGanJee: json['cd_hmganjee'] as String,
      hdGanJee: json['cd_hdganjee'] as String,
      termsTime: json['cd_terms_time'] as String?,
      isLeapMonth: json['cd_leap_month'] == 1,
      isHoliday: json['holiday'] == 1,
    );
  }

  CalendarDay copyWith({
    String? termName,
  }) {
    return CalendarDay(
      solarYear: solarYear,
      solarMonth: solarMonth,
      solarDay: solarDay,
      lunarYear: lunarYear,
      lunarMonth: lunarMonth,
      lunarDay: lunarDay,
      hyGanJee: hyGanJee,
      hmGanJee: hmGanJee,
      hdGanJee: hdGanJee,
      termName: termName ?? this.termName,
      termsTime: termsTime,
      isLeapMonth: isLeapMonth,
      isHoliday: isHoliday,
    );
  }
}
