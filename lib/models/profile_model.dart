import 'package:uuid/uuid.dart';

class Profile {
  final String id;
  final String name;
  final DateTime birthDate;
  final bool isLunar;
  final bool isLeapMonth;
  final bool isUnknownTime;
  final String gender; // '남' or '여'
  final String memo;

  final int? lunarYear;
  final int? lunarMonth;
  final int? lunarDay;

  Profile({
    required this.id,
    required this.name,
    required this.birthDate,
    this.isLunar = false,
    this.isLeapMonth = false,
    this.isUnknownTime = false,
    this.gender = '남',
    this.memo = '',
    this.lunarYear,
    this.lunarMonth,
    this.lunarDay,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'birthDate': birthDate.toIso8601String(),
    'isLunar': isLunar,
    'isLeapMonth': isLeapMonth,
    'isUnknownTime': isUnknownTime,
    'gender': gender,
    'memo': memo,
    'lunarYear': lunarYear,
    'lunarMonth': lunarMonth,
    'lunarDay': lunarDay,
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'] ?? const Uuid().v4(),
    name: json['name'],
    birthDate: DateTime.parse(json['birthDate']),
    isLunar: json['isLunar'] ?? false,
    isLeapMonth: json['isLeapMonth'] ?? false,
    isUnknownTime: json['isUnknownTime'] ?? false,
    gender: json['gender'] ?? '남',
    memo: json['memo'] ?? '',
    lunarYear: json['lunarYear'],
    lunarMonth: json['lunarMonth'],
    lunarDay: json['lunarDay'],
  );

}
