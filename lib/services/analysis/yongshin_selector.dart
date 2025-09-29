import '../../utils/elemental_relations.dart';
import 'saju_analyzer.dart';

/// 용신 선정 결과
class YongshinResult {
  /// 억부용신 후보
  final List<String> eokbu;

  /// 조후용신 후보
  final List<String> johu;

  /// 근거 태그(신강도, 계절, 관계 등)
  final List<String> reasons;

  const YongshinResult({
    required this.eokbu,
    required this.johu,
    required this.reasons,
  });
}


/// 억부용신 + 조후용신 선택기
class YongshinSelector {
  final SajuAnalyzer analyzer;
  final String strengthLevel; // 극 신강 / 신강 / 중화신강 / 중화 / 중화신약 / 신약 / 극 신약

  YongshinSelector(this.analyzer, this.strengthLevel);

  YongshinResult decide() {
    final reasons = <String>[];

    final eokbuRes = _pickEokbu();
    final johuRes = _pickJohu();

    reasons.addAll(eokbuRes.$2);
    reasons.addAll(johuRes.$2);

    return YongshinResult(
      eokbu: eokbuRes.$1,
      johu: johuRes.$1,
      reasons: reasons,
    );
  }

  /// 억부용신: 약 → 비견·인성 / 강 → 관살·재성(±식상)
  (List<String>, List<String>) _pickEokbu() {
    final dm = analyzer.dayElement;

    String? elemFor(String rel) {
      final row = fiveElementRelation[dm];
      if (row == null) return null;
      for (final e in row.entries) {
        if (e.value == rel) return e.key;
      }
      return null;
    }

    const strongSide = ["중화신강", "신강", "극 신강"];
    const weakSide   = ["중화신약", "신약", "극 신약"];

    if (weakSide.contains(strengthLevel)) {
      final elems = <String>[
        dm,                     // 비견
        elemFor("인성") ?? "",  // 인성
      ];
      return (
      elems.where((e) => e.isNotEmpty).toList(),
      ["억부(扶弱): 약체 → 비견·인성 위주"]
      );
    }

    if (strongSide.contains(strengthLevel)) {
      final elems = <String>[
        elemFor("관살") ?? "",
        elemFor("재성") ?? "",
        elemFor("식상") ?? "",
      ];
      return (
      elems.where((e) => e.isNotEmpty).toList(),
      ["억부(抑强): 강체 → 관살·재성(±식상)"]
      );
    }

    return (<String>[], ["중화: 조후/대운 합산 판단"]);
  }

  /// 조후용신: 계절 온냉 보정
  (List<String>, List<String>) _pickJohu() {
    switch (analyzer.season) {
      case "summer":
        return (["수"], ["조후: 여름 더위 → 수로 냉"]);
      case "autumn":
        return (["수"], ["조후: 가을 건조·서늘 → 수로 윤택/냉"]);
      case "winter":
        return (["화"], ["조후: 겨울 한랭 → 화로 온"]);
      case "spring":
      default:
        return (<String>[], []);
    }
  }
}