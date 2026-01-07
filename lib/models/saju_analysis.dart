// lib/models/saju_analysis.dart
class SajuAnalysis {
  /// 기본
  final String dayStem;
  final String monthBranch;

  /// 지지 / 지장간
  final Set<String> branches;
  final Set<String> hiddenStems;

  /// 합국
  final Set<String> juGroups;    // '수국','목국','화국','금국'
  final Set<String> bangGroups;  // '수방합' 등

  /// 투출
  final Set<String> exposedStems; // 지장간 중 천간에 투출된 것

  /// 천간 세력
  final Map<String, int> stemRootCount;

  SajuAnalysis({
    required this.dayStem,
    required this.monthBranch,
    required this.branches,
    required this.hiddenStems,
    required this.juGroups,
    required this.bangGroups,
    required this.exposedStems,
    required this.stemRootCount,
  });
}
