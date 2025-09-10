// lib/services/saju_calculator.dart
import '../models/saju_data.dart';

/// SajuCalculator
/// -------------------------------
/// - fromDateTime: DateTime → SajuData (연‧월‧일‧시주)
/// - 월주: 입절 당일에 절기 시각 이전이면 전날 월주, 이후면 당일 월주
/// - 시지: 한국 기준 **23:30 자시** 시작, 2시간 블록(필요 시 shiftMinutes로 조정)
class SajuCalculator {
  static SajuData fromDateTime(
      DateTime dt,
      Map<String, Map<String, dynamic>> manse, {
        bool timeUnknown = false, // 시간 모름이면 시주 생략
      }) {
    final key = _yyyyMMdd(dt);
    final row = manse[key];
    if (row == null) {
      throw Exception('만세력에 날짜($key)가 존재하지 않습니다');
    }

    final year  = (row['cd_hyganjee'] ?? '').toString(); // 예: '己亥'
    String month = (row['cd_hmganjee'] ?? '').toString(); // 예: '丙子'
    final day   = (row['cd_hdganjee'] ?? '').toString(); // 예: '甲戌'

    // ── 월주: 입절 당일 보정 (소한~대설 12절기, term_name 없음 → 월초 2~12일로 식별)
    final term = _parseTerms(row['cd_terms_time']);
    if (term != null && _isAcceptedTermDate(term)) {
      if (dt.isBefore(term)) {
        final prev = manse[_yyyyMMdd(dt.subtract(const Duration(days: 1)))];
        if (prev != null) {
          month = (prev['cd_hmganjee'] ?? month).toString();
        }
      }
    }

    // 시간 모름이면 시주 생략
    if (timeUnknown) {
      return SajuData(year: year, month: month, day: day, hour: null);
    }

    // ── 시주 계산 (자시 23:30 시작)
    final hour = _calcHourGanji(day, dt);
    return SajuData(year: year, month: month, day: day, hour: hour);
  }

  /// 시주 계산 (천간‧지지)
  static String _calcHourGanji(String dayGanji, DateTime dt) {
    // 한국 기준: 자시 23:30 시작 → shiftMinutes=30 (23:00 + 30분)
    final zhi = _hourZhiFromDateTime(dt, shiftMinutes: 30);
    final gan = _hourGanFromDayGan(dayGanji.substring(0, 1), zhi);
    return '$gan$zhi';
  }

  /// 시지(地支) 계산 – 앵커(23:00 + shiftMinutes)에서 2시간 단위 버킷
  /// 예) shiftMinutes=30 → 자시 [23:30, 01:30), 축시 [01:30, 03:30) ...
  static String _hourZhiFromDateTime(DateTime dt, {int shiftMinutes = 30}) {
    const zhiSeq = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];

    // 분 단위 시각
    final totalMin = dt.hour * 60 + dt.minute;

    // 앵커: 23:00(=1380) + shiftMinutes (기본 30 → 23:30)
    final anchor = 1380 + shiftMinutes;

    // 자정 래핑 보정: (total - anchor) 를 0..1439로 정규화
    final shifted = ((totalMin - anchor) % 1440 + 1440) % 1440;

    // 120분(=2시간) 버킷 인덱스
    final idx = shifted ~/ 120;

    return zhiSeq[idx];
  }

  /// 시간(天干) – 일간 기준 헤드 간에서 시지 인덱스만큼 진행
  /// 甲己日 起甲, 乙庚日 起丙, 丙辛日 起戊, 丁壬日 起庚, 戊癸日 起壬
  static String _hourGanFromDayGan(String dayGan, String hourZhi) {
    const headMap = {
      '甲': '甲', '己': '甲',
      '乙': '丙', '庚': '丙',
      '丙': '戊', '辛': '戊',
      '丁': '庚', '壬': '庚',
      '戊': '壬', '癸': '壬',
    };
    const ganSeq = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'];
    const zhiSeq = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];

    final headGan = headMap[dayGan] ?? '甲';
    final headIdx = ganSeq.indexOf(headGan);
    final zhiIdx  = zhiSeq.indexOf(hourZhi);
    return ganSeq[(headIdx + zhiIdx) % 10];
  }
  /// 외부에서 시간(天干) 계산에 접근할 수 있도록 공개 메서드
  static String hourGanFromDayGan(String dayGan, String hourZhi) {
    return _hourGanFromDayGan(dayGan, hourZhi);
  }

  // ── 유틸 ──────────────────────────────────────────────────────────
  static String _yyyyMMdd(DateTime dt) =>
      '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}';

  /// cd_terms_time: 'YYYYMMDDHHmm'(또는 유사) → DateTime
  static DateTime? _parseTerms(dynamic raw) {
    if (raw == null) return null;
    final s = raw.toString().replaceAll(RegExp(r'\D'), '');
    if (s.length < 12) return null;
    final y  = int.parse(s.substring(0, 4));
    final m  = int.parse(s.substring(4, 6));
    final d  = int.parse(s.substring(6, 8));
    final hh = int.parse(s.substring(8, 10));
    final mm = int.parse(s.substring(10, 12));
    return DateTime(y, m, d, hh, mm); // 타임존 오프셋 미적용: 원자료 그대로 비교
  }

  /// 월초 12절기만 인정(소한/입춘/경칩/청명/입하/망종/소서/입추/백로/한로/입동/대설)
  /// term_name이 없으므로 날짜대역(2~12일)로 식별
  static bool _isAcceptedTermDate(DateTime dt) => dt.day >= 2 && dt.day <= 12;
}
