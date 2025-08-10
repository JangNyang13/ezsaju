// lib/screens/settings_screen.dart
// --------------------------------------------------------------
// 설정 화면 – 프로필 3칸 슬롯 (직관적 메뉴)
// * 빈 칸   : + 탭하면 새 프로필 추가
// * 채워진 칸 : 탭 → 하단 메뉴 [선택·수정·삭제]
// --------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profiles_provider.dart';
import '../repositories/profiles_repository.dart';
import 'profile_form_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _maxSlots = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfiles = ref.watch(profilesProvider);
    final selIdx = ref.watch(selectedProfileIndexProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // 가운데 정렬
        backgroundColor: Colors.transparent, // 투명
        elevation: 0,
        foregroundColor: Colors.black87, // ← 글자·아이콘 색 한 번에 지정
        titleTextStyle: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(color: Colors.black87),
        // (필요 시) 글자 스타일 세부 조정
        title: const Text('설정'),
      ),
      body: asyncProfiles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('로딩 실패')),
        data: (list) => Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_maxSlots, (i) {
              final filled = i < list.length;
              final isSel = i == selIdx;

              return GestureDetector(
                onTap: () => filled
                    ? _showProfileMenu(context, ref, i, list[i])
                    : _addNewProfile(context, ref, list.length),
                child: Container(
                  width: 110,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSel
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                    color: filled ? Colors.white : Colors.grey.shade100,
                  ),
                  child: filled
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              list[i].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${list[i].birth.year}.${list[i].birth.month.toString().padLeft(2, '0')}.${list[i].birth.day.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      : const Icon(Icons.add, size: 36, color: Colors.grey),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  /* ─── Helpers ─── */
  Future<void> _addNewProfile(
    BuildContext ctx,
    WidgetRef ref,
    int currentCount,
  ) async {
    if (currentCount >= _maxSlots) return;
    await Navigator.push(
      ctx,
      MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
    );
    if (ctx.mounted) ref.invalidate(profilesProvider);
  }

  void _showProfileMenu(BuildContext ctx, WidgetRef ref, int idx, profile) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('프로필 선택'),
              onTap: () {
                Navigator.pop(bCtx);
                ref.read(selectedProfileIndexProvider.notifier).state = idx;
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('프로필 수정'),
              onTap: () async {
                Navigator.pop(bCtx);
                await Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProfileFormScreen(profile: profile, index: idx),
                  ),
                );
                if (ctx.mounted) ref.invalidate(profilesProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('프로필 삭제', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(bCtx);
                _confirmDelete(ctx, ref, idx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, WidgetRef ref, int idx) {
    showDialog(
      context: ctx,
      builder: (dCtx) => AlertDialog(
        title: const Text('프로필 삭제'),
        content: const Text('프로필을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dCtx);
              await ProfilesRepository.instance.deleteProfile(idx);
              if (ctx.mounted) {
                ref.invalidate(profilesProvider);
                final len = await ProfilesRepository.instance.fetchAll().then(
                  (l) => l.length,
                );
                if (ref.read(selectedProfileIndexProvider) >= len) {
                  ref.read(selectedProfileIndexProvider.notifier).state = 0;
                }
              }
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
