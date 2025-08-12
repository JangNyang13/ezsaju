import 'package:flutter/material.dart';
import '../constants/text_styles.dart';
import '../constants/colors.dart';
import '../utils/daeun_calculator.dart';
import '../utils/elemental_relations.dart';

class FortuneBlock extends StatelessWidget {
  const FortuneBlock({
    super.key,
    required this.daeun,
    required this.periods,
    required this.selIdx,
    required this.yearsOfSel,
    required this.selYear,
    required this.selMonth,
    required this.birth,
    required this.manse,
    required this.currentAge,
    required this.currentPeriod,
    required this.onSelectDaeun,
    required this.onSelectYear,
    required this.onSelectMonth,
  });

  final DaeunInfo daeun;
  final List<DaeunPeriod> periods;
  final int selIdx;
  final List<int> yearsOfSel;
  final int? selYear;
  final int selMonth;
  final DateTime birth;
  final Map<String, Map<String, dynamic>> manse;
  final int currentAge;
  final DaeunPeriod? currentPeriod;

  final void Function(int index, DaeunPeriod period) onSelectDaeun;
  final void Function(int year) onSelectYear;
  final void Function(int month) onSelectMonth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bool hasPeriods = periods.isNotEmpty;
    final DaeunPeriod? sel = hasPeriods ? periods[selIdx.clamp(0, periods.length - 1)] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 헤더(선택 대운 기준)
        if (sel != null) ...[
          Center(
            child: Text(
              '대운 ${sel.ganzi}  •  ${sel.startAge}~${sel.endAge}세',
              style: AppTextStyles.body.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              '대운수 기준: ${daeun.startAge}세 (${daeun.isForward ? "순행" : "역행"})',
              style: AppTextStyles.caption.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],

        const SizedBox(height: 6),
        Center(
          child: Text(
            currentPeriod == null
                ? '현재 $currentAge세'
                : '현재 $currentAge세 → ${currentPeriod!.ganzi} '
                '(${currentPeriod!.startAge}~${currentPeriod!.endAge}세)',
            style: AppTextStyles.body.copyWith(color: scheme.onSurface),
          ),
        ),
        const SizedBox(height: 12),

        // === 대운: 숫자/간/지 세 줄(가로 스크롤) ===
        if (hasPeriods) ...[
          _hScroll(Row(
            children: periods.map((p) {
              final selected = periods.indexOf(p) == selIdx;
              return GestureDetector(
                onTap: () => onSelectDaeun(periods.indexOf(p), p),
                child: _Triplet(
                  top: '${p.startAge}',
                  mid: p.gan,
                  bot: p.zhi,
                  width: 56,
                  selected: selected,
                ),
              );
            }).toList(),
          )),
        ],

        const SizedBox(height: 20),

        // === 세운: 연도 10개 + 간/지
        if (hasPeriods) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('세운', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 8),
          _hScroll(Row(
            children: yearsOfSel.map((y) {
              final gz = _yearGanZhi(y, manse);
              final selected = y == selYear;
              final gan = gz.isEmpty ? '—' : gz[0];
              final zhi = gz.isEmpty ? '—' : gz[1];
              return _Triplet(
                top: '$y',
                mid: gan,
                bot: zhi,
                width: 64,
                selected: selected,
                onTap: () => onSelectYear(y),
              );
            }).toList(),
          )),
        ],

        const SizedBox(height: 20),

        // === 월운: 1~12월 + 간/지
        if (selYear != null) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('월운', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 8),
          _hScroll(Row(
            children: List.generate(12, (i) => i + 1).map((m) {
              final gz = _monthGanZhi(selYear!, m, manse);
              final selected = m == selMonth;
              final gan = gz.isEmpty ? '—' : gz[0];
              final zhi = gz.isEmpty ? '—' : gz[1];
              return _Triplet(
                top: '$m',
                mid: gan,
                bot: zhi,
                width: 40,
                selected: selected,
                onTap: () => onSelectMonth(m),
              );
            }).toList(),
          )),
        ],
      ],
    );
  }

  // ===== helpers (스크롤/간지 조회) =====
  Widget _hScroll(Widget child) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: child,
  );

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
        .map((e) => e.value)
        .toList();
    if (list.isNotEmpty) return (list.first['cd_hmganjee'] ?? '').toString();
    return '';
  }

  String _key(DateTime d) =>
      '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';
}

/* ───────── 공용 작은 위젯들 (간지 색 적용) ───────── */

class _Triplet extends StatelessWidget {
  const _Triplet({
    required this.top,
    required this.mid,
    required this.bot,
    required this.width,
    this.selected = false,
    this.onTap,
  });

  final String top, mid, bot;
  final double width;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final bgCard = selected ? s.primaryContainer : Colors.transparent;
    final bdCard = selected ? s.primary : s.outlineVariant;

    // ── 간/지 오행 배경 + 흰색 텍스트 계산
    Color bgFor(String ch, {required bool branch}) {
      if (ch == '—') return s.surfaceContainerHigh;
      final elem = branch ? branchToElement[ch] : stemToElement[ch];
      switch (elem) {
        case '목': return AppColors.wood;
        case '화': return AppColors.fire;
        case '토': return AppColors.earth;
        case '금': return AppColors.metal;
        case '수': return AppColors.water;
        default:   return s.surfaceContainerHigh;
      }
    }

    final midBg = bgFor(mid, branch: false); // 간 = 천간
    final botBg = bgFor(bot, branch: true);  // 지 = 지지
    final midFg = (mid != '—' && midBg != s.surfaceContainerHigh) ? Colors.white : s.onSurface;
    final botFg = (bot != '—' && botBg != s.surfaceContainerHigh) ? Colors.white : s.onSurface;

    TextStyle labelStyle = AppTextStyles.body.copyWith(fontWeight: FontWeight.w600);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: bdCard),
          color: bgCard,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // top 라벨(나이/연도/월)
            Container(
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(top, style: labelStyle),
            ),
            const SizedBox(height: 4),

            // 간(오행배경)
            Container(
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: midBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(mid, style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w800, color: midFg)),
            ),
            const SizedBox(height: 4),

            // 지(오행배경)
            Container(
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: botBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(bot, style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w800, color: botFg)),
            ),
          ],
        ),
      ),
    );
  }
}
