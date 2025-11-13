import '../../../models/calendar_day.dart';
import '../../../models/stem_branch.dart';
import '../../../services/term_extractor.dart';
import '../../../services/manse_loader.dart'; // 추가
import 'daewoon_model.dart';

class DaewoonCalculator {
  static Future<List<Daewoon>> calculate({
    required String yearStem,
    required String monthStem,
    required String monthBranch,
    required DateTime birthDate,
    required bool isMale,
    bool isLunar = false, // ✅ 프로필이 음력인지 여부 추가
    bool isLeapMonth = false, // ✅ 윤달 여부 추가
  }) async {
    // 12절입만 로드
    final majorTerms = await TermExtractor.extractMajorTerms();

    // ------------------------------------------------------------
    // 🔹 (1) 음력 입력 시 양력으로 변환
    // ------------------------------------------------------------
    DateTime solarBirth = birthDate;
    if (isLunar) {
      final converted = await ManseLoader.lunarToSolar(
        lunarYear: birthDate.year,
        lunarMonth: birthDate.month,
        lunarDay: birthDate.day,
        isLeapMonth: isLeapMonth,
      );
      if (converted != null) solarBirth = converted;
    }

    // ------------------------------------------------------------
    // 🔹 (2) 순행/역행 판별
    // ------------------------------------------------------------
    final bool isForward = _isForward(yearStem, isMale);
    final String direction = isForward ? '순행' : '역행';

    // ------------------------------------------------------------
    // 🔹 (3) 절입 기준 찾기
    // ------------------------------------------------------------
    final terms = _findPrevNextTerms(solarBirth, majorTerms);

    // ------------------------------------------------------------
    // 🔹 (4) 대운 시작 시점(대운수) 계산
    // ------------------------------------------------------------
    final offsetResult = _getStartOffset(
      solarBirth,
      terms['prev']!,
      terms['next']!,
      isForward,
    );

    final int startAge = offsetResult['years']!;
    final Duration offset = offsetResult['offset']!;
    final DateTime firstDaewoonStart = solarBirth.add(offset);

    // ------------------------------------------------------------
    // 🔹 (5) 대운 간지 순환 계산
    // ------------------------------------------------------------
    final List<Daewoon> result = [];

    var stem = monthStem;
    var branch = monthBranch;
    final first = _nextGanji(stem, branch, isForward);
    stem = first['stem']!;
    branch = first['branch']!;

    for (int i = 0; i < 10; i++) {
      result.add(Daewoon(
        index: i + 1,
        startYear: firstDaewoonStart.year + (i * 10),
        endYear: firstDaewoonStart.year + (i + 1) * 10 - 1,
        stem: stem,
        branch: branch,
        startAge: startAge + (i * 10),
        direction: direction,
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

  /// ▪️ 대운 시작 시점 계산식 (절입 기준)
  static Map<String, dynamic> _getStartOffset(
      DateTime birthDate,
      DateTime prevTerm,
      DateTime nextTerm,
      bool isForward,
      ) {
    final daysDiff = (isForward
        ? nextTerm.difference(birthDate).inDays
        : birthDate.difference(prevTerm).inDays) +
        1; // 태어난 날 포함

    // 대운수 = 절입 간 일수 ÷ 3 (반올림)
    final years = (daysDiff / 3.0).round();

    // 실제 offset 일수 (윤년 보정)
    final offsetDays = (years * 365.25).round();

    return {
      'years': years,
      'offset': Duration(days: offsetDays),
    };
  }

  /// ▪️ 간지 순환
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
      sIdx = (sIdx - 1 + heavenlyStems.length) % heavenlyStems.length;
      bIdx = (bIdx - 1 + earthlyBranches.length) % earthlyBranches.length;
    }

    return {
      'stem': heavenlyStems[sIdx].name,
      'branch': earthlyBranches[bIdx].name,
    };
  }
}
