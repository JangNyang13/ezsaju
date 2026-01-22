import '../../../models/saju_analysis.dart';
import 'joyong_environment_registry.dart';
import 'joyong_environment_rule.dart';

class JoyongEnvironmentEvaluator {
  static void evaluate({
    required String dayStem,
    required String monthBranch,
    required SajuAnalysis analysis,
    required List<String> cautionMessages,
    required List<String> expectationMessages,
  }) {
    final rulesForStem = joyongEnvironmentRegistry[dayStem];
    if (rulesForStem == null) return;

    final rulesForMonth = rulesForStem[monthBranch];
    if (rulesForMonth == null) return;

    final ctx = EnvironmentContext(
      stems: analysis.exposedStems,
      branches: analysis.branches,
      juGroups: analysis.juGroups,
      bangGroups: analysis.bangGroups,
      gukGroups: analysis.juGroups, // 지금은 국 = juGroups로 사용
    );

    for (final rule in rulesForMonth) {
      if (rule.condition(ctx)) {
        if (rule.effect == EnvironmentEffect.negative) {
          cautionMessages.add(rule.id);
        } else {
          expectationMessages.add(rule.id);
        }
      }
    }
  }
}
