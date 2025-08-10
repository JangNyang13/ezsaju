// lib/screens/my_saju_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profiles_provider.dart';
import '../widgets/saju_analysis_panel.dart';

class MySajuScreen extends ConsumerWidget {
  const MySajuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider); // SettingsScreen이 선택해둔 프로필
    if (profile == null) {
      return const Scaffold(body: Center(child: Text('프로필을 먼저 선택/추가하세요')));
    }
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(profile.name)),
      body: SajuAnalysisPanel(
        title: profile.name,
        birth: profile.birth,          // 저장 시 이미 양력으로 변환됨
        gender: profile.gender,        // 'M' | 'F'
        timeUnknown: profile.timeUnknown,
      ),
    );
  }
}
