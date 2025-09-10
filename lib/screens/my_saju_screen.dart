// lib/screens/my_saju_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profiles_provider.dart';
import '../widgets/saju_analysis_panel.dart';
import '../constants/text_styles.dart';

class MySajuScreen extends ConsumerWidget {
  const MySajuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider); // SettingsScreen이 선택해둔 프로필
    if (profile == null) {
      return const Scaffold(body: Center(child: Text('설정에서 프로필을 먼저 선택/추가하세요')));
    }

    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,   // ✅ 투명
        surfaceTintColor: Colors.transparent,  // ✅ M3 틴트 제거
        elevation: 8,
        foregroundColor: scheme.onSurface,     // ✅ 아이콘/텍스트 컬러
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.60),
            width: 0.8, // 0.5~1.0 사이 취향대로
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,      // 상단 배경 그대로
          statusBarIconBrightness: Brightness.dark, // Android 아이콘 색
          statusBarBrightness: Brightness.light,    // iOS: 라이트 배경(어두운 아이콘)
        ),
        title: Text(
          profile.name,
          style: AppTextStyles.titleLargeColor(scheme.onSurface),
        ),
      ),
      body: SajuAnalysisPanel(
        key: ValueKey(
          'saju-${profile.name}-${profile.birth.toIso8601String()}-${profile.gender}-${profile.timeUnknown}',
        ),
        title: profile.name,
        birth: profile.birth,
        gender: profile.gender,
        timeUnknown: profile.timeUnknown,
      ),
    );
  }
}
