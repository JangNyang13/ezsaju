import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import '../providers/selected_profile_provider.dart';
import '../constants/app_colors.dart';
import 'profile_form_screen.dart';

class ProfileSelectScreen extends ConsumerStatefulWidget {
  const ProfileSelectScreen({super.key});

  @override
  ConsumerState<ProfileSelectScreen> createState() => _ProfileSelectScreenState();
}

class _ProfileSelectScreenState extends ConsumerState<ProfileSelectScreen> {
  List<Profile> _profiles = [];
  final _service = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final list = await _service.loadProfiles();
    setState(() => _profiles = list);
  }

  Future<void> _saveProfiles() async {
    await _service.saveProfiles(_profiles);
  }

  void _addProfile() async {
    final newProfile = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
    );
    if (newProfile != null && newProfile is Profile) {
      setState(() => _profiles.add(newProfile));
      _saveProfiles();
    }
  }

  void _editProfile(Profile p) async {
    final edited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileFormScreen(),
        settings: RouteSettings(arguments: p),
      ),
    );
    if (edited != null && edited is Profile) {
      // ✅ id 기준으로 수정
      final idx = _profiles.indexWhere((e) => e.id == p.id);
      if (idx != -1) {
        setState(() => _profiles[idx] = edited);
        _saveProfiles();
      }
    }
  }

  void _removeProfile(Profile p) {
    setState(() => _profiles.removeWhere((e) => e.id == p.id)); // ✅ id 기준 삭제
    _saveProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProfile = ref.watch(selectedProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 선택'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addProfile,
          ),
        ],
      ),
      body: _profiles.isEmpty
          ? const Center(
        child: Text('등록된 프로필이 없습니다.'),
      )
          : ListView.builder(
        itemCount: _profiles.length,
        itemBuilder: (context, index) {
          final p = _profiles[index];
          final isSelected = selectedProfile?.id == p.id; // ✅ 이름 대신 id로 비교

          return GestureDetector(
            onTap: () {
              ref.read(selectedProfileProvider.notifier).state = p;

              SelectedProfileManager.save(p).then((_) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${p.name}님이 선택되었습니다.')),
                );
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    offset: const Offset(1, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.card,
                  child: Text(p.name.characters.first),
                ),
                title: Text(p.name),
                subtitle: Text(
                  '${_formattedDate(p)} (${p.gender})',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _editProfile(p),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _removeProfile(p),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formattedDate(Profile p) {
    final dateStr =
        '${p.birthDate.year}.${p.birthDate.month.toString().padLeft(2, '0')}.${p.birthDate.day.toString().padLeft(2, '0')}';
    final timeStr = p.isUnknownTime
        ? '모름'
        : '${p.birthDate.hour.toString().padLeft(2, '0')}:${p.birthDate.minute.toString().padLeft(2, '0')}';
    final lunarLabel = !p.isLunar
        ? '(양)'
        : p.isLeapMonth
        ? '(음윤)'
        : '(음)';
    return '$lunarLabel$dateStr $timeStr';
  }
}
