//saju_analyzer.dart
import '../../models/saju_data.dart';
import '../../utils/elemental_relations.dart';

/// SajuData를 기반으로 오행/십성/월지 등을 분석하는 헬퍼
class SajuAnalyzer {
  final SajuData chart;

  SajuAnalyzer(this.chart);

  /// 일간(天干)
  String get dayMaster => chart.dayGan;

  /// 일간 오행
  String get dayElement => stemToElement[dayMaster] ?? '-';

  /// 월지(地支)
  String get monthBranch => chart.monthZhi;

  /// 월지 오행
  String get monthElement => branchToElement[monthBranch] ?? '-';

  /// 모든 천간 리스트 (연/월/일/시)
  List<String> get allGans {
    final out = [chart.yearGan, chart.monthGan, chart.dayGan];
    if (chart.hasHour) out.add(chart.hourGan);
    return out;
  }

  /// 모든 지지 리스트 (연/월/일/시)
  List<String> get allZhis {
    final out = [chart.yearZhi, chart.monthZhi, chart.dayZhi];
    if (chart.hasHour) out.add(chart.hourZhi);
    return out;
  }

  /// 오행 카운트 (천간 기준)
  Map<String, int> get elementCounts {
    final counts = <String, int>{};
    for (final e in chart.elements) {
      counts[e] = (counts[e] ?? 0) + 1;
    }
    return counts;
  }

  /// 특정 오행 개수
  int countOf(String element) => elementCounts[element] ?? 0;

  /// 부족/과다 오행 (daily fortune 평가용)
  List<String> get lacks {
    final out = <String>[];
    for (final e in ['목', '화', '토', '금', '수']) {
      if (countOf(e) == 0) out.add(e);
    }
    return out;
  }

  List<String> get excess {
    final out = <String>[];
    for (final e in ['목', '화', '토', '금', '수']) {
      if (countOf(e) >= 3) out.add(e);
    }
    return out;
  }

  /// 월지 기준 계절 (궁통보감 계절 보정용)
  String get season {
    switch (monthBranch) {
      case '寅':
      case '卯':
      case '辰':
        return "spring";
      case '巳':
      case '午':
      case '未':
        return "summer";
      case '申':
      case '酉':
      case '戌':
        return "autumn";
      case '亥':
      case '子':
      case '丑':
        return "winter";
      default:
        return "unknown";
    }
  }

  /// 십성 계산: 일간 오행과 다른 오행의 관계
  String tenGodOf(String otherElement) {
    final rel = fiveElementRelation[dayElement]?[otherElement];
    return rel ?? "기타";
  }
}
