// lib/services/analysis/saju_analyzer.dart
import '../../models/saju_data.dart';
import '../../models/saju_analysis.dart';
import '../../models/stem_branch.dart';

class SajuAnalyzer {

  static SajuAnalysis analyze(SajuData saju) {
    final branches = {
      saju.yearBranch,
      saju.monthBranch,
      saju.dayBranch,
      saju.hourBranch,
    };

    /// 지장간
    final hiddenStems = <String>{};
    for (final b in branches) {
      final data = earthlyBranches.firstWhere((e) => e.name == b);
      hiddenStems.addAll(data.hiddenStems ?? []);
    }

    /// 천간
    final stems = {
      saju.yearStem,
      saju.monthStem,
      saju.dayStem,
      saju.hourStem,
    };

    /// 투출
    final exposedStems = hiddenStems.intersection(stems);

    /// 삼합 (반합 포함, 왕지 필수)
    bool hasJuWithKing(Set<String> group, String king) {
      return branches.intersection(group).length >= 2
          && branches.contains(king);
    }

    /// 방합
    bool hasBang(Set<String> s) => branches.intersection(s).length == 3;

    final juGroups = <String>{};

    // 왕지: 수=子, 목=卯, 화=午, 금=酉
    if (hasJuWithKing({'申','子','辰'}, '子')) juGroups.add('수국');
    if (hasJuWithKing({'亥','卯','未'}, '卯')) juGroups.add('목국');
    if (hasJuWithKing({'寅','午','戌'}, '午')) juGroups.add('화국');
    if (hasJuWithKing({'巳','酉','丑'}, '酉')) juGroups.add('금국');

    final bangGroups = <String>{};
    // 🔹 방합 (3개 완성 시 → 같은 국으로도 인정)
    if (hasBang({'亥','子','丑'})) {
      bangGroups.add('수방합');
      juGroups.add('수국'); // ⭐ 핵심
    }

    if (hasBang({'寅','卯','辰'})) {
      bangGroups.add('목방합');
      juGroups.add('목국');
    }

    if (hasBang({'巳','午','未'})) {
      bangGroups.add('화방합');
      juGroups.add('화국');
    }

    if (hasBang({'申','酉','戌'})) {
      bangGroups.add('금방합');
      juGroups.add('금국');
    }


    /// 통근
    final stemRootCount = <String, int>{};
    for (final stem in stems) {
      stemRootCount[stem] = earthlyBranches
          .where((b) => b.hiddenStems?.contains(stem) ?? false)
          .where((b) => branches.contains(b.name))
          .length;
    }

    return SajuAnalysis(
      dayStem: saju.dayStem,
      monthBranch: saju.monthBranch,
      branches: branches,
      hiddenStems: hiddenStems,
      juGroups: juGroups,
      bangGroups: bangGroups,
      exposedStems: exposedStems,
      stemRootCount: stemRootCount,
    );
  }
}
