// lib/utils/ganji_describe.dart
/* ───────── 설명 문자열 헬퍼 ───────── */
// 예: '甲' → '+갑목'

String describeStem(String ch) {
  final sign = _yinYangSignForStem(ch);
  final elem = _elementKoOfStem(ch);
  final ko   = _stemKo(ch);
  return '$ko$elem $sign';
}

/// 예: '子' → '+자수'  (사용자 제공 규칙 기준)
String describeBranch(String ch) {
  final sign = _branchIsYang(ch) ? '+' : '-';
  final elem = _elementKoOfBranch(ch);
  final ko   = _branchKo(ch);
  return '$ko$elem $sign';
}

/* ───────── 내부 헬퍼(프라이빗) ───────── */

String _yinYangSignForStem(String ch) {
  // 갑병무경임(양), 을정기신계(음)
  const yang = '甲丙戊庚壬';
  return yang.contains(ch) ? '+' : '-';
}

String _elementKoOfStem(String ch) {
  if ('甲乙'.contains(ch)) return '목';
  if ('丙丁'.contains(ch)) return '화';
  if ('戊己'.contains(ch)) return '토';
  if ('庚辛'.contains(ch)) return '금';
  return '수'; // 壬癸
}

String _elementKoOfBranch(String ch) {
  if ('寅卯'.contains(ch)) return '목';
  if ('巳午'.contains(ch)) return '화';
  if ('辰丑未戌'.contains(ch)) return '토';
  if ('申酉'.contains(ch)) return '금';
  if ('亥子'.contains(ch)) return '수';
  return '토';
}

String _stemKo(String ch) {
  const map = {
    '甲':'갑','乙':'을','丙':'병','丁':'정','戊':'무',
    '己':'기','庚':'경','辛':'신','壬':'임','癸':'계',
  };
  return map[ch] ?? ch;
}

String _branchKo(String ch) {
  const map = {
    '子':'자','丑':'축','寅':'인','卯':'묘','辰':'진','巳':'사',
    '午':'오','未':'미','申':'신','酉':'유','戌':'술','亥':'해',
  };
  return map[ch] ?? ch;
}

/// 사용자 제공 규칙:
/// 인묘진사오미신유술해자축 / 양음양양음음양음양양음음
bool _branchIsYang(String ch) {
  const yang = {'寅','辰','巳','申','戌','亥'};
  return yang.contains(ch);
}
