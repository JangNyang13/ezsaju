import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';
import 'theme_provider.dart'; // profilesProvider 사용

class SelectedProfileNotifier extends StateNotifier<Profile?> {
  SelectedProfileNotifier(this.ref) : super(null) {
    _load(); // 앱 실행 시 자동 복원
  }

  final Ref ref;
  static const _key = 'selected_profile_id';

  /// ✅ 앱 실행 시 저장된 프로필 불러오기
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_key);
    if (savedId == null) return;

    // 저장된 ID와 일치하는 프로필을 찾아서 state에 설정
    final profiles = await ref.read(profilesProvider.future);
    final match = profiles.where((p) => p.id == savedId);
    if (match.isNotEmpty) {
      state = match.first;
    }
  }

  /// ✅ 프로필 선택 시 SharedPreferences에 저장
  Future<void> select(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, profile.id);
    state = profile;
  }

  /// ✅ 선택 해제
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = null;
  }
}

/// ✅ 전역 provider
final selectedProfileProvider =
StateNotifierProvider<SelectedProfileNotifier, Profile?>((ref) {
  return SelectedProfileNotifier(ref);
});
