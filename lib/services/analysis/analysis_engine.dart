import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:ezsaju/services/analysis/strength_classifier.dart';
import '../../models/analysis_report.dart';
import '../../models/saju_data.dart';
import 'saju_analyzer.dart';
import 'yongshin_selector.dart';
import '../../utils/elemental_relations.dart';

/// 사주 해석 엔진 (자평진전, 궁통보감, 적천수 + 전통 득령/득지/득세 분류)
class AnalysisEngine {
  late final Map<String, dynamic> weights;
  late final Map<String, dynamic> patterns;
  late final Map<String, dynamic> narrations;

  AnalysisEngine._();

  /// JSON 규칙 로딩
  static Future<AnalysisEngine> create() async {
    final engine = AnalysisEngine._();
    engine.weights =
        jsonDecode(await rootBundle.loadString('assets/data/analysis/weights.json'));
    engine.patterns =
        jsonDecode(await rootBundle.loadString('assets/data/analysis/patterns.json'));
    engine.narrations =
        jsonDecode(await rootBundle.loadString('assets/data/analysis/narrations.json'));
    return engine;
  }

  /// 사주 전체 해석 (전통식 레벨 + 점수식 병행)
  AnalysisReport analyze(SajuData chart) {
    final analyzer = SajuAnalyzer(chart);

    // ① 전통식 분류
    final trad = StrengthClassifier(analyzer).decide();
    final level = trad.level;

    // ② 점수식 (참고용)
    final score = _calcStrength(analyzer);

    // ③ 용신 (억부 + 조후)
    final ys = YongshinSelector(analyzer, level).decide();

    // ④ 기신
    final unhelpful = _deriveGishin(level, analyzer);

    // ⑤ 패턴 탐지
    final matchedPatterns = _detectPatterns(analyzer);

    // ⑥ 내러티브
    final narr = _generateNarrations(level, matchedPatterns, [...ys.eokbu, ...ys.johu])
      ..addAll(trad.reasons);

    return AnalysisReport(
      strengthScore: score,
      strengthLevel: level,
      patterns: matchedPatterns,
      eokbu: ys.eokbu,
      johu: ys.johu,
      unhelpfulGods: unhelpful,
      narrations: narr,
      reasons: trad.reasons,
    );
  }


  /// 신강/신약 점수화 (자평진전 + 궁통보감) — 참조용/튜닝용
  int _calcStrength(SajuAnalyzer analyzer) {
    int score = 0;
    final s = weights["strength"];

    // 1) 월령 가중치
    if (analyzer.monthElement == analyzer.dayElement) {
      score += (s["month_branch_weight"] as num).toInt();
    }

    // 2) 같은 오행 개수 (비견/겁재)
    score += analyzer.countOf(analyzer.dayElement) *
        (s["same_element_bonus"] as num).toInt();

    // 3) 생조 오행 (인성/식상) — 단순화(필요시 정밀화)
    for (final rel in const ['인성', '식상']) {
      if (analyzer.tenGodOf(analyzer.dayElement) == rel) {
        score += (s["generating_element_bonus"] as num).toInt();
      }
    }

    // 4) 극하는 오행 (재성/관살)
    for (final rel in const ['재성', '관살']) {
      if (analyzer.tenGodOf(analyzer.dayElement) == rel) {
        score += (s["controlling_element_penalty"] as num).toInt();
      }
    }

    // 5) 계절 보정 (궁통보감)
    final season = analyzer.season; // "spring" | "summer" | "autumn" | "winter"
    final seasonAdj = (s["season_adjustments"]?[season]?[analyzer.dayElement] as num?) ?? 0;
    score += seasonAdj.toInt();

    return score;
  }

  /// 격국/특수 패턴 탐지 (적천수) — patterns.json 규칙 기반
  List<String> _detectPatterns(SajuAnalyzer analyzer) {
    final List<String> results = [];
    final list = (patterns["patterns"] as List?) ?? const [];

    for (final raw in list) {
      final p = raw as Map<String, dynamic>;
      final cond = (p["condition"] as Map?) ?? const {};
      final tenGodFocus = cond["ten_god_focus"] as String?;
      // TODO: 필요 시 조건식을 확장 (월지/일지/장간/합충 등)
      if (tenGodFocus != null) {
        // 현재는 ‘일간 오행과의 관계명’이 해당 포커스와 일치하는지의 매우 단순 판별
        if (analyzer.tenGodOf(analyzer.dayElement) == tenGodFocus) {
          results.add(p["name"] as String? ?? "");
        }
      }
    }
    return results.where((e) => e.isNotEmpty).toList();
  }

  /// 전통식 레벨에 따른 '기신(피해야 할 오행)' 도출
  List<String> _deriveGishin(String level, SajuAnalyzer a) {
    String? elemFor(String rel) {
      final row = fiveElementRelation[a.dayElement];
      if (row == null) return null;
      for (final e in row.entries) {
        if (e.value == rel) return e.key;
      }
      return null;
    }

    // 새 레벨 그룹에 맞춤
    const strongSide = ["중화신강", "신강", "극 신강"];
    const weakSide   = ["중화신약", "신약", "극 신약"];

    if (weakSide.contains(level)) {
      // 약한 쪽: 나를 더 약하게 하거나 소모시키는 것들이 기신
      return [
        elemFor("재성"),
        elemFor("관살"),
        elemFor("식상"),
      ].whereType<String>().toList();
    }
    if (strongSide.contains(level)) {
      // 강한 쪽: 나를 더 강화하는 동원(비견·인성)이 기신
      return [
        a.dayElement,         // 비견
        elemFor("인성"),
      ].whereType<String>().toList();
    }
    // '중화'인 경우는 케이스별 (필요시 조후/대운 고려)
    return [];
  }

  /// 내러티브 생성 (레벨/패턴/용신 기반)
  List<String> _generateNarrations(
      String level,
      List<String> patterns,
      List<String> yongshinElements,
      ) {
    final narr = <String>[];

    // 1) 신강/신약 해설
    final strengthList = narrations["strength"]?[level];
    if (strengthList is List) {
      narr.addAll(strengthList.cast<String>());
    }

    // 2) 패턴 해설
    final pMap = (narrations["patterns"] as Map?) ?? const {};
    for (final tag in patterns) {
      final arr = pMap[tag];
      if (arr is List) {
        narr.addAll(arr.cast<String>());
      }
    }
    return narr;
  }

}
