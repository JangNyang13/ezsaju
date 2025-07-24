import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ManseLoader {
  static Map<String, Map<String, dynamic>>? _cache;

  /// key = yyyyMMdd
  static Future<Map<String, Map<String, dynamic>>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(
        'assets/data/manse_1900_2100.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _cache = {
      for (var e in list)
        '${e['cd_sy']}${e['cd_sm'].toString().padLeft(2, '0')}${e['cd_sd'].toString().padLeft(2, '0')}':
        e
    };
    return _cache!;
  }
}
