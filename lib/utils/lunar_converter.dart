import 'dart:async';
import '../services/manse_loader.dart';

/// 음력 -> 양력 변환 유틸 (manse.json 기반)
///
/// - 입력: 음력 (ly, lm, ld, isLeap)
/// - 출력: 양력 DateTime(연-월-일). 시간은 포함하지 않음.
/// - 성능: 최초 1회 로드시 1900~2100 전체 인덱스 구축(약 7만건). 이후 O(1) 조회.
class LunarConverter {
  static Map<String, DateTime>? _index;

  /// 인덱스 키: 'LY-LM-LD-LEAP'  (두 자리 zero-pad)
  static String _k(int ly, int lm, int ld, bool isLeap) =>
      '$ly-${lm.toString().padLeft(2, '0')}-${ld.toString().padLeft(2, '0')}-${isLeap ? 1 : 0}';

  static Future<void> _ensureIndex() async {
    if (_index != null) return;
    final map = await ManseLoader.load(); // yyyyMMdd -> record
    final out = <String, DateTime>{};
    for (final e in map.values) {
      // 데이터 예: cd_ly: 1899, cd_lm: "12", cd_ld: "6", cd_leap_month: 0
      final ly = (e['cd_ly'] as num).toInt();
      final lm = int.parse(e['cd_lm'].toString());
      final ld = int.parse(e['cd_ld'].toString());
      final leap = (e['cd_leap_month'] as num?)?.toInt() == 1;

      final sy = (e['cd_sy'] as num).toInt();
      final sm = int.parse(e['cd_sm'].toString());
      final sd = int.parse(e['cd_sd'].toString());

      out[_k(ly, lm, ld, leap)] = DateTime(sy, sm, sd);
    }
    _index = out;
  }

  /// 음력(평달/윤달) → 양력
  static Future<DateTime?> lunarToSolar({
    required int lunarYear,
    required int lunarMonth,
    required int lunarDay,
    required bool isLeapMonth,
  }) async {
    await _ensureIndex();
    return _index![_k(lunarYear, lunarMonth, lunarDay, isLeapMonth)];
  }
}
