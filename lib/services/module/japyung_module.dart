import '../../models/saju_data.dart';

class JapyungModule {
  /// 격국 판별 (월령 중심)
  static String detectGyeok(SajuData saju) {
    final dayStem = saju.dayPillar.substring(0, 1);
    final monthBranch = saju.monthPillar.substring(1, 2);

    // 기본적 월령-일간 조합으로 격 판단
    switch (monthBranch) {
      case '寅':
      case '卯':
        if (['甲', '乙'].contains(dayStem)) return '인왕격(木旺格)';
        if (['丙', '丁'].contains(dayStem)) return '식신격(火泄木氣)';
        break;
      case '巳':
      case '午':
        if (['丙', '丁'].contains(dayStem)) return '건록격(火旺格)';
        if (['戊', '己'].contains(dayStem)) return '상관생재격(土生金)';
        break;
      case '申':
      case '酉':
        if (['庚', '辛'].contains(dayStem)) return '건록격(金旺格)';
        if (['壬', '癸'].contains(dayStem)) return '식신격(水泄金氣)';
        break;
      case '亥':
      case '子':
        if (['壬', '癸'].contains(dayStem)) return '건록격(水旺格)';
        if (['甲', '乙'].contains(dayStem)) return '상관생재격(木生火)';
        break;
      case '辰':
      case '戌':
      case '丑':
      case '未':
        return '토왕격(土旺格)';
    }
    return '평격(일반형)';
  }

  /// 성향 해석 (격국 기반)
  static String analyzeCharacter(String gyeok) {
    if (gyeok.contains('인왕')) return '리더형, 추진력 강, 개척 정신.';
    if (gyeok.contains('건록')) return '자기관리 철저, 책임감 강.';
    if (gyeok.contains('식신')) return '표현력 풍부, 예술·교육 재능.';
    if (gyeok.contains('상관')) return '창의·언변 우수하나 고집 강.';
    if (gyeok.contains('토왕')) return '중재력, 현실적 안목 뛰어남.';
    return '균형 감각, 조화형 성격.';
  }

  /// 직업 성향 (격국 기반)
  static String analyzeCareer(String gyeok) {
    if (gyeok.contains('식신') || gyeok.contains('상관')) return '예술, 교육, 기획, 콘텐츠 분야';
    if (gyeok.contains('인왕') || gyeok.contains('건록')) return '관리직, 행정, 기술, 리더십직';
    if (gyeok.contains('토왕')) return '부동산, 건설, 금융, 안정 직종';
    return '균형 잡힌 일반 직군';
  }

  static Map<String, String> interpret(SajuData saju) {
    final gyeok = detectGyeok(saju);
    final character = analyzeCharacter(gyeok);
    final career = analyzeCareer(gyeok);

    return {
      '격국': gyeok,
      '성향': character,
      '직업적 방향': career,
    };
  }
}
