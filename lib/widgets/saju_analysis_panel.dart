// lib/widgets/saju_analysis_panel.dart
import 'package:ezsaju/models/saju_data.dart';
import 'package:flutter/material.dart';

import '../services/manse_loader.dart';
import '../services/saju_calculator.dart';
import '../utils/elemental_relations.dart';
import '../utils/daeun_calculator.dart';
import '../services/ten_god_calculator.dart';

/// 사주/십성/오행 + 대운/세운/월운 3단을 한 번에 보여주는 공통 패널
/// - 내 사주(MySajuScreen), 타인 조회(SajuLookupScreen) 모두 재사용 가능
class SajuAnalysisPanel extends StatefulWidget {
  const SajuAnalysisPanel({
    super.key,
    required this.title,
    required this.birth,          // 양력 DateTime
    required this.gender,         // 'M' | 'F'
    this.timeUnknown = false,     // 출생시간 모름
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
  });

  final String title;
  final DateTime birth;
  final String gender;
  final bool timeUnknown;
  final EdgeInsets padding;

  @override
  State<SajuAnalysisPanel> createState() => _SajuAnalysisPanelState();
}

class _SajuAnalysisPanelState extends State<SajuAnalysisPanel> {
  late final Future<Map<String, Map<String, dynamic>>> _manseFuture;

  int? _selDaeunIdx;  // 0~7
  int? _selYear;      // 세운 선택 연
  int _selMonth = 1;  // 월운 선택 월
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _manseFuture = ManseLoader.load(); // 캐시됨
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Map<String, dynamic>>>(
      future: _manseFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError || !snap.hasData) {
          return const Center(child: Text('만세력 로드 실패', style: TextStyle(color: Colors.black)));
        }

        final manse = snap.data!;
        final isMale = widget.gender == 'M';

        // ── 사주 계산 ───────────────────────────────────────────────
        final saju = SajuCalculator.fromDateTime(
          widget.birth,
          manse,
          timeUnknown: widget.timeUnknown,
        );

        // 안전한 시주 존재 여부 및 표기
        final hasHour = (saju.hour != null && saju.hour!.isNotEmpty);
        final hourGanText = hasHour ? saju.hour!.substring(0, 1) : '—';
        final hourZhiText = hasHour && saju.hour!.length >= 2 ? saju.hour!.substring(1) : '—';

        // ── 십성(간/지) : calcTenGodBySaju 사용 ─────────────────────
        final yearTG  = calcTenGodBySaju(saju, saju.yearGan);
        final monthTG = calcTenGodBySaju(saju, saju.monthGan);
        //final dayTG   = calcTenGodBySaju(saju, saju.dayGan);
        final hourTG  = hasHour ? calcTenGodBySaju(saju, hourGanText) : '—';

        final yearZhiTG  = calcTenGodBySaju(saju, saju.yearZhi, isBranch: true);
        final monthZhiTG = calcTenGodBySaju(saju, saju.monthZhi, isBranch: true);
        final dayZhiTG   = calcTenGodBySaju(saju, saju.dayZhi,  isBranch: true);
        final hourZhiTG  = hasHour ? calcTenGodBySaju(saju, hourZhiText, isBranch: true) : '—';

        // ── 오행 카운트(천간+지지 합산, 시주 없으면 제외) ─────────────
        final counts = <String, int>{'목': 0, '화': 0, '토': 0, '금': 0, '수': 0};
        void add(String? e) { if (e != null && counts.containsKey(e)) counts[e] = counts[e]! + 1; }
        // 천간
        add(stemToElement[saju.yearGan]);
        add(stemToElement[saju.monthGan]);
        add(stemToElement[saju.dayGan]);
        if (hasHour) add(stemToElement[hourGanText]);
        // 지지
        add(branchToElement[saju.yearZhi]);
        add(branchToElement[saju.monthZhi]);
        add(branchToElement[saju.dayZhi]);
        if (hasHour) add(branchToElement[hourZhiText]);

        // ── 대운 계산 ───────────────────────────────────────────────
        final daeun = DaeunCalculator.calculate(saju, widget.birth, isMale, manse);
        final periods = daeun.periods;
        final now = DateTime.now();
        final currentAge = DaeunCalculator.getCurrentAge(widget.birth);
        final currentPeriod = DaeunCalculator.getDaeunAtAge(daeun, currentAge);

        // 최초 선택값
        if (!_initialized && periods.isNotEmpty) {
          final currIdx = currentPeriod == null
              ? 0
              : periods.indexWhere((p) => p.ganzi == currentPeriod.ganzi);
          final safeIdx = currIdx >= 0 ? currIdx : 0;
          final years = _yearsOfPeriod(widget.birth, periods[safeIdx].startAge);
          _selDaeunIdx = safeIdx;
          _selYear = (now.year >= years.first && now.year <= years.last) ? now.year : years.first;
          _selMonth = (_selYear == now.year) ? now.month : 1;
          _initialized = true;
        }

        // 선택된 대운의 10개 연도
        final selIdx = (_selDaeunIdx ?? 0).clamp(0, periods.isEmpty ? 0 : periods.length - 1);
        final yearsOfSel = periods.isEmpty ? <int>[] : _yearsOfPeriod(widget.birth, periods[selIdx].startAge);

        return SingleChildScrollView(
          padding: widget.padding,
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.black),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ===== 타이틀 =====
                Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // ===== 십성(간) =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_txt(hourTG), _txt('본인'), _txt(monthTG), _txt(yearTG)],
                ),
                const SizedBox(height: 12),

                // ===== 간(천간) =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_txt(hourGanText), _txt(saju.dayGan), _txt(saju.monthGan), _txt(saju.yearGan)],
                ),
                const SizedBox(height: 12),

                // ===== 지(지지) =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_txt(hourZhiText), _txt(saju.dayZhi), _txt(saju.monthZhi), _txt(saju.yearZhi)],
                ),
                const SizedBox(height: 12),

                // ===== 십성(지) =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_txt(hourZhiTG), _txt(dayZhiTG), _txt(monthZhiTG), _txt(yearZhiTG)],
                ),

                const SizedBox(height: 20),

                // ===== 오행 카운트 =====
                Wrap(
                  spacing: 12, runSpacing: 8,
                  children: ['목','화','토','금','수']
                      .map((k) => _txt('$k : ${counts[k]}'))
                      .toList(),
                ),

                const SizedBox(height: 28),
                const Divider(thickness: 1),
                const SizedBox(height: 8),

                // ===== 대운/세운/월운 =====
                Text('대운수 ${daeun.startAge}세 (${daeun.isForward ? "순행" : "역행"})'),
                const SizedBox(height: 6),
                Text(
                  currentPeriod == null
                      ? '현재 $currentAge세'
                      : '현재 $currentAge세 → 대운 ${currentPeriod.ganzi} '
                      '(${currentPeriod.startAge}~${currentPeriod.endAge}세)',
                ),
                const SizedBox(height: 12),

                // 대운 바(나이 라벨 + 타일)
                if (periods.isNotEmpty) ...[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(periods.length, (i) =>
                          _smallLabel('${periods[i].endAge}', selected: i == selIdx)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(periods.length, (i) {
                        final p = periods[i];
                        final selected = i == selIdx;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selDaeunIdx = i;
                            final ys = _yearsOfPeriod(widget.birth, p.startAge);
                            _selYear = (now.year >= ys.first && now.year <= ys.last) ? now.year : ys.first;
                            _selMonth = (_selYear == now.year) ? now.month : 1;
                          }),
                          child: _ganziTile(
                            context,
                            gan: p.gan, zhi: p.zhi,
                            selected: selected, big: selected,
                          ),
                        );
                      }),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // 세운(해당 대운 10개 연도)
                if (periods.isNotEmpty) ...[
                  Align(alignment: Alignment.centerLeft,
                      child: Text('세운 (${periods[selIdx].ganzi})')),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: yearsOfSel
                          .map((y) => _yearLabel('$y', selected: y == _selYear))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: yearsOfSel.map((y) {
                        final gz = _yearGanZhi(y, manse);
                        final selected = y == _selYear;
                        return GestureDetector(
                          onTap: () => setState(() { _selYear = y; _selMonth = 1; }),
                          child: _ganziTile(
                            context,
                            gan: gz.isEmpty ? '—' : gz[0],
                            zhi: gz.isEmpty ? '—' : gz[1],
                            selected: selected,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // 월운(선택 연도의 1~12월)
                if (_selYear != null) ...[
                  Align(alignment: Alignment.centerLeft,
                      child: Text('월운 ($_selYear년)')),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(12, (i) => i + 1)
                          .map((m) => _monthLabel('$m월', selected: m == _selMonth))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(12, (i) => i + 1).map((m) {
                        final gz = _monthGanZhi(_selYear!, m, manse);
                        final selected = m == _selMonth;
                        return GestureDetector(
                          onTap: () => setState(() => _selMonth = m),
                          child: _ganziTile(
                            context,
                            gan: gz.isEmpty ? '—' : gz[0],
                            zhi: gz.isEmpty ? '—' : gz[1],
                            selected: selected,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ── 텍스트/타일 helpers ───────────────────────────────────────────
  Widget _txt(String s) =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(s, style: const TextStyle(color: Colors.black)));

  Widget _smallLabel(String text, {required bool selected}) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(text,
          style: TextStyle(
            fontSize: selected ? 14 : 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: Colors.black,
          ),
        ),
      );

  Widget _yearLabel(String text, {required bool selected}) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(text,
          style: TextStyle(
            fontSize: selected ? 16 : 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            decoration: selected ? TextDecoration.underline : TextDecoration.none,
            color: Colors.black,
          ),
        ),
      );

  Widget _monthLabel(String text, {required bool selected}) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Text(text,
          style: TextStyle(
            fontSize: selected ? 16 : 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: Colors.black,
          ),
        ),
      );

  /// 간지 타일: 배경은 천간 오행 색(임시 매핑), 텍스트는 검정, 선택 시 파란 테두리 + 살짝 확대
  Widget _ganziTile(
      BuildContext ctx, {
        required String gan,
        required String zhi,
        bool selected = false,
        bool big = false,
      }) {
    final Color bg = _colorForElement(ctx, stemToElement[gan] ?? '');
    final borderColor = selected ? Theme.of(ctx).colorScheme.primary : Colors.black54;

    return AnimatedScale(
      duration: const Duration(milliseconds: 150),
      scale: big ? 1.12 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(gan, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black)),
            const SizedBox(height: 2),
            Text(zhi, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  // ── 데이터 helpers ────────────────────────────────────────────────
  List<int> _yearsOfPeriod(DateTime birth, int startAge) {
    final startYear = birth.year + (startAge - 1);
    return List<int>.generate(10, (i) => startYear + i);
  }

  String _yearGanZhi(int year, Map<String, Map<String, dynamic>> manse) {
    for (final day in [DateTime(year, 7, 1), DateTime(year, 3, 1), DateTime(year, 2, 5)]) {
      final row = manse[_key(day)];
      if (row != null) return (row['cd_hyganjee'] ?? '').toString();
    }
    return '';
  }

  String _monthGanZhi(int year, int month, Map<String, Map<String, dynamic>> manse) {
    for (final d in [15, 10, 20]) {
      final row = manse[_key(DateTime(year, month, d))];
      if (row != null) return (row['cd_hmganjee'] ?? '').toString();
    }
    final list = manse.entries
        .where((e) => e.key.startsWith('$year${month.toString().padLeft(2, '0')}'))
        .map((e) => e.value).toList();
    if (list.isNotEmpty) return (list.first['cd_hmganjee'] ?? '').toString();
    return '';
  }

  String _key(DateTime d) =>
      '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';

  // TODO: AppColors로 교체 권장 (임시 색)
  Color _colorForElement(BuildContext ctx, String element) {
    switch (element) {
      case '목': return const Color(0xFFffffff); // Color(0xFF6EDC6E);
      case '화': return const Color(0xFFffffff); // Color(0xFFFF6B6B);
      case '토': return const Color(0xFFffffff); // Color(0xFFFFD54F);
      case '금': return const Color(0xFFffffff); // Color(0xFFBDBDBD);
      case '수': return const Color(0xFFffffff); // Color(0xFF90CAF9);
      default:   return Theme.of(ctx).colorScheme.surfaceContainerHighest;
    }
  }
}
