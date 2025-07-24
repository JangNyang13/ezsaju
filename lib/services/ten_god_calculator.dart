// lib/services/ten_god_calculator.dart
// --------------------------------------
// 십성(十神) 계산 로직
// • 일간(日干)과 대상 천간의 관계를 오행 상생·상극 및 음양으로 구분

import 'package:ezsaju/utils/elemental_relations.dart';

/// 상생(生) 관계: key 가 value 를 생함
const Map<String, String> productive = {
  '목': '화', // 木生火
  '화': '토', // 火生土
  '토': '금', // 土生金
  '금': '수', // 金生水
  '수': '목', // 水生木
};

/// 상극(克) 관계: key 가 value 를 극함
const Map<String, String> controlling = {
  '목': '토', // 木克土
  '토': '수', // 土克水
  '수': '화', // 水克火
  '화': '금', // 火克金
  '금': '목', // 金克木
};

/// 일간(dayStem)과 대상(otherStem) 간지의 십성 계산
String calcTenGod(String dayStem, String otherStem) {
  if (dayStem == otherStem) {
    // 같은 천간
    return '비견';
  }

  final dayElem = stemToElement[dayStem]!;
  final otherElem = stemToElement[otherStem]!;
  final dayYy = stemYinYang[dayStem]!;
  final otherYy = stemYinYang[otherStem]!;

  // 상생 관계
  if (productive[dayElem] == otherElem) {
    // 음양 일치 여부에 따라 인수 또는 편인
    return dayYy == otherYy ? '정인' : '편인'; //'正印' : '偏印'
  }

  // 식신 / 상관: 일간이 상대를 생할 때 역생
  if (productive[otherElem] == dayElem) {
    return dayYy == otherYy ? '식신' : '상관'; //'食神' : '傷官'
  }

  // 정재 / 편재: 일간이 상대를 극할 때
  if (controlling[dayElem] == otherElem) {
    return dayYy == otherYy ? '정재' : '편재'; //'正財' : '偏財'
  }

  // 정관 / 七殺: 상대가 일간을 극할 때
  if (controlling[otherElem] == dayElem) {
    return dayYy == otherYy ? '정관' : '편관'; //'正官' : '偏官'
  }

  // 겁재: 같은 오행 다른 음양 (比肩 외)
  if (dayElem == otherElem) {
    return '겁재'; //'劫財'
  }

  // 기본 fallback
  return '';
}
