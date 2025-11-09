import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saju_data.dart';

class SajuStorage {
  static const String _key = 'saved_saju_data_v1';

  /// 사주 저장
  static Future<void> save(SajuData saju) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(saju.toJson()));
  }

  /// 사주 불러오기
  static Future<SajuData?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return null;
    return SajuData.fromJson(jsonDecode(data));
  }

  /// 사주 삭제
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
