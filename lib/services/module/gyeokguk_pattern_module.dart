import '../../models/saju_data.dart';
import 'shibsung_module.dart';

class GyeokgukPatternModule {
  /// 십성 그룹 매핑
  static const tenGodGroups = {
    '인성': ['정인', '편인'],
    '재성': ['정재', '편재'],
    '관성': ['정관', '편관'],
    '식신': ['식신'],
    '상관': ['상관'],
    '비겁': ['비견', '겁재'],

    // 복합 조건
    '식신_또는_상관': ['식신', '상관'],
    '식신_또는_인성': ['식신', '정인', '편인'],
  };


  /// 특정 십성 그룹이 조건 수 이상인지 확인
  static bool hasGroup(Map<String, int> counts, String group, String cond) {
    final list = tenGodGroups[group];
    if (list == null) return false;

    final threshold = int.parse(cond.replaceAll(">=", ""));

    int total = 0;
    for (var g in list) {
      total += counts[g] ?? 0;
    }

    return total >= threshold;
  }

  /// 인성이 천간에 투출했는가?
  static bool hasStemGroup(SajuData saju, String group) {
    final stems = [
      saju.yearStem,
      saju.monthStem,
      saju.dayStem,
      saju.hourStem,
    ];

    final list = tenGodGroups[group] ?? [];
    final day = saju.dayStem;

    for (final stem in stems) {
      final same = ShibsungModule.isYang(day) == ShibsungModule.isYang(stem);
      final ten = ShibsungModule.getTenGod(day, stem, same);
      if (list.contains(ten)) return true;
    }
    return false;
  }

  /// 양인(羊刃)
  static bool hasYangIn(SajuData saju) {
    const yangInMap = {
      '甲': '卯',
      '丙': '午',
      '戊': '午',
      '庚': '酉',
      '壬': '子',
    };
    final target = yangInMap[saju.dayStem];
    return (saju.dayBranch == target || saju.hourBranch == target);
  }

  /// 격국 + 사주 전체 십성을 기반으로 확장 패턴 판단
  static List<String> analyze(String gyeok, SajuData saju) {
    final all = ShibsungModule.analyzeAll(saju);
    final counts = ShibsungModule.countTenGods(all['전체']!);

    final result = <String>[];

    switch (gyeok) {
    // -----------------------------------------------------
      case '정관격':
        if (hasGroup(counts, '재성', '>=1') &&
            hasGroup(counts, '인성', '>=1')) {
          result.add('관봉재인');
        }
        break;

    // -----------------------------------------------------
      case '재격':
        if (hasGroup(counts, '관성', '>=1')) result.add('재생관왕');
        if (hasGroup(counts, '식신', '>=1')) result.add('재봉식생');
        if (hasStemGroup(saju, '인성')) result.add('재격투인');
        break;

    // -----------------------------------------------------
      case '인수격':
        if (hasGroup(counts, '관성', '>=1')) result.add('인경봉살');
        if (hasGroup(counts, '식신', '>=1') || hasGroup(counts, '상관', '>=1')) {
          result.add('인용식상');
        }
        if (hasGroup(counts, '재성', '>=1')) result.add('인다용재');
        break;

    // -----------------------------------------------------
      case '식신격':
        if (hasGroup(counts, '재성', '>=1')) result.add('식신생재');
        if (hasGroup(counts, '관성', '>=1') &&
            hasGroup(counts, '관성', '>=1')) {
          result.add('식신제살');
        }
        if (hasGroup(counts, '관성', '>=1') &&
            hasGroup(counts, '인성', '>=1')) {
          result.add('기식취살');
        }
        break;

    // -----------------------------------------------------
      case '편관격':
        if (hasGroup(counts, '식신', '>=1')) result.add('살용식제');
        if (hasGroup(counts, '인성', '>=1')) result.add('살격용인');
        if (hasYangIn(saju)) result.add('살격봉인');
        break;

    // -----------------------------------------------------
      case '상관격':
        if (hasGroup(counts, '재성', '>=1')) result.add('상관상재');
        if (hasGroup(counts, '인성', '>=1')) result.add('상관패인');
        if (hasGroup(counts, '관성', '>=1')) result.add('상관대살');
        break;

    // -----------------------------------------------------
      case '양인격':
        if (hasGroup(counts, '관성', '>=1')) result.add('양인로살');
        if (hasGroup(counts, '정관', '>=1')) result.add('양인로관'); // ❗ 정관 단독
        break;

    // -----------------------------------------------------
      case '록겁격':
        if (hasGroup(counts, '정관', '>=1') &&
            hasGroup(counts, '재성', '>=1') &&
            hasGroup(counts, '인성', '>=1')) {
          result.add('록겁용관');
        }
        if (hasGroup(counts, '관성', '>=1') &&    // 편관 포함
            (hasGroup(counts, '식신', '>=1') ||
                hasGroup(counts, '인성', '>=1'))) {
          result.add('록겁용살');
        }
        if (hasGroup(counts, '재성', '>=1') &&
            (hasGroup(counts, '식신', '>=1') ||
                hasGroup(counts, '상관', '>=1'))) {
          result.add('록겁용재');
        }
        break;
    }

    return result;
  }
}
