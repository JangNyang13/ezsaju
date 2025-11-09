import 'package:flutter/material.dart';
import '../../models/calendar_day.dart';
import '../../constants/app_colors.dart';
import '../../models/stem_branch.dart';

class WeeklyCalendarView extends StatefulWidget {
  final List<CalendarDay> manse;
  const WeeklyCalendarView({super.key, required this.manse});

  @override
  State<WeeklyCalendarView> createState() => _WeeklyCalendarViewState();
}

class _WeeklyCalendarViewState extends State<WeeklyCalendarView> {
  final DateTime _focusedDate = DateTime.now();

  List<CalendarDay> _getCurrentWeekDays() {
    // 이번 주 월요일 (지역 시간대 보정)
    final monday = DateTime(_focusedDate.year, _focusedDate.month, _focusedDate.day)
        .subtract(Duration(days: _focusedDate.weekday - 1));

    final sunday = monday.add(const Duration(days: 6));

    return widget.manse.where((d) {
      final date = DateTime(d.solarYear, d.solarMonth, d.solarDay);
      return !date.isBefore(monday) && !date.isAfter(sunday);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final days = _getCurrentWeekDays();
    const weekdayNames = ['월', '화', '수', '목', '금', '토', '일'];
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 🔹 상단 주 정보
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${_focusedDate.year}년 ${_focusedDate.month}월 주간',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const Divider(height: 1),

        // 📅 주간 리스트
        Expanded(
          child: ListView.builder(
            itemCount: days.length,
            itemBuilder: (context, i) {
              final day = days[i];
              final weekdayIndex =
                  DateTime(day.solarYear, day.solarMonth, day.solarDay).weekday - 1;
              final weekday = weekdayNames[weekdayIndex];

              final gan = day.hdGanJee.characters.first;
              final ji = day.hdGanJee.characters.last;

              // 오행 색상
              final ganElement = heavenlyStems
                  .firstWhere((e) => e.name == gan,
                  orElse: () =>
                  const StemBranch(name: '', element: '토', yinYang: '양'))
                  .element;
              final jiElement = earthlyBranches
                  .firstWhere((e) => e.name == ji,
                  orElse: () =>
                  const StemBranch(name: '', element: '토', yinYang: '양'))
                  .element;

              // ✅ 오늘 날짜 비교
              final isToday = day.solarYear == today.year &&
                  day.solarMonth == today.month &&
                  day.solarDay == today.day;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: isToday
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null, // ✅ 오늘이면 테두리 표시
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(1, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 📆 요일 + 날짜
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$weekday요일',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: weekday == '토'
                                ? Colors.blue
                                : weekday == '일'
                                ? Colors.red
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.solarMonth}.${day.solarDay}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),

                    // 🌈 간지
                    Row(
                      children: [
                        Text(
                          gan,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.elementColor(ganElement),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          ji,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.elementColor(jiElement),
                          ),
                        ),
                      ],
                    ),

                    // 🌙 음력 / 절기
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${day.isLeapMonth ? "윤" : "음"}${day.lunarMonth}.${day.lunarDay}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        if (day.termName != null)
                          Text(
                            day.termName!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.fire,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
