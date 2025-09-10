// lib/repositories/memo_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MemoRepository {
  static const _key = "daily_memos";

  /// 저장된 메모 불러오기
  static Future<List<Map<String, dynamic>>> fetchAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.cast<Map<String, dynamic>>();
  }

  /// 새 메모 추가
  static Future<void> addMemo({
    required String date,         // 날짜 키
    required String yearGanZhi,   // 년주
    required String monthGanZhi,  // 월주
    required String dayGanZhi,    // 일주 (오늘의 일진)
    String? hourGanZhi,           // 시주 (시간 모를 경우 null 허용)
    required String feeling,      // 기분 단계
    required String memo,         // 메모
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await fetchAll();

    list.add({
      "date": date,
      "yearGanZhi": yearGanZhi,
      "monthGanZhi": monthGanZhi,
      "dayGanZhi": dayGanZhi,
      if (hourGanZhi != null) "hourGanZhi": hourGanZhi,
      "feeling": feeling,
      "memo": memo,
    });

    await prefs.setString(_key, jsonEncode(list));
  }

  /// 메모 삭제
  static Future<void> deleteMemo(Map<String, dynamic> target) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await fetchAll();

    list.removeWhere((m) =>
    m["date"] == target["date"] &&
        m["feeling"] == target["feeling"] &&
        m["memo"] == target["memo"]);

    await prefs.setString(_key, jsonEncode(list));
  }

}

