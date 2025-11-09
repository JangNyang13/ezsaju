import '../models/stem_branch.dart';

/// 문자열을 천간 객체로 변환
StemBranch? getStem(String name) {
  try {
    return heavenlyStems.firstWhere((e) => e.name == name);
  } catch (_) {
    return null;
  }
}

/// 문자열을 지지 객체로 변환
StemBranch? getBranch(String name) {
  try {
    return earthlyBranches.firstWhere((e) => e.name == name);
  } catch (_) {
    return null;
  }
}

/// 천간 이름으로 오행 반환
String getElementFromStem(String name) {
  return heavenlyStems.firstWhere((e) => e.name == name).element;
}

/// 천간 이름으로 음양 반환
String getYinYangFromStem(String name) {
  return heavenlyStems.firstWhere((e) => e.name == name).yinYang;
}

/// 천간 + 지지 문자열을 “○○주” 형식으로 변환
String formatPillar(String pillar, String title) => '$title주($pillar)';
