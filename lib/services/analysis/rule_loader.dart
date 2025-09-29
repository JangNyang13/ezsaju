import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class RuleLoader {
  static Future<Map<String, dynamic>> loadWeights() async {
    final jsonStr = await rootBundle.loadString('assets/data/analysis/weights.json');
    return jsonDecode(jsonStr);
  }

  static Future<Map<String, dynamic>> loadPatterns() async {
    final jsonStr = await rootBundle.loadString('assets/data/analysis/patterns.json');
    return jsonDecode(jsonStr);
  }

  static Future<Map<String, dynamic>> loadNarrations() async {
    final jsonStr = await rootBundle.loadString('assets/data/analysis/narrations.json');
    return jsonDecode(jsonStr);
  }
}
