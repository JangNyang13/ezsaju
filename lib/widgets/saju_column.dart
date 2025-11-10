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
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    // 시스템 폰트 배율 무시
    final media = MediaQuery.of(context);
    final textScaler = media.textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);

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

    return MediaQuery(
      data: media.copyWith(textScaler: textScaler), // 폰트 크기 고정
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "($ganjiKor)",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              height: 1.2,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),

          if (stemTenGod != null)
            Text(
              stemTenGod,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.primary, height: 1.1),
            ),

          const SizedBox(height: 4),

          // 천간
          GapjaBox(
            text: stem,
            color: (stem == '-' || stem.isEmpty)
                ? AppColors.background
                : AppColors.fromGanji(stem),
            size: size,
          ),

          const SizedBox(height: 4),

          // 지지
          GapjaBox(
            text: branch,
            color: (branch == '-' || branch.isEmpty)
                ? AppColors.background
                : AppColors.fromGanji(branch),
            size: size,
          ),

          if (branchTenGod != null)
            Text(
              branchTenGod,
              style: const TextStyle(fontSize: 13, color: AppColors.primary, height: 1.1),
              textAlign: TextAlign.center,
            ),

          const SizedBox(height: 4),

          // 지장간 + 십성
          if (hiddenList.isNotEmpty)
            Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: hiddenList.map((h) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          h,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.fromGanji(h),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: hiddenList.map((h) {
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
                            fontSize: 11,
                            color: AppColors.primary,
                            height: 1.0,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 4),

          if (luckStage != null)
            Text(
              "(봉)$luckStage",
              style: const TextStyle(fontSize: 12, color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
          if (geoStage != null)
            Text(
              "(거)$geoStage",
              style: const TextStyle(fontSize: 12, color: AppColors.primary),
              textAlign: TextAlign.center,
            ),

          // 신살
          if ((sinsal['good']?.isNotEmpty ?? false) ||
              (sinsal['bad']?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Column(
                children: [
                  ...?sinsal['good']?.map(
                        (s) => Text(
                      s.replaceAll(RegExp(r'\(.*\)'), ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ),
                  ...?sinsal['bad']?.map(
                        (s) => Text(
                      s.replaceAll(RegExp(r'\(.*\)'), ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
