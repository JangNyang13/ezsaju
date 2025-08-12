import 'package:flutter/material.dart';
import 'package:ezsaju/models/saju_data.dart';

import '../constants/text_styles.dart';
import '../services/manse_loader.dart';
import '../services/saju_calculator.dart';
import '../services/ten_god_calculator.dart';
import '../utils/elemental_relations.dart';
import '../utils/daeun_calculator.dart';

// 쪼갠 위젯들
import 'saju_board.dart';
import 'fortune_block.dart';

class SajuAnalysisPanel extends StatefulWidget {
  const SajuAnalysisPanel({
    super.key,
    required this.title,
    required this.birth,          // 양력 DateTime
    required this.gender,         // 'M' | 'F'
    this.timeUnknown = false,     // 출생시간 모름
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  @override //같은 키로 유지되어도 상태를 재 초기화해줌.
  void didUpdateWidget(covariant SajuAnalysisPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.birth != widget.birth ||
        oldWidget.gender != widget.gender ||
        oldWidget.timeUnknown != widget.timeUnknown ||
        oldWidget.title != widget.title) {
      _initialized = false;
      _selDaeunIdx = null;
      _selYear = null;
      _selMonth = 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _manseFuture = ManseLoader.load(); // 캐시
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FutureBuilder<Map<String, Map<String, dynamic>>>(
      future: _manseFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError || !snap.hasData) {
          return Center(
            child: Text('만세력 로드 실패', style: AppTextStyles.body.copyWith(color: scheme.error)),
          );
        }

        final manse = snap.data!;
        final isMale = widget.gender == 'M';

        // ── 사주 계산 ───────────────────────────────────────────────
        final saju = SajuCalculator.fromDateTime(
          widget.birth,
          manse,
          timeUnknown: widget.timeUnknown,
        );

        // 시간 표시 안전 처리
        final hasHour = (saju.hour != null && saju.hour!.isNotEmpty);
        final hourGanText = hasHour ? saju.hour!.substring(0, 1) : '—';
        final hourZhiText = hasHour && saju.hour!.length >= 2 ? saju.hour!.substring(1) : '—';

        // ── 십성(간/지) ─────────────────────────────────────────────
        final yearTG  = calcTenGodBySaju(saju, saju.yearGan);
        final monthTG = calcTenGodBySaju(saju, saju.monthGan);
        final hourTG  = hasHour ? calcTenGodBySaju(saju, hourGanText) : '—';

        final yearZhiTG  = calcTenGodBySaju(saju, saju.yearZhi, isBranch: true);
        final monthZhiTG = calcTenGodBySaju(saju, saju.monthZhi, isBranch: true);
        final dayZhiTG   = calcTenGodBySaju(saju, saju.dayZhi,  isBranch: true);
        final hourZhiTG  = hasHour ? calcTenGodBySaju(saju, hourZhiText, isBranch: true) : '—';

        // ── 오행 카운트(천간+지지 합산) ──────────────────────────────
        final counts = <String, int>{'목': 0, '화': 0, '토': 0, '금': 0, '수': 0};
        void addElem(String? e) { if (e != null && counts.containsKey(e)) counts[e] = counts[e]! + 1; }
        // 천간
        addElem(stemToElement[saju.yearGan]);
        addElem(stemToElement[saju.monthGan]);
        addElem(stemToElement[saju.dayGan]);
        if (hasHour) addElem(stemToElement[hourGanText]);
        // 지지
        addElem(branchToElement[saju.yearZhi]);
        addElem(branchToElement[saju.monthZhi]);
        addElem(branchToElement[saju.dayZhi]);
        if (hasHour) addElem(branchToElement[hourZhiText]);

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

        final selIdx = (_selDaeunIdx ?? 0).clamp(0, periods.isEmpty ? 0 : periods.length - 1);
        final yearsOfSel = periods.isNotEmpty
            ? _yearsOfPeriod(widget.birth, periods[selIdx].startAge)
            : <int>[];

        // ── 화면 ───────────────────────────────────────────────────
        return SingleChildScrollView(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1) 상단 사주 보드
              SajuBoard(
                hourTG: hourTG,
                monthTG: monthTG,
                yearTG: yearTG,
                hourZhiTG: hourZhiTG,
                dayZhiTG: dayZhiTG,
                monthZhiTG: monthZhiTG,
                yearZhiTG: yearZhiTG,
                hourGanText: hourGanText,
                hourZhiText: hourZhiText,
                saju: saju,
                counts: counts,
              ),

              const SizedBox(height: 24),
              Divider(color: scheme.outlineVariant, thickness: 1),
              const SizedBox(height: 12),

              // 2) 하단 대운/세운/월운
              FortuneBlock(
                daeun: daeun,
                periods: periods,
                selIdx: selIdx,
                yearsOfSel: yearsOfSel,
                selYear: _selYear,
                selMonth: _selMonth,
                birth: widget.birth,
                manse: manse,
                currentAge: currentAge,
                currentPeriod: currentPeriod,
                onSelectDaeun: (i, p) {
                  setState(() {
                    _selDaeunIdx = i;
                    final ys = _yearsOfPeriod(widget.birth, p.startAge);
                    _selYear = (now.year >= ys.first && now.year <= ys.last) ? now.year : ys.first;
                    _selMonth = (_selYear == now.year) ? now.month : 1;
                  });
                },
                onSelectYear: (y) => setState(() { _selYear = y; _selMonth = 1; }),
                onSelectMonth: (m) => setState(() => _selMonth = m),
              ),
            ],
          ),
        );
      },
    );
  }


  // ── 데이터 helpers ────────────────────────────────────────────────
  List<int> _yearsOfPeriod(DateTime birth, int startAge) {
    final startYear = birth.year + (startAge - 1);
    return List<int>.generate(10, (i) => startYear + i);
  }
}
