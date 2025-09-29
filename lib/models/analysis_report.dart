class AnalysisReport {
  /// 신강도 점수 (자평진전/궁통보감 계산값)
  final int strengthScore;

  /// 신강/신약/중화
  final String strengthLevel;

  /// 격국/특수 패턴 태그 리스트
  final List<String> patterns;

  /// 억부용신 후보 (扶弱 / 抑强)
  final List<String> eokbu;

  /// 조후용신 후보 (계절 온냉 보정)
  final List<String> johu;

  /// 기신 후보 (피해야 할 십성/오행)
  final List<String> unhelpfulGods;

  /// 해석 문구 모음
  final List<String> narrations;

  //득령 득지 들세
  final List<String> reasons;

  AnalysisReport({
    required this.strengthScore,
    required this.strengthLevel,
    required this.patterns,
    required this.eokbu,
    required this.johu,
    required this.unhelpfulGods,
    required this.narrations,
    required this.reasons,
  });

  Map<String, dynamic> toJson() => {
    'strengthScore': strengthScore,
    'strengthLevel': strengthLevel,
    'patterns': patterns,
    'eokbu': eokbu,
    'johu': johu,
    'unhelpfulGods': unhelpfulGods,
    'narrations': narrations,
  };

  factory AnalysisReport.fromJson(Map<String, dynamic> json) => AnalysisReport(
    strengthScore: json['strengthScore'] as int,
    strengthLevel: json['strengthLevel'] as String,
    patterns: List<String>.from(json['patterns'] as List),
    eokbu: List<String>.from(json['eokbu'] as List),
    johu: List<String>.from(json['johu'] as List),
    unhelpfulGods: List<String>.from(json['unhelpfulGods'] as List),
    narrations: List<String>.from(json['narrations'] as List),
    reasons: List<String>.from(json['reasons'] as List? ?? []),
  );
}
