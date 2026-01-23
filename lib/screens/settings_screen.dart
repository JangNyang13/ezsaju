import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationEnabled = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        backgroundColor: AppColors.backgroundOf(context),
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
        ],
      ),
    );
  }
}
