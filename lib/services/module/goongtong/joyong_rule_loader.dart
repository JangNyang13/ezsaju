import 'dart:convert';
import 'package:flutter/services.dart';
import 'joyong_rule.dart';

class JoyongRuleLoader {
  static Map<String, Map<String, JoyongRule>>? _cache;

  static Future<Map<String, Map<String, JoyongRule>>> load() async {
    if (_cache != null) return _cache!;

    final jsonStr =
    await rootBundle.loadString('assets/data/joyong_rules.json');
    final Map<String, dynamic> json = jsonDecode(jsonStr);

    final result = <String, Map<String, JoyongRule>>{};

    json.forEach((dayStem, months) {
      result[dayStem] = {};
      (months as Map<String, dynamic>).forEach((month, ruleJson) {
        result[dayStem]![month] =
            JoyongRule.fromJson(ruleJson);
      });
    });

    _cache = result;
    return result;
  }
}
