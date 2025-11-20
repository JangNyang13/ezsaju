import '../../models/saju_data.dart';
import '../../models/stem_branch.dart';

/// 십성 계산 (일간 기준, 지지의 지장간 포함)
class ShibsungModule {
  /// 각 천간에 대응하는 오행
  static const ganToElement = {
    '甲': '목', '乙': '목',
    '丙': '화', '丁': '화',
    '戊': '토', '己': '토',
    '庚': '금', '辛': '금',
    '壬': '수', '癸': '수',
  };

  /// 오행 상생/상극 관계
  static const generating = {
    '목': '화',
    '화': '토',
    '토': '금',
    '금': '수',
    '수': '목',
  };

  static const overcoming = {
    '목': '토',
    '화': '금',
    '토': '수',
    '금': '목',
    '수': '화',
  };

  /// 천간 음양
  static bool isYang(String gan) {
    const yang = ['甲', '丙', '戊', '庚', '壬'];
    return yang.contains(gan);
  }

  /// 십성 판별 (천간-천간)
  static String getTenGod(String dayStem, String targetStem, bool sameYinYang) {
    final dayElem = ganToElement[dayStem]!;
    final targetElem = ganToElement[targetStem]!;

    // 1️⃣ 비견 / 겁재
    if (dayElem == targetElem) return sameYinYang ? '비견' : '겁재';

    // 2️⃣ 식신 / 상관
    if (generating[dayElem] == targetElem) {
      return sameYinYang ? '식신' : '상관';
    }

    // 3️⃣ 인성
    if (generating[targetElem] == dayElem) {
      return sameYinYang ? '편인' : '정인';
    }

    // 4️⃣ 재성
    if (overcoming[dayElem] == targetElem) {
      return sameYinYang ? '편재' : '정재';
    }

    // 5️⃣ 관성
    if (overcoming[targetElem] == dayElem) {
      return sameYinYang ? '편관' : '정관';
    }

    return '무관계';
  }

  // ----------------------------------------------------------------------
  // 기존 interpret() = "대표 십성"만 제공 → 기존 UI 유지용
  // ----------------------------------------------------------------------
  static Map<String, String> interpret(SajuData saju) {
    final results = <String, String>{};
    final dayStem = saju.dayStem;

    final pairs = {
      '년간': saju.yearStem,
      '월간': saju.monthStem,
      '일간': saju.dayStem,
      '시간': saju.hourStem,
      '년지': saju.yearBranch,
      '월지': saju.monthBranch,
      '일지': saju.dayBranch,
      '시지': saju.hourBranch,
    };

    pairs.forEach((key, value) {
      // 🌟 천간
      if (ganToElement.containsKey(value)) {
        final sameYinYang = isYang(dayStem) == isYang(value);
        results[key] = getTenGod(dayStem, value, sameYinYang);
      }
      // 🌟 지지 (지장간)
      else {
        final branch = earthlyBranches.firstWhere((e) => e.name == value);
        final list = getHiddenTenGods(dayStem, branch.hiddenStems ?? []);
        results[key] = _dominantTenGod(list);
      }
    });

    return results;
  }

  /// 지장간 십성 리스트
  static List<String> getHiddenTenGods(String dayStem, List<String> hidden) {
    final list = <String>[];
    for (final h in hidden) {
      final sameYY = isYang(dayStem) == isYang(h);
      list.add(getTenGod(dayStem, h, sameYY));
    }
    return list;
  }

  /// 대표 십성 = 첫 번째 지장간 우선
  static String _dominantTenGod(List<String> list) {
    if (list.isEmpty) return '무관계';
    return list.first;
  }

  // ----------------------------------------------------------------------
  // ⭐ 격국 확장용: 전체 십성 분석 (천간/지지/전체)
  // ----------------------------------------------------------------------
  static Map<String, List<String>> analyzeAll(SajuData saju) {
    final dayStem = saju.dayStem;
    final result = <String, List<String>>{
      '천간': [],
      '지지': [],
      '전체': [],
    };

    // 🌟 천간 4개
    final stemList = [
      saju.yearStem,
      saju.monthStem,
      saju.dayStem,
      saju.hourStem,
    ];

    for (final stem in stemList) {
      final same = isYang(dayStem) == isYang(stem);
      final ten = getTenGod(dayStem, stem, same);
      result['천간']!.add(ten);
      result['전체']!.add(ten);
    }

    // 🌟 지지(지장간 포함)
    final branchList = [
      saju.yearBranch,
      saju.monthBranch,
      saju.dayBranch,
      saju.hourBranch,
    ];

    for (final branch in branchList) {
      final e = earthlyBranches.firstWhere((b) => b.name == branch);
      final tens = getHiddenTenGods(dayStem, e.hiddenStems ?? []);
      result['지지']!.addAll(tens);
      result['전체']!.addAll(tens);
    }

    return result;
  }

  // ----------------------------------------------------------------------
  // ⭐ 십성 개수 분석 (재성 몇 개? 관성 몇 개? 인성 몇 개?)
  // ----------------------------------------------------------------------
  static Map<String, int> countTenGods(List<String> list) {
    final result = <String, int>{};
    for (final t in list) {
      result[t] = (result[t] ?? 0) + 1;
    }
    return result;
  }
}
