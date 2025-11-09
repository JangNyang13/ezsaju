// lib/modules/daewoon_module/daewoon_calculator.dart
import '../../../models/calendar_day.dart';
import '../../../models/stem_branch.dart';
import '../../../services/term_extractor.dart';
import 'daewoon_model.dart';

class DaewoonCalculator {
  static Future<List<Daewoon>> calculate({
    required String yearStem,
    required String monthStem,
    required String monthBranch,
    required DateTime birthDate,
    required bool isMale,
  }) async {
    // 12절입만 로드
    final majorTerms = await TermExtractor.extractMajorTerms();

    // 순행/역행 판별
    final bool isForward = _isForward(yearStem, isMale);

    // 생일 기준 이전·다음 절입일 찾기
    final terms = _findPrevNextTerms(birthDate, majorTerms);

    // 대운수(시작연령) 계산
    final offsetResult = _getStartOffset(
      birthDate,
      terms['prev']!,
      terms['next']!,
      isForward,
    );

    final int startAge = offsetResult['years']!;
    final Duration offset = offsetResult['offset']!;
    final DateTime firstDaewoonStart = birthDate.add(offset);

    final List<Daewoon> result = [];

    // 첫 대운은 월주 다음 간지부터 시작
    var stem = monthStem;
    var branch = monthBranch;
    final first = _nextGanji(stem, branch, isForward);
    stem = first['stem']!;
    branch = first['branch']!;

    // 10주기 대운 생성
    for (int i = 0; i < 10; i++) {
      result.add(Daewoon(
        index: i + 1,
        startYear: firstDaewoonStart.year + (i * 10),
        endYear: firstDaewoonStart.year + (i + 1) * 10 - 1,
        stem: stem,
        branch: branch,
        startAge: startAge + (i * 10), // 실제 시작나이 반영
      ));

      final next = _nextGanji(stem, branch, isForward);
      stem = next['stem']!;
      branch = next['branch']!;
    }

    return result;
  }

  /// ▪️ 생일 기준 이전·다음 절입일 찾기
  static Map<String, DateTime> _findPrevNextTerms(
      DateTime birthDate,
      List<CalendarDay> terms,
      ) {
    if (terms.isEmpty) return {'prev': birthDate, 'next': birthDate};

    CalendarDay? prev;
    CalendarDay? next;

    for (final t in terms) {
      final date = DateTime(t.solarYear, t.solarMonth, t.solarDay);
      if (date.isBefore(birthDate)) prev = t;
      if (date.isAfter(birthDate)) {
        next = t;
        break;
      }
    }

    // 🔧 연도 경계 안전 처리
    prev ??= terms.last;
    next ??= terms.first;

    return {
      'prev': DateTime(prev.solarYear, prev.solarMonth, prev.solarDay),
      'next': DateTime(next.solarYear, next.solarMonth, next.solarDay),
    };
  }


  /// ▪️ 순행 / 역행 판별
  static bool _isForward(String yearStem, bool isMale) {
    const yangStems = ['甲', '丙', '戊', '庚', '壬'];
    final isYang = yangStems.contains(yearStem);
    return (isYang && isMale) || (!isYang && !isMale);
  }

  /// ▪️ 대운 시작 시점 계산식 (절입 기준, 반올림 적용)
  // ▪️ 대운 시작 시점 계산식 (정확한 절입 기준)
  static Map<String, dynamic> _getStartOffset(
      DateTime birthDate,
      DateTime prevTerm,
      DateTime nextTerm,
      bool isForward,
      ) {
    final daysDiff = (isForward
        ? nextTerm.difference(birthDate).inDays
        : birthDate.difference(prevTerm).inDays) +1;//태어난 날도 1일.

    // 대운수 = (절입 간 일수 ÷ 3), 반올림
    final years = (daysDiff / 3.0).round();

    // 실제 일수 기반 offset (윤년 포함 보정)
    final offsetDays = (years * 365.25).round();

    return {
      'years': years,
      'offset': Duration(days: offsetDays),
    };
  }


  /// ▪️ 간지 순환 (stem_branch.dart 사용)
  static Map<String, String> _nextGanji(
      String stem,
      String branch,
      bool isForward,
      ) {
    int sIdx = heavenlyStems.indexWhere((s) => s.name == stem);
    int bIdx = earthlyBranches.indexWhere((b) => b.name == branch);

    if (isForward) {
      sIdx = (sIdx + 1) % heavenlyStems.length;
      bIdx = (bIdx + 1) % earthlyBranches.length;
    } else {
      sIdx = (sIdx - 1) < 0 ? heavenlyStems.length - 1 : sIdx - 1;
      bIdx = (bIdx - 1) < 0 ? earthlyBranches.length - 1 : bIdx - 1;
    }

    return {
      'stem': heavenlyStems[sIdx].name,
      'branch': earthlyBranches[bIdx].name,
    };
  }
}
