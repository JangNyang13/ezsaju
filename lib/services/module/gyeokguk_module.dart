// lib/services/module/gyeokguk_module.dart
import '../../models/saju_data.dart';
import '../../models/stem_branch.dart';

class GyeokgukModule {
  static String interpret(SajuData saju) {
    final dayStem = heavenlyStems.firstWhere((s) => s.name == saju.dayStem);
    final monthBranch = earthlyBranches.firstWhere((b) => b.name == saju.monthBranch);

    final dayE = dayStem.element;
    final monE = monthBranch.element;

    final dayYY = dayStem.yinYang;
    final monYY = monthBranch.yinYang;

    // 생(我生之) : day → month
    bool produces(String me, String other) {
      const m = {'목': '화', '화': '토', '토': '금', '금': '수', '수': '목'};
      return m[me] == other;
    }

    // 극(我克之) : day → month
    bool controls(String me, String other) {
      const m = {'목': '토', '토': '수', '수': '화', '화': '금', '금': '목'};
      return m[me] == other;
    }

    // 상대가 나를 극함
    bool controlledBy(String me, String other) => controls(other, me);

    // 상대가 나를 생함
    bool producedBy(String me, String other) => produces(other, me);

    // 1. 정관격: 月令이 日干을 극하고 음양이 다름
    if (controlledBy(dayE, monE) && dayYY != monYY) {
      return '정관격';
    }

    // 2. 재격: 日干이 月令을 극함 (음양 무관)
    if (controls(dayE, monE)) {
      return '재격';
    }

    // 3. 인수격: 月令이 日干을 생함
    if (producedBy(dayE, monE)) {
      return '인수격';
    }

    // 4. 식신격: 日干이 月令을 생하고 음양 같음
    if (produces(dayE, monE) && dayYY == monYY) {
      return '식신격';
    }

    // 5. 칠살격: 月令이 日干을 극하고 음양 같음
    if (controlledBy(dayE, monE) && dayYY == monYY) {
      return '편관격';
    }

    // 6. 상관격: 日干이 月令을 생하고 음양 다름
    if (produces(dayE, monE) && dayYY != monYY) {
      return '상관격';
    }

    // 7. 록겁격: 같은 오행
    if (dayE == monE) {
      // 7-1. 양인격: 日干 양 + 月令 음
      if (dayYY == '양' && monYY == '음') {
        return '양인격';
      }
      return '록겁격';
    }

    return '격미정';
  }
}
