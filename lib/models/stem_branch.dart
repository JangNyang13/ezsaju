//lib/models/stem_branch.dart
class StemBranch {
  final String name;     // '甲' or '子'
  final String element;  // '목', '화', '토', '금', '수'
  final String yinYang;  // '양' or '음'
  final List<String>? hiddenStems; // 지지의 지장간 (천간은 null)

  const StemBranch({
    required this.name,
    required this.element,
    required this.yinYang,
    this.hiddenStems,
  });
}

// 🔟 천간 목록
const List<StemBranch> heavenlyStems = [
  StemBranch(name: '甲', element: '목', yinYang: '양'),
  StemBranch(name: '乙', element: '목', yinYang: '음'),
  StemBranch(name: '丙', element: '화', yinYang: '양'),
  StemBranch(name: '丁', element: '화', yinYang: '음'),
  StemBranch(name: '戊', element: '토', yinYang: '양'),
  StemBranch(name: '己', element: '토', yinYang: '음'),
  StemBranch(name: '庚', element: '금', yinYang: '양'),
  StemBranch(name: '辛', element: '금', yinYang: '음'),
  StemBranch(name: '壬', element: '수', yinYang: '양'),
  StemBranch(name: '癸', element: '수', yinYang: '음'),
];

// 🧭 지지 목록 (지장간 포함)  --- 자수,해수,사화,오화는 체와 용이 다르므로 음양을 바꾸어서..
const List<StemBranch> earthlyBranches = [
  StemBranch(name: '子', element: '수', yinYang: '음', hiddenStems: ['癸', '壬']),
  StemBranch(name: '丑', element: '토', yinYang: '음', hiddenStems: ['己', '辛', '癸']),
  StemBranch(name: '寅', element: '목', yinYang: '양', hiddenStems: ['甲', '丙', '戊']),
  StemBranch(name: '卯', element: '목', yinYang: '음', hiddenStems: ['乙', '甲']),
  StemBranch(name: '辰', element: '토', yinYang: '양', hiddenStems: ['戊', '癸', '乙']),
  StemBranch(name: '巳', element: '화', yinYang: '양', hiddenStems: ['丙', '庚', '戊']),
  StemBranch(name: '午', element: '화', yinYang: '음', hiddenStems: ['丁', '己', '丙']),
  StemBranch(name: '未', element: '토', yinYang: '음', hiddenStems: ['己', '乙', '丁']),
  StemBranch(name: '申', element: '금', yinYang: '양', hiddenStems: ['庚', '壬', '戊']),
  StemBranch(name: '酉', element: '금', yinYang: '음', hiddenStems: ['辛', '庚']),
  StemBranch(name: '戌', element: '토', yinYang: '양', hiddenStems: ['戊', '丁', '辛']),
  StemBranch(name: '亥', element: '수', yinYang: '양', hiddenStems: ['壬', '甲', '戊']),
];

/// 천간 → 오행 매핑
final Map<String, String> stemToElement = {
  for (final s in heavenlyStems) s.name: s.element,
};

/// 지지 → 오행 매핑
final Map<String, String> branchToElement = {
  for (final b in earthlyBranches) b.name: b.element,
};

/// 한자(천간/지지) → 한글 이름 변환
String getHangulName(String hanja) {
  const map = {
    // 천간
    '甲': '갑', '乙': '을', '丙': '병', '丁': '정',
    '戊': '무', '己': '기', '庚': '경', '辛': '신',
    '壬': '임', '癸': '계',
    // 지지
    '子': '자', '丑': '축', '寅': '인', '卯': '묘',
    '辰': '진', '巳': '사', '午': '오', '未': '미',
    '申': '신', '酉': '유', '戌': '술', '亥': '해',
  };
  return map[hanja] ?? '';
}
