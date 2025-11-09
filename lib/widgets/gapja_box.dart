import 'package:flutter/material.dart';
import '../models/stem_branch.dart';

class GapjaBox extends StatelessWidget {
  final String text;   // 표시할 글자 (예: 甲, 子 등)
  final Color color;   // 배경색
  final double size;   // 박스 크기 (정사각형)
  final bool showLabel; // 하단 '갑목 +' 같은 표시 여부

  const GapjaBox({
    super.key,
    required this.text,
    required this.color,
    this.size = 50,
    this.showLabel = true,
  });

  String? _getLabel() {
    // 천간
    final stem = heavenlyStems.firstWhere(
          (e) => e.name == text,
      orElse: () => const StemBranch(name: '', element: '', yinYang: ''),
    );
    if (stem.name.isNotEmpty) {
      return '${_getHangulName(stem.name)}${stem.element}${stem.yinYang == "양" ? " +" : " -"}';
    }

    // 지지
    final branch = earthlyBranches.firstWhere(
          (e) => e.name == text,
      orElse: () => const StemBranch(name: '', element: '', yinYang: ''),
    );
    if (branch.name.isNotEmpty) {
      return '${_getHangulName(branch.name)}${branch.element}${branch.yinYang == "양" ? " +" : " -"}';
    }

    return null;
  }

  String _getHangulName(String hanja) {
    const map = {
      // 천간
      '甲': '갑', '乙': '을', '丙': '병', '丁': '정',
      '戊': '무', '己': '기', '庚': '경', '辛': '신',
      '壬': '임', '癸': '계',
      // 지지
      '子': '자', '丑': '축', '寅': '인', '卯': '묘',
      '辰': '진', '巳': '사', '午': '오', '未': '미',
      '申': '신', '酉': '유', '戌': '술', '亥': '해',
    };
    return map[hanja] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final label = showLabel ? _getLabel() : null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.symmetric(
        vertical: size * 0.12,
        horizontal: size * 0.05,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 한자
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Transform.translate(
              // label 숨김 기준 중앙 정렬 보정
              offset: Offset(0, showLabel ? -2 : 1),
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'SourceHanSansSC',
                  // label 없는 경우 더 크게 중앙 정렬
                  fontSize: size * (showLabel ? 0.52 : 0.65),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ),
          ),
          if (label != null)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontSize: size * 0.155,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
