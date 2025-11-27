import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SolarTermSegmentBar extends StatelessWidget {
  final String currentTerm;
  final DateTime currentTermDate;
  final String nextTerm;
  final DateTime nextTermDate;
  final DateTime today;

  const SolarTermSegmentBar({
    super.key,
    required this.currentTerm,
    required this.currentTermDate,
    required this.nextTerm,
    required this.nextTermDate,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    final totalDays = nextTermDate.difference(currentTermDate).inDays;
    final progressDays =
    today.difference(currentTermDate).inDays.clamp(0, totalDays);

    final filled = progressDays;
    final segments = totalDays; // 🔥 절기 일수 = 칸 개수

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentTerm,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(width: 8),
              Wrap(
                spacing: 2,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: List.generate(segments, (i) {
                  final isFilled = i < filled;
                  return Container(
                    width: 10,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isFilled
                          ? AppColors.primary
                          : AppColors.secondary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),

              Text(
                nextTerm,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Text(
            "다음 절기까지 ${totalDays - progressDays}일 남음",
            style: const TextStyle(fontSize: 12, color: AppColors.primary),
          )
        ],
      ),
    );
  }
}
