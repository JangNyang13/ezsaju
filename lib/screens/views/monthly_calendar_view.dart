import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/calendar_day.dart';
import '../../models/stem_branch.dart';
import '../../constants/app_colors.dart';

class MonthlyCalendarView extends StatefulWidget {
  final List<CalendarDay> manse;

  const MonthlyCalendarView({super.key, required this.manse});

  @override
  State<MonthlyCalendarView> createState() => _MonthlyCalendarViewState();
}

class _MonthlyCalendarViewState extends State<MonthlyCalendarView> {
  DateTime _focusedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final days = widget.manse
        .where((d) =>
    d.solarYear == _focusedMonth.year &&
        d.solarMonth == _focusedMonth.month)
        .toList();

    // 이전·다음 달
    final prevMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    final nextMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    final prevDays = widget.manse
        .where((d) => d.solarYear == prevMonth.year && d.solarMonth == prevMonth.month)
        .toList();
    final nextDays = widget.manse
        .where((d) => d.solarYear == nextMonth.year && d.solarMonth == nextMonth.month)
        .toList();

    // 월요일 시작으로 조정
    final firstWeekday = (DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday + 6) % 7;

    List<_CalendarCell> displayDays = [];

    // 앞쪽 채우기 (이전달)
    for (int i = 0; i < firstWeekday; i++) {
      final prev = prevDays[prevDays.length - firstWeekday + i];
      displayDays.add(_CalendarCell(prev, true));
    }

    // 이번 달
    for (final d in days) {
      displayDays.add(_CalendarCell(d, false));
    }

    // 뒤쪽 채우기 (다음달)
    int nextIndex = 0;
    while (displayDays.length % 7 != 0) {
      displayDays.add(_CalendarCell(nextDays[nextIndex], true));
      nextIndex++;
    }

    // 마지막 줄이 전부 회색이면 제거
    while (displayDays.length >= 7) {
      final lastRow = displayDays.sublist(displayDays.length - 7);
      final allDimmed = lastRow.every((e) => e.isDimmed);
      if (allDimmed) {
        displayDays.removeRange(displayDays.length - 7, displayDays.length);
      } else {
        break;
      }
    }

    // 행 계산
    final weekCount = (displayDays.length / 7).ceil();

    return Column(
      children: [
        _buildMonthHeader(),
        _buildWeekHeader(),
        Expanded(
          child: Table(
            children: List.generate(weekCount, (week) {
              return TableRow(
                children: List.generate(7, (i) {
                  final cell = displayDays[week * 7 + i];
                  final day = cell.day;
                  final dim = cell.isDimmed;

                  final gan = day.hdGanJee.characters.first;
                  final ji = day.hdGanJee.characters.last;

                  final ganElement = heavenlyStems
                      .firstWhere((e) => e.name == gan,
                      orElse: () => const StemBranch(name: '', element: '토', yinYang: '양'))
                      .element;

                  final jiElement = earthlyBranches
                      .firstWhere((e) => e.name == ji,
                      orElse: () => const StemBranch(name: '', element: '토', yinYang: '양'))
                      .element;

                  // 오늘 날짜 확인
                  final isToday = day.solarYear == DateTime.now().year &&
                      day.solarMonth == DateTime.now().month &&
                      day.solarDay == DateTime.now().day;

                  return GestureDetector(
                    onTap: () => _showDayInfo(context, day),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isToday
                              ? AppColors.card
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Column(
                          children: [
                            Text( // 양력
                              '${day.solarDay}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: dim
                                    ? Colors.grey.withValues(alpha: 0.4)
                                    : Colors.black,
                              ),
                            ),
                            Text.rich( // 일진 (오행색 적용)
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: gan,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.elementColor(ganElement),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ji,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.elementColor(jiElement),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text( // 음력
                              '${day.isLeapMonth ? "윤" : "음"}${day.lunarMonth}.${day.lunarDay}',
                              style: TextStyle(
                                fontSize: 11,
                                color: day.isLeapMonth
                                    ? AppColors.fire.withValues(alpha: 0.6)
                                    : Colors.grey.withValues(alpha: 1.0),
                              ),
                            ),
                            if (day.termName != null)
                              Text( // 절기
                                day.termName!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.fire,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );

                }),
              );
            }),
          ),
        ),
      ],
    );
  }

  // 📅 상단 월 선택 + 다이얼
  Widget _buildMonthHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() {
              _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
            }),
          ),
          GestureDetector(
            onTap: () async {
              await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  DateTime tempDate = _focusedMonth;

                  return SizedBox(
                    height: 300,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            '이동할 날짜를 선택하세요',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CupertinoTheme(
                            data: const CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                dateTimePickerTextStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.monthYear,
                              initialDateTime: _focusedMonth,
                              minimumDate: DateTime(1900, 1, 1),
                              maximumDate: DateTime(2100, 12, 31),
                              onDateTimeChanged: (DateTime newDate) {
                                tempDate = newDate;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('취소'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.fire,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _focusedMonth =
                                        DateTime(tempDate.year, tempDate.month, 1);
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Row(
              children: [
                Text(
                  '${_focusedMonth.year}년 ${_focusedMonth.month}월',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 24),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() {
              _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
            }),
          ),
        ],
      ),
    );
  }

  // 요일 헤더
  Widget _buildWeekHeader() {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((e) {
        final color = e == '일'
            ? Colors.red
            : e == '토'
            ? Colors.blue
            : Colors.black87;
        return Text(e,
            style: TextStyle(fontWeight: FontWeight.bold, color: color));
      }).toList(),
    );
  }

  // 📅 날짜 클릭 시 상세보기
  void _showDayInfo(BuildContext context, CalendarDay day) {
    final weekdayNames = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdayNames[
    (DateTime(day.solarYear, day.solarMonth, day.solarDay).weekday + 6) % 7];

    // 각 간지 분리
    final yearGan = day.hyGanJee.characters.first;
    final yearJi = day.hyGanJee.characters.last;
    final monthGan = day.hmGanJee.characters.first;
    final monthJi = day.hmGanJee.characters.last;
    final dayGan = day.hdGanJee.characters.first;
    final dayJi = day.hdGanJee.characters.last;

    // 오행 추출
    final yearGanElem = heavenlyStems.firstWhere(
          (e) => e.name == yearGan,
      orElse: () => const StemBranch(name: '', element: '토', yinYang: '양'),
    ).element;
    final yearJiElem = earthlyBranches.firstWhere(
          (e) => e.name == yearJi,
      orElse: () => const StemBranch(name: '', element: '토', yinYang: '양'),
    ).element;

    final monthGanElem = heavenlyStems.firstWhere(
          (e) => e.name == monthGan,
      orElse: () => const StemBranch(name: '', element: '토', yinYang: '양'),
    ).element;
    final monthJiElem = earthlyBranches.firstWhere(
          (e) => e.name == monthJi,
      orElse: () => const StemBranch(name: '', element: '토', yinYang: '양'),
    ).element;

    final dayGanElem = heavenlyStems.firstWhere(
          (e) => e.name == dayGan,
      orElse: () => const StemBranch(name: '', element: '토', yinYang: '양'),
    ).element;
    final dayJiElem = earthlyBranches.firstWhere(
          (e) => e.name == dayJi,
      orElse: () => const StemBranch(name: '', element: '토', yinYang: '양'),
    ).element;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🗓️ 양력 + 요일
              Text(
                '${day.solarYear}년 ${day.solarMonth}월 ${day.solarDay}일 ($weekday)',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 오행색 적용된 간지표시 (크게!)
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: yearGan,
                      style: TextStyle(
                          color: AppColors.elementColor(yearGanElem)),
                    ),
                    TextSpan(
                      text: yearJi,
                      style: TextStyle(
                          color: AppColors.elementColor(yearJiElem)),
                    ),
                    const TextSpan(
                      text: '年  ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextSpan(
                      text: monthGan,
                      style: TextStyle(
                          color: AppColors.elementColor(monthGanElem)),
                    ),
                    TextSpan(
                      text: monthJi,
                      style: TextStyle(
                          color: AppColors.elementColor(monthJiElem)),
                    ),
                    const TextSpan(
                      text: '月  ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextSpan(
                      text: dayGan,
                      style: TextStyle(
                          color: AppColors.elementColor(dayGanElem)),
                    ),
                    TextSpan(
                      text: dayJi,
                      style: TextStyle(
                          color: AppColors.elementColor(dayJiElem)),
                    ),
                    const TextSpan(
                      text: '日',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🌙 음력 + 절기
              Text(
                '${day.isLeapMonth ? "윤" : "음"}${day.lunarMonth}.${day.lunarDay}'
                    '${day.termName != null ? " • ${day.termName!}" : ""}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.fire,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('닫기', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _CalendarCell {
  final CalendarDay day;
  final bool isDimmed;
  _CalendarCell(this.day, this.isDimmed);
}
