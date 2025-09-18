import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/profiles_repository.dart';
import '../models/user_profile.dart';

// ── 프로필 목록(Async)
final profilesProvider = FutureProvider<List<UserProfile>>((ref) async {
  return ProfilesRepository.instance.fetchAll();
});

// ── 선택 인덱스(영구 저장) - v3: Notifier/NotifierProvider 사용
final selectedProfileIndexProvider =
NotifierProvider<SelectedProfileIndexNotifier, int>(
  SelectedProfileIndexNotifier.new,
);

class SelectedProfileIndexNotifier extends Notifier<int> {
  static const _key = 'selected_profile_index';

  @override
  int build() {
    // 초기값은 0으로 두고, 비동기 로드는 뒤에서 반영
    _load();
    return 0;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt(_key);
    if (savedIndex != null) {
      state = savedIndex;
    }
  }

  Future<void> setIndex(int idx) async {
    state = idx;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, idx);
  }
}

// ── 현재 선택된 프로필(파생 상태)
final currentProfileProvider = Provider<UserProfile?>((ref) {
  final asyncProfiles = ref.watch(profilesProvider);
  final idx = ref.watch(selectedProfileIndexProvider);

  return asyncProfiles.maybeWhen(
    data: (list) => (idx >= 0 && idx < list.length) ? list[idx] : null,
    orElse: () => null,
  );
});
