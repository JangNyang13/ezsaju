// lib/utils/ten_god_calculator.dart
// --------------------------------------
// 십성(十神) 계산 로직 확장: SajuData 확장 기반 유틸리티 제공

import 'package:ezsaju/models/saju_data.dart';
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

/// 십성(十神) 계산 함수
String calcTenGod(String dayStem, String other, {bool isBranch = false}) {
  if (dayStem == other) return '비견';

  final dayElem = stemToElement[dayStem];
  final dayYinYang = stemYinYang[dayStem];
  if (dayElem == null || dayYinYang == null) return '';

  final otherElem = isBranch ? branchToElement[other] : stemToElement[other];
  final otherYinYang = isBranch ? branchYinYang[other] : stemYinYang[other];
  if (otherElem == null || otherYinYang == null) return '';

  if (dayElem == otherElem && dayYinYang == otherYinYang) return '비견';
  if (dayElem == otherElem && dayYinYang != otherYinYang) return '겁재';

  if (productive[dayElem] == otherElem) {
    return (dayYinYang == otherYinYang) ? '식신' : '상관';
  }

  if (productive[otherElem] == dayElem) {
    return (dayYinYang == otherYinYang) ? '편인' : '정인';
  }

  if (controlling[dayElem] == otherElem) {
    return (dayYinYang == otherYinYang) ? '편재' : '정재';
  }

  if (controlling[otherElem] == dayElem) {
    return (dayYinYang == otherYinYang) ? '편관' : '정관';
  }

  return '';
}

/// SajuData 기반 십성 계산 보조 함수
String calcTenGodBySaju(SajuData saju, String target, {bool isBranch = false}) {
  return calcTenGod(saju.dayGan, target, isBranch: isBranch);
}
