import 'package:flutter/material.dart';
import '../models/calendar_day.dart';
import '../models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final CalendarDay lunar;

  const ProfileHeader({super.key, required this.profile, required this.lunar});

  @override
  Widget build(BuildContext context) {
    final solarStr =
        '${profile.birthDate.year}.${profile.birthDate.month.toString().padLeft(2, '0')}.${profile.birthDate.day.toString().padLeft(2, '0')}';
    final timeStr = profile.isUnknownTime
        ? ''
        : 'T ${profile.birthDate.hour.toString().padLeft(2, '0')}:${profile.birthDate.minute.toString().padLeft(2, '0')}';
    final lunarStr =
        '${lunar.isLeapMonth ? "(윤)" : ""}${lunar.lunarYear}.${lunar.lunarMonth.toString().padLeft(2, '0')}.${lunar.lunarDay.toString().padLeft(2, '0')}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Center(
            child: Text(
              profile.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('양력: $solarStr $timeStr',
                  style: const TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 4),
              Text('음력: $lunarStr  ${profile.gender == "남" ? "남성" : "여성"}',
                  style: const TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
