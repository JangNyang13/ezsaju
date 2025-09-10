import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profiles_provider.dart';
import '../repositories/profiles_repository.dart';
import 'profile_form_screen.dart';
import 'memo_archive_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _maxSlots = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfiles = ref.watch(profilesProvider);
    final selIdx = ref.watch(selectedProfileIndexProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        titleTextStyle: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(color: Colors.black87),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: const Text('설정'),
      ),
      body: asyncProfiles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('로딩 실패')),
        data: (list) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── 프로필 슬롯 영역 ──
            Row(
              children: List.generate(_maxSlots, (i) {
                final filled = i < list.length;
                final isSel = i == selIdx;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => filled
                        ? _showProfileMenu(context, ref, i, list[i])
                        : _addNewProfile(context, ref, list.length),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      height: 120,
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
                          Text(list[i].name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            '${list[i].birth.year}.${list[i].birth.month.toString().padLeft(2, '0')}.${list[i].birth.day.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      )
                          : const Icon(Icons.add, size: 36, color: Colors.grey),
                    ),
                  ),
                );
              }),
            ),


            const SizedBox(height: 32),

            // ────────────── 운세 보관함 진입 버튼 ──────────────────────────────
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("운세 보관함"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MemoArchiveScreen()),
                );
              },
            ),
          ],
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
                ref.read(selectedProfileIndexProvider.notifier).setIndex(idx); // ✅ 저장
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
                  ref.read(selectedProfileIndexProvider.notifier).setIndex(0);
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
