// lib/providers/profiles_provider.dart
// --------------------------------------------------------------
// Riverpod 상태 관리: 저장된 프로필 목록 + 현재 선택 프로필 인덱스
// --------------------------------------------------------------
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/profiles_repository.dart';
import '../models/user_profile.dart';

/* ─── 프로필 목록 프로바이더 (Async) ─── */
final profilesProvider = FutureProvider<List<UserProfile>>((ref) async {
  return ProfilesRepository.instance.fetchAll();
});

/* ─── 현재 선택 인덱스 (0 기본) ─── */
final selectedProfileIndexProvider = StateProvider<int>((ref) => 0);

/* ─── 현재 선택된 프로필 (nullable) ─── */
final currentProfileProvider = Provider<UserProfile?>(
      (ref) {
    final asyncProfiles = ref.watch(profilesProvider);
    final idx = ref.watch(selectedProfileIndexProvider);

    return asyncProfiles.when(
      data: (list) => (idx < list.length) ? list[idx] : null,
      loading: () => null,     // ← 매개변수 없는 형태로 수정
      error: (_, __) => null,
    );
  },
);
