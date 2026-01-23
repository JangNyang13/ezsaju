import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/calendar_day.dart';
import '../models/saju_data.dart';
import '../services/manse_loader.dart';
import '../services/module/daewoon_module/daewoon_calculator.dart';
import '../services/module/daewoon_module/daewoon_model.dart';
import '../widgets/gapja_box.dart';

class DaewoonSection extends StatefulWidget {
  final SajuData saju;
  final DateTime birthDate;
  final bool isMale;

  const DaewoonSection({
    super.key,
    required this.saju,
    required this.birthDate,
    required this.isMale,
  });

  @override
  State<DaewoonSection> createState() => _DaewoonSectionState();
}

class _DaewoonSectionState extends State<DaewoonSection> {
  List<Daewoon>? _daewoon;
  List<CalendarDay>? _manse;
  bool _loading = true;

  int _selectedDaewoonIndex = -1;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final manseData = await ManseLoader.load();
    final list = await DaewoonCalculator.calculate(
      yearStem: widget.saju.yearStem,
      monthStem: widget.saju.monthStem,
      monthBranch: widget.saju.monthBranch,
      birthDate: widget.birthDate,
      isMale: widget.isMale,
    );

    setState(() {
      _manse = manseData;
      _daewoon = list;
      _loading = false;
      final now = DateTime.now().year;
      _selectedDaewoonIndex =
          list.indexWhere((d) => now >= d.startYear && now <= d.endYear);
      if (_selectedDaewoonIndex == -1) _selectedDaewoonIndex = 0;
      _selectedYear = now;
    });
  }

  /// 🔹 세운 목록
  List<Map<String, dynamic>> _getSaewoonList(Daewoon daewoon) {
    final years = List.generate(
      daewoon.endYear - daewoon.startYear + 1,
          (i) => daewoon.startYear + i,
    );

    return years.map((year) {
      final ipchun = _manse!.firstWhere(
            (d) => d.termName == '입춘' && d.solarYear == year,
        orElse: () => _manse!.firstWhere((d) => d.solarYear == year),
      );

      final hy = ipchun.hyGanJee;
      final gan = hy.isNotEmpty ? hy.substring(0, 1) : '?';
      final ji = hy.length > 1 ? hy.substring(1, 2) : '?';

      return {'year': year, 'stem': gan, 'branch': ji};
    }).toList();
  }

  /// 🔹 월운 목록
  List<Map<String, dynamic>> _getMonthList(int year) {
    // ✅ 절입일(월 경계)을 기준으로 월운 구분
    final termDays = _manse!
        .where((d) => d.solarYear == year && d.termName != null)
        .toList();

    // ✅ 다음 절입일 기준으로 한 칸 당겨서 월 계산
    final monthList = <Map<String, dynamic>>[];

    for (int i = 0; i < termDays.length - 1; i++) {
      final nextTerm = termDays[i + 1];
      final ganji = nextTerm.hmGanJee;
      final month = nextTerm.solarMonth;
      if (ganji.isEmpty) continue;

      final gan = ganji.substring(0, 1);
      final ji = ganji.length > 1 ? ganji.substring(1, 2) : '?';

      // ✅ 중복 월 제거
      if (monthList.any((m) => m['month'] == month)) continue;

      monthList.add({'month': month, 'stem': gan, 'branch': ji});
    }

    return monthList;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_daewoon == null || _daewoon!.isEmpty) return const SizedBox.shrink();

    final selectedDaewoon = _daewoon![_selectedDaewoonIndex];
    final saewoonList = _getSaewoonList(selectedDaewoon);
    final monthList = _getMonthList(_selectedYear);

    // 🔹 공통 비율 기반 크기 계산
    final screenWidth = MediaQuery.of(context).size.width;
    const outerPadding = 24.0;
    const gap = 12.0;
    const columns = 6; // 한 줄에 보여줄 칸 수
    final double boxSize =
        (screenWidth - (outerPadding * 2) - (gap * (columns - 1))) / columns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ① 대운
        Text(
          '대운(10년 주기) | ${selectedDaewoon.direction} ${selectedDaewoon.startAge % 10}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            children: _daewoon!.reversed.map((d) {
              final isSelected = _daewoon!.indexOf(d) == _selectedDaewoonIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDaewoonIndex = _daewoon!.indexOf(d);
                    _selectedYear = d.startYear;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Container(
                        width: boxSize,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.9)
                              : Colors.grey.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${d.startAge}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColors.primary.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      GapjaBox(
                        text: d.stem,
                        color: AppColors.fromGanji(d.stem),
                        size: boxSize,
                        showLabel: false,
                      ),
                      const SizedBox(height: 4),
                      GapjaBox(
                        text: d.branch,
                        color: AppColors.fromGanji(d.branch),
                        size: boxSize,
                        showLabel: false,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 10),

        // ② 세운
        Text(
          '세운 (${selectedDaewoon.startYear} ~ ${selectedDaewoon.endYear})년도',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            children: saewoonList.reversed.map((s) {
              final isSelected = s['year'] == _selectedYear;
              return GestureDetector(
                onTap: () => setState(() => _selectedYear = s['year']),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Container(
                        width: boxSize,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.9)
                              : Colors.grey.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${s['year']}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.primary.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      GapjaBox(
                        text: s['stem'] as String,
                        color: AppColors.fromGanji(s['stem'] as String),
                        size: boxSize,
                        showLabel: false,
                      ),
                      const SizedBox(height: 4),
                      GapjaBox(
                        text: s['branch'] as String,
                        color: AppColors.fromGanji(s['branch'] as String),
                        size: boxSize,
                        showLabel: false,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 10),

        // ③ 월운
        Text(
          '월운 ($_selectedYear년)',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            children: monthList.reversed.map((m) {
              final isCurrentMonth =
                  m['month'] == DateTime.now().month &&
                      _selectedYear == DateTime.now().year;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    Container(
                      width: boxSize,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isCurrentMonth
                            ? AppColors.primary.withValues(alpha: 0.9)
                            : Colors.grey.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${m['month']}월',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isCurrentMonth
                              ? Colors.white
                              : AppColors.primary.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    GapjaBox(
                      text: m['stem'] as String,
                      color: AppColors.fromGanji(m['stem'] as String),
                      size: boxSize,
                      showLabel: false,
                    ),
                    const SizedBox(height: 4),
                    GapjaBox(
                      text: m['branch'] as String,
                      color: AppColors.fromGanji(m['branch'] as String),
                      size: boxSize,
                      showLabel: false,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
