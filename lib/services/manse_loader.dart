// lib/services/manse_loader.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ManseLoader {
  static Map<String, Map<String, dynamic>>? _cache;

  /// yyyyMMdd → record
  static Future<Map<String, Map<String, dynamic>>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/manse_1900_2100.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _cache = {
      for (var e in list)
        '${e['cd_sy']}${e['cd_sm'].toString().padLeft(2, '0')}${e['cd_sd'].toString().padLeft(2, '0')}':
        e
    };
    return _cache!;
  }

  /* ────────────────────────── 추가 부분 ────────────────────────── */

  static String _key(int y, int m, int d) =>
      '$y${m.toString().padLeft(2, '0')}${d.toString().padLeft(2, '0')}';

  /// 단일 일자 레코드
  static Future<Map<String, dynamic>?> get(DateTime date) async {
    final cache = await load();
    return cache[_key(date.year, date.month, date.day)];
  }

  /// 월별 레코드 리스트 (1 ~ 31 정렬)
  static Future<List<Map<String, dynamic>>> fetchMonth(
      int year, int month) async {
    final cache = await load();
    final prefix = '$year${month.toString().padLeft(2, '0')}';
    final list = cache.entries
        .where((e) => e.key.startsWith(prefix))
        .map((e) => e.value)
        .toList();

    list.sort(
            (a, b) => int.parse(a['cd_sd']).compareTo(int.parse(b['cd_sd']))); // 1일→…
    return list;
  }
}
