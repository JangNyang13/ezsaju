import 'package:ezsaju/constants/text_styles.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/module/gyeokguk_repository.dart';

class GyeokgukDetailScreen extends StatelessWidget {
  final String gyeok;
  final List<String> patterns;

  const GyeokgukDetailScreen({
    super.key,
    required this.gyeok,
    required this.patterns,
  });

  Widget _section(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목 + 양쪽 라인
        Row(
          children: [
            const Expanded(
              child: Divider(
                thickness: 1.2,
                color: AppColors.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '[ $title ]',
                style: AppTextStyles.titleLarge,
              ),
            ),
            const Expanded(
              child: Divider(
                thickness: 1.2,
                color: AppColors.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 본문 설명
        Text(
          content,
          style: AppTextStyles.body,
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final gyeokText = GyeokgukRepository.text(gyeok);

    return Scaffold(
      appBar: AppBar(
        title: Text('$gyeok 상세'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⭐ 기본 격국 설명 섹션
              _section(gyeok, gyeokText),

              // ⭐ 패턴 섹션들
              for (final p in patterns)
                _section(
                  p,
                  GyeokgukRepository.text(p),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
