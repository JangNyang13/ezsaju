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

  /// 십성 판별 (천간-천간 기준)
  static String getTenGod(String dayStem, String targetStem, bool sameYinYang) {
    final dayElem = ganToElement[dayStem]!;
    final targetElem = ganToElement[targetStem]!;
    // 1️⃣ 비견/겁재
    if (dayElem == targetElem) {
      return sameYinYang ? '비견' : '겁재';
    }
    // 2️⃣ 식신/상관 (내가 생하는 오행)
    if (generating[dayElem] == targetElem) {
      return sameYinYang ? '식신' : '상관';
    }
    // 3️⃣ 인성 (상대가 나를 생함)
    if (generating[targetElem] == dayElem) {
      return sameYinYang ? '편인' : '정인';
    }
    // 4️⃣ 재성 (내가 극하는 오행)
    if (overcoming[dayElem] == targetElem) {
      return sameYinYang ? '편재' : '정재';
    }
    // 5️⃣ 관성 (상대가 나를 극함)
    if (overcoming[targetElem] == dayElem) {
      return sameYinYang ? '편관' : '정관';
    }
    return '무관계';
  }


  /// 천간의 음양 구분
  static bool isYang(String gan) {
    const yang = ['甲', '丙', '戊', '庚', '壬'];
    return yang.contains(gan);
  }

  /// 전체 십성 해석 (천간 + 지지)
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
      // ✅ 천간일 경우
      if (ganToElement.containsKey(value)) {
        final sameYinYang = isYang(dayStem) == isYang(value);
        results[key] = getTenGod(dayStem, value, sameYinYang);
      }
      // ✅ 지지일 경우 (지장간 기반 계산)
      else {
        final branch = earthlyBranches.firstWhere((e) => e.name == value);
        final buffer = <String>[];

        for (final hidden in branch.hiddenStems ?? []) {
          final sameYinYang = isYang(dayStem) == isYang(hidden);
          buffer.add(getTenGod(dayStem, hidden, sameYinYang));
        }

        // 🎯 대표 십성 결정 로직
        results[key] = _dominantTenGod(buffer);
      }
    });

    return results;
  }

  /// 지장간 여러 개일 경우 대표 십성 선택
  static String _dominantTenGod(List<String> list) {
    if (list.isEmpty) return '무관계';
    // 대표 간선(첫 번째 지장간)을 우선으로
    // (寅·巳·申 등은 첫 번째가 주기둥, 다음은 보좌)
    return list.first;
  }
}
