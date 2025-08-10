// lib/services/ten_god_calculator.dart
// --------------------------------------
// 십성(十神) 계산 유틸
// - calcTenGod(dayStem, other, {isBranch})
// - calcTenGodBySaju(saju, target, {isBranch})
//
// 필요 의존:
//   - lib/models/saju_data.dart  (dayGan 등 사용)
//   - lib/utils/elemental_relations.dart
//       * stemToElement, branchToElement
//       * stemYinYang,  branchYinYang
//
// 반환 라벨: 비견/겁재/식신/상관/편인/정인/편재/정재/편관/정관
// 알 수 없거나 매핑 실패 시 ''(빈 문자열) 반환

import '../models/saju_data.dart';
import '../utils/elemental_relations.dart';

/// 상생(生): key 가 value 를 생함
const Map<String, String> _productive = {
  '목': '화', // 木生火
  '화': '토', // 火生土
  '토': '금', // 土生金
  '금': '수', // 金生水
  '수': '목', // 水生木
};

/// 상극(克): key 가 value 를 극함
const Map<String, String> _controlling = {
  '목': '토', // 木克土
  '토': '수', // 土克水
  '수': '화', // 水克火
  '화': '금', // 火克金
  '금': '목', // 金克木
};

/// 십성(十神) 단일 계산
/// [dayStem] = 일간(天干 한 글자), [other] = 비교 대상(간/지 1글자)
/// [isBranch]가 true면 지지로 판정(오행/음양을 지지 기준으로 가져옴)
String calcTenGod(String dayStem, String other, {bool isBranch = false}) {
  if (dayStem.isEmpty || other.isEmpty) return '';

  // 동일 천간(같은 글자)은 바로 처리
  if (!isBranch && dayStem == other) return '비견';

  final dayElem = stemToElement[dayStem];
  final dayYinYang = stemYinYang[dayStem];
  if (dayElem == null || dayYinYang == null) return '';

  final otherElem = isBranch ? branchToElement[other] : stemToElement[other];
  final otherYinYang = isBranch ? branchYinYang[other] : stemYinYang[other];
  if (otherElem == null || otherYinYang == null) return '';

  // 同五行
  if (dayElem == otherElem) {
    return (dayYinYang == otherYinYang) ? '비견' : '겁재';
  }

  // 내가 생하는 쪽(식상)
  if (_productive[dayElem] == otherElem) {
    return (dayYinYang == otherYinYang) ? '식신' : '상관';
  }

  // 나를 생하는 쪽(인성)
  if (_productive[otherElem] == dayElem) {
    return (dayYinYang == otherYinYang) ? '편인' : '정인';
  }

  // 내가 극하는 쪽(재성)
  if (_controlling[dayElem] == otherElem) {
    return (dayYinYang == otherYinYang) ? '편재' : '정재';
  }

  // 나를 극하는 쪽(관성)
  if (_controlling[otherElem] == dayElem) {
    return (dayYinYang == otherYinYang) ? '편관' : '정관';
  }

  return '';
}

/// SajuData 기반 십성 계산 보조
/// - 사용 예: calcTenGodBySaju(saju, saju.monthGan) // 월간 십성
/// - 지지 판정: isBranch=true 로 호출
String calcTenGodBySaju(SajuData saju, String target, {bool isBranch = false}) {
  return calcTenGod(saju.dayGan, target, isBranch: isBranch);
}

/// (선택) 8글자 전체를 한 번에 구하고 싶을 때 편의 함수
/// 반환 키: 'yearGan','monthGan','dayGan','hourGan','yearZhi','monthZhi','dayZhi','hourZhi'
Map<String, String> calcAllTenGods(SajuData saju) {
  final map = <String, String>{
    'yearGan':  calcTenGodBySaju(saju, saju.yearGan),
    'monthGan': calcTenGodBySaju(saju, saju.monthGan),
    'dayGan':   '—', // 일간은 기준축이므로 자체 십성 없음(표시용)
    'hourGan':  saju.hasHour ? calcTenGodBySaju(saju, saju.hourGan) : '—',

    'yearZhi':  calcTenGodBySaju(saju, saju.yearZhi,  isBranch: true),
    'monthZhi': calcTenGodBySaju(saju, saju.monthZhi, isBranch: true),
    'dayZhi':   calcTenGodBySaju(saju, saju.dayZhi,   isBranch: true),
    'hourZhi':  saju.hasHour ? calcTenGodBySaju(saju, saju.hourZhi, isBranch: true) : '—',
  };
  return map;
}
