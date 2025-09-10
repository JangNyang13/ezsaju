// lib/widgets/saju_board.dart
import 'package:flutter/material.dart';

import '../constants/text_styles.dart';
import '../constants/colors.dart';
import '../models/saju_data.dart';
import '../utils/elemental_relations.dart'; // stemToElement, branchToElement
import '../utils/ganji_describe.dart';      // describeStem, describeBranch

class SajuBoard extends StatelessWidget {
  const SajuBoard({
    super.key,
    required this.hourTG,
    required this.monthTG,
    required this.yearTG,
    required this.hourZhiTG,
    required this.dayZhiTG,
    required this.monthZhiTG,
    required this.yearZhiTG,
    required this.hourGanText,
    required this.hourZhiText,
    required this.saju,
    required this.counts,
  });

  final String hourTG, monthTG, yearTG;
  final String hourZhiTG, dayZhiTG, monthZhiTG, yearZhiTG;
  final String hourGanText, hourZhiText;
  final SajuData saju;
  final Map<String, int> counts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6), // 좌우 여백만 살짝
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 헤더
          _fourTileRow(const [
            _GridHeader(title: '시주'),
            _GridHeader(title: '일주'),
            _GridHeader(title: '월주'),
            _GridHeader(title: '년주'),
          ]),
          const SizedBox(height: 8),

          // ── 천간(상단): 2:3 타일 + 십성 + 설명 ─────────────────
          _fourTileRow([
            _SquareBox(
              text: hourGanText,
              colorByElement: true,
              isBranch: false,
              tenGod: hourTG,
              expl: saju.hasHour ? describeStem(hourGanText): "ㅡ", // +갑목
            ),
            _SquareBox(
              text: saju.dayGan,
              colorByElement: true,
              isBranch: false,
              tenGod: '본인',
              expl: describeStem(saju.dayGan),
            ),
            _SquareBox(
              text: saju.monthGan,
              colorByElement: true,
              isBranch: false,
              tenGod: monthTG,
              expl: describeStem(saju.monthGan),
            ),
            _SquareBox(
              text: saju.yearGan,
              colorByElement: true,
              isBranch: false,
              tenGod: yearTG,
              expl: describeStem(saju.yearGan),
            ),
          ]),
          const SizedBox(height: 8),

          // ── 지지(하단): 2:3 타일 + 십성 + 설명 ─────────────────
          _fourTileRow([
            _SquareBox(
              text: hourZhiText,
              colorByElement: true,
              isBranch: true,
              tenGod: hourZhiTG,
              expl: saju.hasHour ? describeBranch(hourZhiText): "ㅡ", // +자수
            ),
            _SquareBox(
              text: saju.dayZhi,
              colorByElement: true,
              isBranch: true,
              tenGod: dayZhiTG,
              expl: describeBranch(saju.dayZhi),
            ),
            _SquareBox(
              text: saju.monthZhi,
              colorByElement: true,
              isBranch: true,
              tenGod: monthZhiTG,
              expl: describeBranch(saju.monthZhi),
            ),
            _SquareBox(
              text: saju.yearZhi,
              colorByElement: true,
              isBranch: true,
              tenGod: yearZhiTG,
              expl: describeBranch(saju.yearZhi),
            ),
          ]),

          const SizedBox(height: 16),

          // ── 오행 카운트 (한 줄 전체를 요소 색으로)
          Center(
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              children: ['목', '화', '토', '금', '수'].map((e) {
                final v = counts[e] ?? 0;
                return Text(
                  '$e : $v',
                  style: AppTextStyles.body.copyWith(
                    color: _colorForElement(e),   // 전체를 요소 색으로
                    fontWeight: FontWeight.w900,
                  ),
                );
              }).toList(),
            ),
          ),

        ],
      ),
    );
  }

  /// 4칸을 가로로 꽉 채우는 공통 레이아웃 (좌우 spacer 삭제)
  Widget _fourTileRow(List<Widget> tiles) {
    const gap = SizedBox(width: 8);
    return Row(
      children: [
        Expanded(child: tiles[0]),
        gap,
        Expanded(child: tiles[1]),
        gap,
        Expanded(child: tiles[2]),
        gap,
        Expanded(child: tiles[3]),
      ],
    );
  }
}

/* ───────── 소형 위젯들 ───────── */

class _GridHeader extends StatelessWidget {
  const _GridHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Center(
        child: Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// 2:3 타일 (간/지 오행 배경 + 흰 글자 + 십성 + 설명)
class _SquareBox extends StatelessWidget {
  const _SquareBox({
    required this.text,
    this.colorByElement = false,
    this.isBranch = false,
    this.tenGod,
    this.expl,
  });

  final String text;
  final bool colorByElement; // 간/지일 때 true
  final bool isBranch;       // 지지일 때 true
  final String? tenGod;      // 상단 십성
  final String? expl;        // 하단 설명(+갑목 / +자수)

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color bg = scheme.surfaceContainerHigh;

    if (colorByElement && text != '—') {
      final elem = isBranch ? branchToElement[text] : stemToElement[text];
      if (elem != null) {
        switch (elem) {
          case '목': bg = AppColors.wood;  break;
          case '화': bg = AppColors.fire;  break;
          case '토': bg = AppColors.earth; break;
          case '금': bg = AppColors.metal; break;
          case '수': bg = AppColors.water; break;
        }
      }
    }

    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth; // 한 칸 폭 (Expanded가 정해줌)

        return Container(
          // ✅ 고정크기(SizedBox) 제거 — 너비만 부모에 맞게
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 4,
                spreadRadius: 0.3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: LayoutBuilder(
              builder: (context, cc) {
                // ✅ 세로는 내용에 따라 결정되므로 폰트는 '가로폭' 기준으로 비례
                final titleFs = (w * 0.14).clamp(13.0, 16.0).toDouble();
                final charFs  =  w * 0.56;
                final explFs  = (w * 0.12).clamp(13.0, 14.0).toDouble();

                final hasTenGod = tenGod != null && tenGod!.isNotEmpty;
                final hasExpl   = expl   != null && expl!  .isNotEmpty;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (hasTenGod)
                      Text(
                        tenGod!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w500,
                          fontSize: titleFs,
                          height: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    if (hasTenGod) const SizedBox(height: 5),

                    // 중앙 한자 — FittedBox 없이 가로폭 비례 크기
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SourceHanSansSC',
                          fontWeight: FontWeight.w300,
                          fontSize: charFs,
                          height: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    if (hasExpl) const SizedBox(height: 12),

                    if (hasExpl)
                      Text(
                        expl!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w500,
                          fontSize: explFs,
                          height: 1.0,
                          color: Colors.white,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}


Color _colorForElement(String e) {
  switch (e) {
    case '목': return AppColors.wood;
    case '화': return AppColors.fire;
    case '토': return AppColors.earth;
    case '금': return AppColors.metal;
    case '수': return AppColors.water;
    default:   return Colors.grey;
  }
}
