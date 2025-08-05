import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

import '../services/manse_loader.dart';
import '../constants/ganji_color_mappings.dart';

// 24절기 한글 이름(순서)
const List<String> _korTerms = [
  '소한','대한','입춘','우수','경칩','춘분','청명','곡우','입하','소만','망종','하지',
  '소서','대서','입추','처서','백로','추분','한로','상강','입동','소설','대설','동지',
];

/// cd_terms_time → 절기 한글명 (랜타임 채움)
final Map<String, String> _solarTermKo = {};

class DailyCalendarScreen extends StatefulWidget {
  const DailyCalendarScreen({super.key});
  @override
  State<DailyCalendarScreen> createState() => _DailyCalendarScreenState();
}

class _DailyCalendarScreenState extends State<DailyCalendarScreen> {
  Map<String, Map<String, dynamic>> _manseMap = {};
  DateTime _focusedDay = DateTime.now();

  /* ─── init ─── */
  @override
  void initState() {
    super.initState();
    _loadManse();
  }

  Future<void> _loadManse() async {
    final cache = await ManseLoader.load();

    // 연도별 등장 순서대로 절기 매핑
    _solarTermKo.clear();
    final cursor = <int, int>{};
    for (final v in cache.values.where((e) => e['cd_terms_time'] != null)) {
      final raw = v['cd_terms_time'] as String; // yyyymmddHHMM
      final yr  = int.parse(raw.substring(0, 4));
      final idx = cursor.putIfAbsent(yr, () => 0);
      if (idx < _korTerms.length) {
        _solarTermKo[raw] = _korTerms[idx];
        cursor[yr] = idx + 1;
      }
    }

    if (mounted) setState(() => _manseMap = cache);
  }

  /* ─── helpers ─── */
  String _key(DateTime d) =>
      '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickYearMonth() async {
    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        int selYear  = _focusedDay.year;
        int selMonth = _focusedDay.month;
        final years  = List.generate(201, (i) => 1900 + i);
        final months = List.generate(12, (i) => i + 1);

        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: selYear - 1900),
                        itemExtent: 32,
                        onSelectedItemChanged: (i) => selYear = years[i],
                        children: years.map((y) => Center(child: Text('$y년'))).toList(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: selMonth - 1),
                        itemExtent: 32,
                        onSelectedItemChanged: (i) => selMonth = months[i],
                        children: months.map((m) => Center(child: Text('$m월'))).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                child: const Text('이동'),
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _focusedDay = DateTime(selYear, selMonth, 1));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /* ─── build ─── */
  @override
  Widget build(BuildContext context) {
    if (_manseMap.isEmpty) return const Center(child: CircularProgressIndicator());

    return SafeArea(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickYearMonth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                '${_focusedDay.year}년 ${_focusedDay.month}월',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: TableCalendar(
              headerVisible: false,
              locale: 'ko_KR',
              firstDay: DateTime(1900, 1, 1),
              lastDay: DateTime(2100, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              rowHeight: 86,
              daysOfWeekHeight: 22,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              onPageChanged: (d) => setState(() => _focusedDay = d),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (ctx, day, _) => _cell(day, false),
                todayBuilder:  (ctx, day, _) => _cell(day, true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ─── cell ─── */
  Widget _cell(DateTime day, bool isToday) {
    final rec = _manseMap[_key(day)];
    if (rec == null) return const SizedBox.shrink();

    final ganji   = rec['cd_hdganjee'] as String;
    final rawTerm = rec['cd_terms_time'] as String?;
    final term    = rawTerm != null ? _solarTermKo[rawTerm] : null;

    final lunarTxt = '${rec['cd_leap_month'] == 1 ? '윤' : '음'} ${rec['cd_lm']}/${rec['cd_ld']}';

    return Container(
      decoration: BoxDecoration(
        color: isToday ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isToday ? Border.all(color: Colors.black87, width: 1.4) : null,
      ),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${day.day}', style: const TextStyle(color: Colors.black87, fontSize: 13)),
          Row(children: [ _charBox(ganji[0]), const SizedBox(width: 2), _charBox(ganji[1]) ]),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(lunarTxt, style: const TextStyle(fontSize: 10, color: Colors.black54)),
          ),
          if (term != null)
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(term, style: const TextStyle(fontSize: 10, color: Colors.black87)),
            ),
        ],
      ),
    );
  }

  Widget _charBox(String ch) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(color: colorOfGanjiChar(ch), borderRadius: BorderRadius.circular(3)),
      child: Text(
        ch,
        style: const TextStyle(fontFamily: 'SourceHanSansSC', fontSize: 12, color: Colors.white),
      ),
    );
  }
}
