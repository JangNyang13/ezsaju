class JoyongResult {
  final int score;               // 1~5
  final String levelName;        // 부귀 / 준수 / 보통 / 미흡 / 부담

  final bool hasMainYong;        // 주용신 존재 여부
  final bool hasSubYong;         // 보조용신 존재 여부

  final List<String> mainYongsUsed; // 실제 작동한 선용 천간
  final List<String> subYongsUsed;  // 실제 작동한 차용 천간

  final List<String> mainYongFoundAt; // ['월지', '일지', '대운']
  final List<String> subYongFoundAt;

  final List<String> negativeFactors; // 감점 사유
  final List<String> positiveFactors; // 가점/유지 사유

  final List<String> cautionMessages;      // 환경 우려
  final List<String> expectationMessages;  // 환경 기대

  JoyongResult({
    required this.score,
    required this.levelName,
    required this.hasMainYong,
    required this.hasSubYong,
    required this.mainYongsUsed,
    required this.subYongsUsed,
    required this.mainYongFoundAt,
    required this.subYongFoundAt,
    required this.negativeFactors,
    required this.positiveFactors,
    required this.cautionMessages,
    required this.expectationMessages,
  });
}
