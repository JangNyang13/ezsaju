// lib/services/term_extractor.dart
import '../models/calendar_day.dart';
import 'manse_loader.dart';

class TermExtractor {
  /// 대운용 절입 리스트 추출
  static Future<List<CalendarDay>> extractMajorTerms() async {
    final data = await ManseLoader.load();

    // 대운 계산에 사용할 12절입만 필터링
    const usedTerms = [
      '소한', '입춘', '경칩', '청명', '입하', '망종',
      '소서', '입추', '백로', '한로', '입동', '대설',
    ];

    return data
        .where((d) =>
    d.termName != null &&
        usedTerms.contains(d.termName))
        .toList();
  }
}
