import 'package:ezsaju/models/saju_data.dart';

import 'saju_analyzer.dart';
import '../../utils/elemental_relations.dart';

/// 전통식 신강/신약 분류 결과 + 근거
class StrengthDecision {
  final bool deukRyeong; // 득령
  final bool deukJi;     // 득지
  final bool deukSe;     // 득세
  /// 레벨: 극 신강 / 신강 / 중화신강 / 중화 / 중화신약 / 신약 / 극 신약
  final String level;
  final List<String> reasons;

  const StrengthDecision({
    required this.deukRyeong,
    required this.deukJi,
    required this.deukSe,
    required this.level,
    required this.reasons,
  });
}

class StrengthClassifier {
  final SajuAnalyzer a;
  StrengthClassifier(this.a);

  /// 전통적이면서 간단한 3축 분류
  StrengthDecision decide() {
    final dr = _isDeukRyeong();
    final dj = _isDeukJi();
    final ds = _isDeukSe();

    final level = _mapToLevel(dr, dj, ds);
    final reasons = <String>[
      "득령: ${dr ? 'O' : 'X'} (월지:${a.monthBranch}, 월지:${a.monthElement} / 일간:${a.dayElement})",
      "득지: ${dj ? 'O' : 'X'} (일지:${a.chart.dayZhi}, 일지:${_branchElem(a.chart.dayZhi)} / 일간:${a.dayElement})",
      "득세: ${ds ? 'O' : 'X'} (전체 판세 기준)",
    ];

    return StrengthDecision(
      deukRyeong: dr,
      deukJi: dj,
      deukSe: ds,
      level: level,
      reasons: reasons,
    );
  }

  bool _isDeukRyeong() {
    // 월지오행이 일간오행과 동일(비견) 또는 월지가 일간을 '생'(인성)하면 득령
    if (a.monthElement == a.dayElement) return true;
    final rel = _rel(a.monthElement, a.dayElement);
    return rel == "인성";
  }

  bool _isDeukJi() {
    final dz = a.chart.dayZhi;
    final dzElem = _branchElem(dz);
    if (dzElem == a.dayElement) return true;
    final rel = _rel(dzElem, a.dayElement);
    return rel == "인성";
  }

  bool _isDeukSe() {
    // 검사할 6개 (일간, 월지는 제외)
    final elems = <String>[
      _stemElem(a.chart.yearGan),
      _branchElem(a.chart.yearZhi),
      _stemElem(a.chart.monthGan),
      _branchElem(a.chart.dayZhi),
      if (a.chart.hasHour) _stemElem(a.chart.hourGan),
      if (a.chart.hasHour) _branchElem(a.chart.hourZhi),
    ];

    int supportCount = 0;
    for (final e in elems) {
      final rel = _rel(e, a.dayElement); // 비견/식상/재성/관살/인성
      if (rel == "비견" || rel == "인성") {
        supportCount++;
      }
    }

    // 비겁 + 인성이 3개 이상이면 득세
    return supportCount >= 3;
  }



  String _mapToLevel(bool dr, bool dj, bool ds) {
    // 8케이스 표 그대로
    if (dr && dj && ds) return "극 신강";      // A4
    if (dr && dj && !ds) return "신강";        // A2
    if (dr && !dj && ds) return "신강";        // A3
    if (dr && !dj && !ds) return "중화신약";   // A1

    if (!dr && !dj && !ds) return "극 신약";   // B1
    if (!dr && dj && !ds)  return "신약";      // B2
    if (!dr && !dj && ds)  return "신약";      // B3
    if (!dr && dj && ds)   return "중화신강";   // B4

    return "중화신약"; // 안전망
  }

  String _stemElem(String gan) => stemToElement[gan] ?? "-";
  String _branchElem(String zhi) => branchToElement[zhi] ?? "-";

  String _rel(String fromElem, String toDayElem) {
    // fiveElementRelation[일간][상대오행]
    final row = fiveElementRelation[toDayElem];
    return row?[fromElem] ?? "기타";
  }
}
