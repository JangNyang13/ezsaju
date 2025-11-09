import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';
import '../providers/selected_profile_provider.dart';
import '../constants/app_colors.dart';
import '../providers/theme_provider.dart';
import 'profile_form_screen.dart';

class ProfileSelectScreen extends ConsumerWidget {
  const ProfileSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(profilesProvider);
    final selectedProfile = ref.watch(selectedProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 선택'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newProfile = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
              );
              if (newProfile != null && newProfile is Profile) {
                ref.read(profilesProvider.notifier).addProfile(newProfile);
              }
            },
          ),
        ],
      ),
      body: profilesAsync.when(
        data: (profiles) {
          if (profiles.isEmpty) {
            return const Center(child: Text('등록된 프로필이 없습니다.'));
          }

          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final p = profiles[index];
              final isSelected = selectedProfile?.id == p.id;

              return GestureDetector(
                onTap: () {
                  ref.read(selectedProfileProvider.notifier).select(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${p.name}님이 선택되었습니다.')),
                  );
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
                          onPressed: () async {
                            final edited = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileFormScreen(),
                                settings: RouteSettings(arguments: p),
                              ),
                            );
                            if (edited != null && edited is Profile) {
                              ref
                                  .read(profilesProvider.notifier)
                                  .updateProfile(edited);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            ref
                                .read(profilesProvider.notifier)
                                .deleteProfile(p.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('오류 발생: $err')),
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
