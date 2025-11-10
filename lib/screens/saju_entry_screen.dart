import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';
import '../providers/theme_provider.dart';
import '../providers/selected_profile_provider.dart';
import '../constants/app_colors.dart';
import 'profile_form_screen.dart';
import 'saju_viewer_screen.dart';

class SajuEntryScreen extends ConsumerStatefulWidget {
  const SajuEntryScreen({super.key});

  @override
  ConsumerState<SajuEntryScreen> createState() => _SajuEntryScreenState();
}

class _SajuEntryScreenState extends ConsumerState<SajuEntryScreen> {
  String _searchQuery = '';

  // ----------------------------
  // ✅ 프로필 추가
  void _addProfile() async {
    final newProfile = await Navigator.push<Profile?>(
      context,
      MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
    );

    if (newProfile != null) {
      // Provider가 즉시 UI를 업데이트함
      await ref.read(profilesProvider.notifier).addProfile(newProfile);
    }
  }

// ✅ 프로필 수정
  void _editProfile(Profile profile) async {
    final edited = await Navigator.push<Profile?>(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileFormScreen(),
        settings: RouteSettings(arguments: profile),
      ),
    );

    if (edited != null) {
      // 업데이트만 호출하면 자동 반영됨
      await ref.read(profilesProvider.notifier).updateProfile(edited);
    }
  }

// ✅ 프로필 삭제
  void _deleteProfile(Profile profile) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('삭제 확인'),
        content: Text('${profile.name} 프로필을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              // 삭제 호출 후 자동 반영됨
              await ref.read(profilesProvider.notifier).deleteProfile(profile.id);
              if (!mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  void _openProfile(Profile p) {
    ref.read(selectedProfileProvider.notifier).select(p);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SajuViewerScreen(profileOverride: p)),
    );
  }

  void _openQuickInput() async {
    final tempProfile = await Navigator.push<Profile?>(
      context,
      MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
    );

    if (tempProfile != null) {
      await ref.read(profilesProvider.notifier).addProfile(tempProfile);
      ref.read(selectedProfileProvider.notifier).select(tempProfile);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SajuViewerScreen(profileOverride: tempProfile),
        ),
      );
    }
  }

  // ----------------------------
  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(profilesProvider);
    final profiles = profilesAsync.value ?? [];

    final filteredProfiles = profiles
        .where((p) => p.name.contains(_searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('사주 조회'),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildQuickInputCard(),
            const SizedBox(height: 24),

            // 🔍 검색창
            TextField(
              decoration: InputDecoration(
                hintText: '프로필 검색',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _searchQuery = v.trim()),
            ),
            const SizedBox(height: 6),

            // ✅ 목록
            Expanded(
              child: profilesAsync.when(
                data: (_) => ProfileListView(
                  profiles: filteredProfiles,
                  onEdit: _editProfile,
                  onDelete: _deleteProfile,
                  onOpen: _openProfile,
                  onAdd: _addProfile,
                ),
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                    child: Text('프로필 로드 실패: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ----------------------------
  Widget _buildQuickInputCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '빠른 조회 및 추가',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text('생년월일을 직접 추가해 바로 사주를 확인합니다.'),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.auto_fix_high),
            label: const Text('생년월일 직접 입력'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            onPressed: _openQuickInput,
          ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// 🔹 프로필 목록 위젯
/// ===============================================================
class ProfileListView extends StatelessWidget {
  final List<Profile> profiles;
  final void Function(Profile) onEdit;
  final void Function(Profile) onDelete;
  final void Function(Profile) onOpen;
  final VoidCallback onAdd;

  const ProfileListView({
    super.key,
    required this.profiles,
    required this.onEdit,
    required this.onDelete,
    required this.onOpen,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('프로필 추가'),
          ),
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      child: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, i) {
          final p = profiles[i];
          return Card(
            color: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(p.name.characters.first),
              ),
              title: Text(p.name),
              subtitle: Text(
                  '${p.birthDate.year}.${p.birthDate.month}.${p.birthDate.day} (${p.gender})'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => onEdit(p),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => onDelete(p),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: () => onOpen(p),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
