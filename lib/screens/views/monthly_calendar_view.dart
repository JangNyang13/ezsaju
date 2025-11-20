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
    // 📌 화면 스케일러
    final sw = MediaQuery.of(context).size.width;
    final scale = sw / 390;
    final tScale = MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2);



    final days = widget.manse
        .where((d) =>
    d.solarYear == _focusedMonth.year &&
        d.solarMonth == _focusedMonth.month)
        .toList();

    final prevMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    final nextMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);

    final prevDays = widget.manse
        .where((d) => d.solarYear == prevMonth.year && d.solarMonth == prevMonth.month)
        .toList();
    final nextDays = widget.manse
        .where((d) => d.solarYear == nextMonth.year && d.solarMonth == nextMonth.month)
        .toList();

    final firstWeekday =
        (DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday + 6) % 7;

    List<_CalendarCell> displayDays = [];

    // 앞쪽 (이전 달)
    for (int i = 0; i < firstWeekday; i++) {
      final prev = prevDays[prevDays.length - firstWeekday + i];
      displayDays.add(_CalendarCell(prev, true));
    }

    // 이번 달
    for (final d in days) {
      displayDays.add(_CalendarCell(d, false));
    }

    // 뒤쪽 (다음 달)
    int nextIndex = 0;
    while (displayDays.length % 7 != 0) {
      displayDays.add(_CalendarCell(nextDays[nextIndex], true));
      nextIndex++;
    }

    // 마지막 줄이 전부 회색이면 제거
    while (displayDays.length >= 7) {
      final lastRow = displayDays.sublist(displayDays.length - 7);
      if (lastRow.every((e) => e.isDimmed)) {
        displayDays.removeRange(displayDays.length - 7, displayDays.length);
      } else {
        break;
      }
    }

    final weekCount = (displayDays.length / 7).ceil();

    return Column(
      children: [
        _buildMonthHeader(scale, tScale),
        _buildWeekHeader(scale, tScale),
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
                      orElse: () => const StemBranch(
                          name: '', element: '토', yinYang: '양'))
                      .element;
                  final jiElement = earthlyBranches
                      .firstWhere((e) => e.name == ji,
                      orElse: () => const StemBranch(
                          name: '', element: '토', yinYang: '양'))
                      .element;

                  final isToday =
                      day.solarYear == DateTime.now().year &&
                          day.solarMonth == DateTime.now().month &&
                          day.solarDay == DateTime.now().day;

                  return GestureDetector(
                    onTap: () => _showDayInfo(context, day, scale, tScale),
                    child: Padding(
                      padding: EdgeInsets.all(4 * scale),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isToday ? AppColors.secondary : Colors.transparent,
                          borderRadius: BorderRadius.circular(6 * scale),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2 * scale),
                        child: Column(
                          children: [
                            // 양력 날짜
                            Text(
                              '${day.solarDay}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14 * scale * tScale,
                                color: dim
                                    ? Colors.grey.withValues(alpha: 0.4)
                                    : Colors.black,
                              ),
                            ),

                            // 간지
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: gan,
                                    style: TextStyle(
                                      fontSize: 15 * scale,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.elementColor(ganElement),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ji,
                                    style: TextStyle(
                                      fontSize: 15 * scale,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.elementColor(jiElement),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 음력
                            Text(
                              '${day.isLeapMonth ? "윤" : "음"}${day.lunarMonth}.${day.lunarDay}',
                              style: TextStyle(
                                fontSize: 11 * scale,
                                color: day.isLeapMonth
                                    ? AppColors.fire.withValues(alpha: 0.6)
                                    : AppColors.primary.withValues(alpha: 1.0),
                              ),
                            ),

                            // 절기
                            if (day.termName != null)
                              Text(
                                day.termName!,
                                style: TextStyle(
                                  fontSize: 11 * scale,
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

  // 📅 월 선택 헤더
  Widget _buildMonthHeader(double scale, double tScale) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12 * scale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, size: 24 * scale),
            onPressed: () => setState(() {
              _focusedMonth =
                  DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
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
                    height: 300 * scale,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12 * scale),
                          child: Text(
                            '이동할 날짜를 선택하세요',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16 * scale,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                dateTimePickerTextStyle: TextStyle(
                                  fontSize: 20 * scale,
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
                              onDateTimeChanged: (newDate) {
                                tempDate = newDate;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8 * scale),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('취소',
                                    style: TextStyle(fontSize: 14 * scale)),
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
                                child: Text('확인',
                                    style: TextStyle(fontSize: 14 * scale)),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18 * scale * tScale,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(width: 4 * scale),
                Icon(Icons.arrow_drop_down, size: 24 * scale),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, size: 24 * scale),
            onPressed: () => setState(() {
              _focusedMonth =
                  DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
            }),
          ),
        ],
      ),
    );
  }

  // 요일 헤더
  Widget _buildWeekHeader(double scale, double tScale) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((e) {
        final color =
        e == '일' ? Colors.red : e == '토' ? Colors.blue : Colors.black87;
        return Text(
          e,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 13 * scale * tScale,
          ),
        );
      }).toList(),
    );
  }

  // 📅 상세 정보 bottom sheet
  void _showDayInfo(
      BuildContext context, CalendarDay day, double scale, double tScale) {
    final weekdayNames = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdayNames[
    (DateTime(day.solarYear, day.solarMonth, day.solarDay).weekday + 6) % 7];

    final yearGan = day.hyGanJee.characters.first;
    final yearJi = day.hyGanJee.characters.last;
    final monthGan = day.hmGanJee.characters.first;
    final monthJi = day.hmGanJee.characters.last;
    final dayGan = day.hdGanJee.characters.first;
    final dayJi = day.hdGanJee.characters.last;

    final yearGanElem = heavenlyStems
        .firstWhere((e) => e.name == yearGan,
        orElse: () =>
        const StemBranch(name: '', element: '토', yinYang: '양'))
        .element;
    final yearJiElem = earthlyBranches
        .firstWhere((e) => e.name == yearJi,
        orElse: () =>
        const StemBranch(name: '', element: '토', yinYang: '양'))
        .element;

    final monthGanElem = heavenlyStems
        .firstWhere((e) => e.name == monthGan,
        orElse: () =>
        const StemBranch(name: '', element: '토', yinYang: '양'))
        .element;
    final monthJiElem = earthlyBranches
        .firstWhere((e) => e.name == monthJi,
        orElse: () =>
        const StemBranch(name: '', element: '토', yinYang: '양'))
        .element;

    final dayGanElem = heavenlyStems
        .firstWhere((e) => e.name == dayGan,
        orElse: () =>
        const StemBranch(name: '', element: '토', yinYang: '양'))
        .element;
    final dayJiElem = earthlyBranches
        .firstWhere((e) => e.name == dayJi,
        orElse: () =>
        const StemBranch(name: '', element: '토', yinYang: '양'))
        .element;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(24 * scale),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${day.solarYear}년 ${day.solarMonth}월 ${day.solarDay}일 ($weekday)',
                style: TextStyle(
                  fontSize: 22 * scale * tScale,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12 * scale),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 32 * scale,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
                    TextSpan(text: '年  '),
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
                    TextSpan(text: '月  '),
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
                    TextSpan(text: '日'),
                  ],
                ),
              ),

              SizedBox(height: 16 * scale),

              Text(
                '${day.isLeapMonth ? "윤" : "음"}${day.lunarMonth}.${day.lunarDay}'
                    '${day.termName != null ? " • ${day.termName!}" : ""}',
                style: TextStyle(
                  fontSize: 18 * scale,
                  color: Colors.black54,
                ),
              ),

              SizedBox(height: 24 * scale),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.fire,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 36 * scale,
                    vertical: 14 * scale,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10 * scale),
                  ),
                ),
                child: Text('닫기', style: TextStyle(fontSize: 18 * scale)),
              ),
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
