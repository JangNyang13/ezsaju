import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/module/goongtong/joyong_rule_loader.dart';
import '../services/module/goongtong/joyong_rule.dart';

final joyongRuleProvider =
FutureProvider<Map<String, Map<String, JoyongRule>>>((ref) async {
  return await JoyongRuleLoader.load();
});
