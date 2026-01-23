import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/module/goongtong/joyong_environment_message_loader.dart';
import '../services/module/goongtong/joyong_result.dart';

class JoyongResultView extends StatelessWidget {
  final JoyongResult result;

  const JoyongResultView({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            width: constraints.maxWidth * 0.9, // ⭐ 좌우 15% 여백
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundOf(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderOf(context)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔮 조후 레벨
                Text(
                  '조후 : ${result.levelName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // 🌿 선용 / 차용 (있을 때만)
                if (result.mainYongsUsed.isNotEmpty ||
                    result.subYongsUsed.isNotEmpty)
                  Text(
                    [
                      if (result.mainYongsUsed.isNotEmpty)
                        '선용: ${result.mainYongsUsed.join(", ")}',
                      if (result.subYongsUsed.isNotEmpty)
                        '차용: ${result.subYongsUsed.join(", ")}',
                    ].join('   '),
                    style: const TextStyle(fontSize: 14),
                  ),

                // ⏳ 선용 시기
                if (result.mainYongFoundAt.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '선용 작용 시기: ${result.mainYongFoundAt.join(", ")}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],

                // ⏳ 차용 시기
                if (result.subYongFoundAt.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '차용 보조 시기: ${result.subYongFoundAt.join(", ")}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],

                // ➕ 긍정 요소
                if (result.positiveFactors.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    '+ ${result.positiveFactors.join(', ')}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.green,
                    ),
                  ),
                ],

                //긍정요소 & 부정요소
                // --- 기존 선용 / 차용 / 시기 출력 이후 ---
                // ⚠ 환경 우려 / ✨ 환경 기대 (ID → 문장 변환)
                FutureBuilder<Map<String, String>>(
                  future: JoyongEnvironmentMessageLoader.load(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();

                    final messages = snapshot.data!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (result.cautionMessages.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            '* 참고사항',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryOf(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...result.cautionMessages.map(
                                (id) => Padding(
                              padding: const EdgeInsets.only(left: 6, top: 2),
                              child: Text(
                                messages[id] ?? id, // ⭐ 여기 핵심
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[400],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],

                        if (result.expectationMessages.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          const Text(
                            '✨ 환경 기대',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...result.expectationMessages.map(
                                (id) => Padding(
                              padding: const EdgeInsets.only(left: 6, top: 2),
                              child: Text(
                                messages[id] ?? id, // ⭐ 여기 핵심
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            )

          ),
        );
      },
    );
  }
}
