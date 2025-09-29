import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import '../../models/day_fortune.dart';
import '../../models/saju_data.dart';
import 'saju_analyzer.dart';

/// 오늘/내일 일진 평가기 (궁통보감·적천수 원리 반영)
class DailyFortuneEvaluator {
  late final Map<String, dynamic> rules;
  late final Map<String, dynamic> narrations;

  DailyFortuneEvaluator._();

  static Future<DailyFortuneEvaluator> create() async {
    final eval = DailyFortuneEvaluator._();
    eval.rules =
        jsonDecode(await rootBundle.loadString('assets/data/analysis/weights.json'));
    eval.narrations =
        jsonDecode(await rootBundle.loadString('assets/data/analysis/narrations.json'));
    return eval;
  }

  DayFortune evaluate(SajuData chart, DateTime date) {
    final analyzer = SajuAnalyzer(chart);

    int score = 0;
    List<String> tags = [];

    final daily = rules["daily"];

    // 1. 부족 오행 보완
    for (final e in analyzer.lacks) {
      if (dateElement(date) == e) {
        score += (daily["element_supply"]["lack_bonus"] as num).toInt();
        tags.add("부족한 $e 補充");
      }
    }

    // 2. 과다 오행 증폭
    for (final e in analyzer.excess) {
      if (dateElement(date) == e) {
        score += (daily["element_supply"]["excess_penalty"] as num).toInt();
        tags.add("과다한 $e 증폭");
      }
    }

    // 3. 월지와 오늘 일진 합/충
    if (_isChong(analyzer.monthBranch, date)) {
      score += (daily["relations"]["chong"] as num).toInt();
      tags.add("월지와 충");
    }
    if (_isHap(analyzer.monthBranch, date)) {
      score += (daily["relations"]["hap"] as num).toInt();
      tags.add("월지와 합");
    }

    // 4. 십성 매칭
    final tenGod = analyzer.tenGodOf(dateElement(date));
    if (analyzer.dayElement.isNotEmpty) {
      if (analyzer.countOf(analyzer.dayElement) >= 3) {
        // 신강
        final val = (daily["ten_god_match"]["strong"][tenGod] as num?)?.toInt();
        if (val != null) {
          score += val;
          tags.add("십성 $tenGod 도움");
        }
      } else if (analyzer.countOf(analyzer.dayElement) <= 1) {
        // 신약
        final val = (daily["ten_god_match"]["weak"][tenGod] as num?)?.toInt();
        if (val != null) {
          score += val;
          tags.add("십성 $tenGod 도움");
        }
      }
    }

    final grade = _toGrade(score, daily["thresholds"]);
    final message = narrations["daily"][grade][0];

    return DayFortune(
      date: date,
      score: score,
      grade: grade,
      tags: tags,
      message: message,
    );
  }

  /// 오늘의 일진 오행 (간단 버전, 실제는 간지 변환 필요)
  String dateElement(DateTime date) {
    // TODO: 실제 간지 변환 로직 필요
    return "목";
  }

  bool _isChong(String branch, DateTime date) {
    // TODO: 지지 충 관계 계산
    return false;
  }

  bool _isHap(String branch, DateTime date) {
    // TODO: 지지 합 관계 계산
    return false;
  }

  String _toGrade(int score, Map<String, dynamic> t) {
    if (score >= (t["very_good"] as num).toInt()) return "아주 좋은 날";
    if (score >= (t["good"] as num).toInt()) return "좋은 날";
    if (score >= (t["bad"] as num).toInt()) return "복합적인 날";
    if (score >= (t["very_bad"] as num).toInt()) return "안 좋은 날";
    return "아주 안 좋은 날";
  }
}
