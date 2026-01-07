import '../../../models/saju_data.dart';
import '../../analysis/saju_analyzer.dart';
import 'joyong_rule.dart';
import 'joyong_result.dart';
import '../../../models/stem_branch.dart';


class JoyongEvaluator {

  /// 🔮 조후(선·차용) 종합 평가
  static JoyongResult evaluate(
      SajuData saju,
      JoyongRule rule,
      ) {
    final analysis = SajuAnalyzer.analyze(saju);

    /// 기본 점수 : 보통
    double score = 3.0;

    /// -----------------------------
    /// 1️⃣ 주·보 용신 점수 계산
    /// -----------------------------

    // 실제 작동한 용신 목록 (UI 표시용)
    final mainYongsUsed = _findUsedYongs(
      yongs: rule.mainYong,
      analysis: analysis,
    );

    final subYongsUsed = _findUsedYongs(
      yongs: rule.subYong,
      analysis: analysis,
    );

    // 점수 계산
    final mainScore = _calcYongScore(
      yongs: rule.mainYong,
      analysis: analysis,
    );

    final subScore = _calcYongScore(
      yongs: rule.subYong,
      analysis: analysis,
    );

    score += mainScore;
    score += subScore.clamp(0.0, 1.0); // 보조용신은 최대 1점까지만

    final hasMain = mainScore > 0;
    final hasSub = subScore > 0;

    /// -----------------------------
    /// 2️⃣ 감점 요소
    /// -----------------------------
    final negativeFactors = <String>[];
    final positiveFactors = <String>[];

    // 갑·을목 + 금국
    if (analysis.juGroups.contains('금국') &&
        (saju.dayStem == '甲' || saju.dayStem == '乙')) {
      score -= 1.0;
      negativeFactors.add('목일간에 금국이 형성됨');
    }

    // 수국 과다 + 주용신 부재
    if (analysis.juGroups.contains('수국') && !hasMain) {
      score -= 1.0;
      negativeFactors.add('수기 과다 대비 조절 요소 부족');
    }

    /// -----------------------------
    /// 3️⃣ 최종 점수 보정
    /// -----------------------------
    final finalScore = score.round().clamp(1, 5);

    /// -----------------------------
    /// 4️⃣ 용신 작용 시기 탐색
    /// -----------------------------
    final mainYongFoundAt =
    _findYongPeriods(saju, rule.mainYong, analysis);

    final subYongFoundAt =
    _findYongPeriods(saju, rule.subYong, analysis);

    /// -----------------------------
    /// 5️⃣ 긍정 요소
    /// -----------------------------
    if (hasMain) positiveFactors.add('주용신 작용');
    if (hasSub) positiveFactors.add('보조용신 보완');

    /// -----------------------------
    /// 6️⃣ 결과 반환
    /// -----------------------------
    return JoyongResult(
      score: finalScore,
      levelName: _levelName(finalScore),
      hasMainYong: hasMain,
      hasSubYong: hasSub,
      mainYongFoundAt: mainYongFoundAt,
      subYongFoundAt: subYongFoundAt,
      positiveFactors: positiveFactors,
      negativeFactors: negativeFactors,
      mainYongsUsed: mainYongsUsed,
      subYongsUsed: subYongsUsed,
    );
  }

  /// 🔹 용신 점수 계산
  /// 천간 투출 = 1.0점
  /// 지장간 포함 = 0.5점
  static double _calcYongScore({
    required List<String> yongs,
    required dynamic analysis,
  }) {
    double score = 0.0;

    for (final y in yongs) {
      if (analysis.exposedStems.contains(y)) {
        score += 1.0;
      } else if (analysis.hiddenStems.contains(y)) {
        score += 0.5;
      }
    }
    return score;
  }

  /// 🔹 실제 작동한 용신 목록 추출 (UI 표시용)
  static List<String> _findUsedYongs({
    required List<String> yongs,
    required dynamic analysis,
  }) {
    return yongs.where((y) =>
    analysis.exposedStems.contains(y) ||
        analysis.hiddenStems.contains(y)
    ).toList();
  }

  /// 🔹 지장간 → 시기 매핑
  static List<String> _findYongPeriods(
      SajuData saju,
      List<String> yongs,
      dynamic analysis,
      ) {
    final periods = <String>[];

    void check(String branch, String label) {
      final branchData =
      earthlyBranches.firstWhere((e) => e.name == branch);
      final hidden = branchData.hiddenStems ?? [];

      if (hidden.any((h) => yongs.contains(h))) {
        periods.add(label);
      }
    }

    check(saju.yearBranch, '초년');
    check(saju.monthBranch, '청년');
    check(saju.dayBranch, '중년');
    check(saju.hourBranch, '말년');

    return periods;
  }

  /// 🔹 점수 → 레벨명
  static String _levelName(int score) {
    switch (score) {
      case 5:
        return '부귀';
      case 4:
        return '준수';
      case 3:
        return '보통';
      case 2:
        return '미흡';
      case 1:
        return '부담';
      default:
        return '보통';
    }
  }
}
