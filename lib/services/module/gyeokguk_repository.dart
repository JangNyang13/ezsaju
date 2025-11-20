import 'dart:convert';
import 'package:flutter/services.dart';

/// 격국 + 패턴 설명을 제공하는 Repository
class GyeokgukRepository {
  static Map<String, dynamic>? _cache;

  /// 최초 1회 JSON 로드
  static Future<void> load() async {
    if (_cache != null) return; // 이미 로드됨
    final jsonString =
    await rootBundle.loadString('assets/data/gyeokguk_descriptions.json');
    _cache = json.decode(jsonString);
  }

  /// 격국 설명
  static String gyeok(String name) {
    if (_cache == null) return '';
    return _cache?['gyeokguk']?[name]?['description'] ?? '';
  }

  /// 패턴 설명
  static String pattern(String name) {
    if (_cache == null) return '';
    return _cache?['patterns']?[name] ?? '';
  }

  /// 통합 호출: 격국 + 패턴 둘 다 처리
  static String text(String name) {
    // 격국인지 먼저 확인
    final g = gyeok(name);
    if (g.isNotEmpty) return g;

    // 패턴인지 확인
    final p = pattern(name);
    if (p.isNotEmpty) return p;

    return '';
  }
}
