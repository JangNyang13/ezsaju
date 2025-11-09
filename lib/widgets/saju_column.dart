import 'package:flutter/material.dart';
import '../models/stem_branch.dart';
import '../models/saju_data.dart';
import '../services/module/shibsung_module.dart';
import '../constants/app_colors.dart';
import '../widgets/gapja_box.dart';

class SajuColumn extends StatelessWidget {
  final String label;
  final String stem;
  final String branch;
  final Map tenGods;
  final Map unse;
  final Map<String, List<String>> sinsal;
  final SajuData saju;
  final double size;

  const SajuColumn({
    super.key,
    required this.label,
    required this.stem,
    required this.branch,
    required this.tenGods,
    required this.unse,
    required this.sinsal,
    required this.saju,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final stemTenGod = tenGods['${label.substring(0, 1)}간'];
    final branchTenGod = tenGods['${label.substring(0, 1)}지'];
    final luckStage = unse['봉법(逢法)']?['${label.substring(0, 1)}지'];
    final geoStage = unse['거법(去法)']?['${label.substring(0, 1)}주'];

    final hiddenList = earthlyBranches
        .firstWhere(
          (e) => e.name == branch,
      orElse: () => const StemBranch(name: '', element: '', yinYang: ''),
    )
        .hiddenStems ??
        [];

    final ganjiKor = '${getHangulName(stem)}${getHangulName(branch)}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "($ganjiKor)",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        if (stemTenGod != null)
          Text(stemTenGod,
              style: const TextStyle(fontSize: 14, color: AppColors.primary)),

        GapjaBox(
          text: stem,
          color: (stem == '-' || stem.isEmpty)
              ? AppColors.background            // 시간 모름 시 회색
              : AppColors.fromGanji(stem),
          size: size,
        ),
        const SizedBox(height: 6),
        GapjaBox(
          text: branch,
          color: (stem == '-' || stem.isEmpty)
              ? AppColors.background            // 시간 모름 시 회색
              :  AppColors.fromGanji(branch),
          size: size,
        ),

        if (branchTenGod != null)
          Text(branchTenGod,
              style: const TextStyle(fontSize: 14, color: AppColors.primary)),

        if (hiddenList.isNotEmpty)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: hiddenList
                    .map((h) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    h,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.fromGanji(h),
                    ),
                  ),
                ))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: hiddenList
                    .map((h) {
                  final sameYinYang = ShibsungModule.isYang(saju.dayStem) ==
                      ShibsungModule.isYang(h);
                  final tenGod = ShibsungModule.getTenGod(
                    saju.dayStem,
                    h,
                    sameYinYang,
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Text(
                      tenGod,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                })
                    .toList(),
              ),
            ],
          ),

        if (luckStage != null)
          Text("(봉)$luckStage",
              style: const TextStyle(fontSize: 14, color: AppColors.primary)),

        if (geoStage != null)
          Text("(거)$geoStage",
              style: const TextStyle(fontSize: 14, color: AppColors.primary)),

        if ((sinsal['good']?.isNotEmpty ?? false) ||
            (sinsal['bad']?.isNotEmpty ?? false))
          Column(
            children: [
              ...?sinsal['good']?.map(
                    (s) => Text(
                  s.replaceAll(RegExp(r'\(.*\)'), ''),
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ...?sinsal['bad']?.map(
                    (s) => Text(
                  s.replaceAll(RegExp(r'\(.*\)'), ''),
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
