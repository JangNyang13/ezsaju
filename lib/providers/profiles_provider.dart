// --------------------------------------------------------------
// Riverpod 상태 관리: 저장된 프로필 목록 + 현재 선택 프로필 인덱스 (영구저장)
// --------------------------------------------------------------
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/profiles_repository.dart';
import '../models/user_profile.dart';

/* ─── 프로필 목록 프로바이더 (Async) ─── */
final profilesProvider = FutureProvider<List<UserProfile>>((ref) async {
  return ProfilesRepository.instance.fetchAll();
});

/* ─── 현재 선택 인덱스 (SharedPreferences로 영구저장) ─── */
final selectedProfileIndexProvider =
StateNotifierProvider<SelectedProfileIndexNotifier, int>((ref) {
  return SelectedProfileIndexNotifier();
});

class SelectedProfileIndexNotifier extends StateNotifier<int> {
  static const _key = "selected_profile_index";

  SelectedProfileIndexNotifier() : super(0) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(_key) ?? 0;
  }

  Future<void> setIndex(int idx) async {
    state = idx;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, idx);
  }
}

/* ─── 현재 선택된 프로필 (nullable) ─── */
final currentProfileProvider = Provider<UserProfile?>((ref) {
  final asyncProfiles = ref.watch(profilesProvider);
  final idx = ref.watch(selectedProfileIndexProvider);

  return asyncProfiles.when(
    data: (list) => (idx < list.length) ? list[idx] : null,
    loading: () => null,
    error: (_, __) => null,
  );
});
