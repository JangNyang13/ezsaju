import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../providers/selected_profile_provider.dart';
import 'profile_select_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    final selectedProfile = ref.watch(selectedProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: ListView(
        children: [
          // 🧭 앱 설정 섹션 -------------------------
          SwitchListTile(
            title: const Text('알림 수신'),
            value: _notificationEnabled,
            onChanged: (v) => setState(() => _notificationEnabled = v),
          ),
          const Divider(),

          // 👤 프로필 섹션 -------------------------
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              '프로필 관리',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('현재 선택된 프로필'),
            subtitle: selectedProfile == null
                ? const Text('선택된 프로필이 없습니다.')
                : Text('${selectedProfile.name} (${selectedProfile.gender})'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileSelectScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
