import '../../models/luck_stages.dart';
import '../../models/saju_data.dart';

/// ------------------------------------------------------------
/// 운세 모듈 (12운성 + 봉법 + 거법)
/// ------------------------------------------------------------
/// - 봉법(逢法): 일간 기준으로 각 지지의 상태를 판단
/// - 거법(去法): 각 주간(年干, 月干, 日干, 時干)과
///               자기 지지(年支, 月支, 日支, 時支)의 관계 판단
/// ------------------------------------------------------------
// lib/services/module/unse_module.dart
class UnseModule {
  static Map<String, Map<String, String>> interpret(SajuData saju) {
    return analyze(saju);
  }

  static Map<String, String> analyzeBongBeop(SajuData saju) {
    final stem = saju.dayStem;
    return {
      '년지': LuckStages.getStage(stem, saju.yearBranch),
      '월지': LuckStages.getStage(stem, saju.monthBranch),
      '일지': LuckStages.getStage(stem, saju.dayBranch),
      '시지': LuckStages.getStage(stem, saju.hourBranch),
    };
  }

  static Map<String, String> analyzeGeoBeop(SajuData saju) {
    return {
      '년주': LuckStages.getStage(saju.yearStem, saju.yearBranch),
      '월주': LuckStages.getStage(saju.monthStem, saju.monthBranch),
      '일주': LuckStages.getStage(saju.dayStem, saju.dayBranch),
      '시주': LuckStages.getStage(saju.hourStem, saju.hourBranch),
    };
  }

  static Map<String, Map<String, String>> analyze(SajuData saju) {
    final bong = analyzeBongBeop(saju);
    final geo = analyzeGeoBeop(saju);
    return {
      '봉법(逢法)': bong,
      '거법(去法)': geo,
    };
  }
}
