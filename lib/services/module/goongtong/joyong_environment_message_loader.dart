import 'dart:convert';
import 'package:flutter/services.dart';

class JoyongEnvironmentMessageLoader {
  static Map<String, String>? _cache;

  static Future<Map<String, String>> load() async {
    if (_cache != null) return _cache!;

    final jsonStr = await rootBundle.loadString(
      'assets/data/joyong_environment_messages.json',
    );

    final Map<String, dynamic> raw = jsonDecode(jsonStr);
    _cache = raw.map((k, v) => MapEntry(k, v.toString()));
    return _cache!;
  }
}
