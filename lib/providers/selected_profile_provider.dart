import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';

/// 현재 선택된 프로필을 저장하는 Provider
final selectedProfileProvider = StateProvider<Profile?>((ref) => null);

/// 선택된 프로필을 SharedPreferences에 저장 / 복원하는 헬퍼
class SelectedProfileManager {
  static const _key = 'selected_profile_name';
  static final _profileService = ProfileService();

  /// ✅ 저장
  static Future<void> save(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, profile.name);
  }

  /// ✅ 불러오기
  static Future<Profile?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_key);
    if (savedName == null) return null;

    final profiles = await _profileService.loadProfiles();
    try {
      return profiles.firstWhere((p) => p.name == savedName);
    } catch (_) {
      return null;
    }
  }

  /// ✅ 선택 해제
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
