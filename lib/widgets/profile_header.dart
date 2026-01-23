import 'package:ezsaju/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../models/calendar_day.dart';
import '../models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final CalendarDay lunar;

  const ProfileHeader({super.key, required this.profile, required this.lunar});

  @override
  Widget build(BuildContext context) {
    final timeStr = profile.isUnknownTime
        ? ''
        : 'T ${profile.birthDate.hour.toString().padLeft(2, '0')}:${profile.birthDate.minute.toString().padLeft(2, '0')}';
    final genderStr = profile.gender == '남' ? '남성' : '여성';

    // --------------------------------------------------------
    // 🔹 양력/음력 구분에 따른 실제 표시값
    // --------------------------------------------------------
    late final String solarStr;
    late final String lunarStr;

    if (profile.isLunar) {
      // ✅ 음력으로 저장한 경우 → birthDate는 이미 양력 변환된 값
      //    즉, 위쪽(양력)은 birthDate, 아래쪽(음력)은 원래 저장한 lunarXXX
      solarStr =
      '${profile.birthDate.year}.${profile.birthDate.month.toString().padLeft(2, '0')}.${profile.birthDate.day.toString().padLeft(2, '0')}';
      lunarStr =
      '${profile.lunarYear?.toString().padLeft(4, '0') ?? lunar.lunarYear}.'
          '${profile.lunarMonth?.toString().padLeft(2, '0') ?? lunar.lunarMonth}.'
          '${profile.lunarDay?.toString().padLeft(2, '0') ?? lunar.lunarDay}'
          '${profile.isLeapMonth ? " (윤달)" : ""}';
    } else {
      // ✅ 양력으로 저장한 경우 → birthDate는 그대로 양력, lunar은 변환된 음력
      solarStr =
      '${profile.birthDate.year}.${profile.birthDate.month.toString().padLeft(2, '0')}.${profile.birthDate.day.toString().padLeft(2, '0')}';
      lunarStr =
      '${lunar.lunarYear}.${lunar.lunarMonth.toString().padLeft(2, '0')}.${lunar.lunarDay.toString().padLeft(2, '0')}'
          '${lunar.isLeapMonth ? " (윤달)" : ""}';
    }

    // --------------------------------------------------------
    // 🔹 UI는 동일하게 유지
    // --------------------------------------------------------
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Center(
            child: Text(
              profile.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '양력: $solarStr $timeStr',
                style: TextStyle(fontSize: 16, color: AppColors.textPrimaryOf(context)),
              ),
              const SizedBox(height: 4),
              Text(
                '음력: $lunarStr  ($genderStr)',
                style: TextStyle(fontSize: 16, color: AppColors.textPrimaryOf(context)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
