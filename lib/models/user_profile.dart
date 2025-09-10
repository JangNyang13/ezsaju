// lib/models/user_profile.dart  (요지)
import 'package:ezsaju/models/saju_data.dart';

class UserProfile {
  final String name;
  final String gender;
  final DateTime birth;
  final bool timeUnknown;
  final SajuData saju;  // ✅ nullable 제거
  final List<String> missingElements;

  const UserProfile({
    required this.name,
    required this.gender,
    required this.birth,
    this.timeUnknown = false,
    required this.saju,   // ✅ 무조건 필요
    this.missingElements = const [],
  });

  UserProfile copyWith({
    String? name,
    String? gender,
    DateTime? birth,
    bool? timeUnknown,
    SajuData? saju,
    List<String>? missingElements,
  }) => UserProfile(
    name: name ?? this.name,
    gender: gender ?? this.gender,
    birth: birth ?? this.birth,
    timeUnknown: timeUnknown ?? this.timeUnknown,
    saju: saju ?? this.saju,
    missingElements: missingElements ?? this.missingElements,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender,
    'birth': birth.toIso8601String(),
    'timeUnknown': timeUnknown,
    'saju': saju.toJson(), // ✅ 항상 존재
    'missingElements': missingElements,
  };

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
    name: j['name'] as String,
    gender: j['gender'] as String,
    birth: DateTime.parse(j['birth'] as String),
    timeUnknown: (j['timeUnknown'] as bool?) ?? false,
    saju: SajuData.fromJson(j['saju'] as Map<String, dynamic>), // ✅ null 아님
    missingElements: (j['missingElements'] as List?)?.cast<String>() ?? const [],
  );
}