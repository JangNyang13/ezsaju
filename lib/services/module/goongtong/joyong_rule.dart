// lib/services/module/goongtong/joyong_rule.dart

class JoyongRule {
  final List<String> mainYong;
  final List<String> subYong;

  JoyongRule({
    required this.mainYong,
    required this.subYong,
  });

  factory JoyongRule.fromJson(Map<String, dynamic> json) {
    return JoyongRule(
      mainYong: List<String>.from(json['main']),
      subYong: List<String>.from(json['sub']),
    );
  }
}

