import '../../models/saju_data.dart';
import '../../models/stem_branch.dart';
import '../../models/element_relations.dart';

class GoongtongModule {
  /// 일간 강약 판단
  /// 월지 오행이 일간과 같으면 신강,
  /// 생해주면 강, 극하면 약, 설기하면 중화
  static String analyzeStrength(SajuData saju) {
    final dayStem = saju.dayPillar.substring(0, 1);
    final monthBranch = saju.monthPillar.substring(1, 2);

    final day = heavenlyStems.firstWhere((e) => e.name == dayStem);
    final month = earthlyBranches.firstWhere((e) => e.name == monthBranch);

    if (day.element == month.element) return '신강';
    if (ElementRelations.isGenerating(month.element, day.element)) return '신강';
    if (ElementRelations.isGenerating(day.element, month.element)) return '신약';
    if (ElementRelations.isOvercoming(month.element, day.element)) return '신약';
    return '중화';
  }

  /// 조후(온량·조습) 분석
  /// 계절의 기운(월지)에 따른 오행 조화
  static String analyzeClimate(SajuData saju) {
    final monthBranch = saju.monthPillar.substring(1, 2);
    switch (monthBranch) {
      case '寅':
      case '卯':
        return '춘목(봄) — 온기 상승, 화기 보완 필요';
      case '巳':
      case '午':
        return '하화(여름) — 열기 강, 수·금으로 조화 필요';
      case '申':
      case '酉':
        return '추금(가을) — 서늘, 화기로 온난 보완';
      case '亥':
      case '子':
        return '동수(겨울) — 한기 심, 화로 온기 보충';
      default:
        return '사계(중간) — 균형 유지';
    }
  }

  /// 용신 및 희신 판단
  static String determineYongshin(String strength, String climate) {
    if (strength == '신강') {
      if (climate.contains('여름')) return '수(水)로 냉각, 금(金)으로 제화';
      if (climate.contains('봄')) return '금(金)으로 절제, 수(水)로 조화';
      return '재·관(財官) 계열 희신';
    } else if (strength == '신약') {
      if (climate.contains('겨울')) return '화(火)로 온기 보완, 목(木)으로 생조';
      if (climate.contains('가을')) return '목(木)으로 활력 보충, 화(火)로 생명 부여';
      return '인·비(印比) 계열 용신';
    } else {
      return '균형형 — 특정 용신보다 중화 유지가 핵심';
    }
  }

  /// 통합 해석
  static Map<String, String> interpret(SajuData saju) {
    final strength = analyzeStrength(saju);
    final climate = analyzeClimate(saju);
    final yongshin = determineYongshin(strength, climate);

    return {
      '일간강약': strength,
      '조후판단': climate,
      '용신/희신': yongshin,
    };
  }
}
