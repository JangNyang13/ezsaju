import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
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
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
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
                /// 🔹 제목
                Text(
                  '조후 : ${result.levelName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// 🔹 선·차용
                Text(
                  '선용: ${result.mainYongsUsed.join(', ')}   '
                      '차용: ${result.subYongsUsed.join(', ')}',
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 6),

                /// 🔹 작용 시기
                if (result.mainYongFoundAt.isNotEmpty)
                  Text(
                    '선용 작용 시기: ${result.mainYongFoundAt.join(', ')}',
                    style: const TextStyle(fontSize: 13),
                  ),

                if (result.subYongFoundAt.isNotEmpty)
                  Text(
                    '차용 보조 시기: ${result.subYongFoundAt.join(', ')}',
                    style: const TextStyle(fontSize: 13),
                  ),

                const SizedBox(height: 8),

                /// 🔹 긍정 요소
                if (result.positiveFactors.isNotEmpty)
                  Text(
                    '+ ${result.positiveFactors.join(', ')}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.green,
                    ),
                  ),

                /// 🔹 부정 요소
                if (result.negativeFactors.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '- ${result.negativeFactors.join(', ')}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
