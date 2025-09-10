// lib/repositories/profiles_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saju_data.dart';
import '../models/user_profile.dart';
import '../services/saju_calculator.dart';
import '../services/manse_loader.dart';
import '../utils/elemental_relations.dart';

class ProfilesRepository {
  static const _prefsKey = 'profiles_json';
  static const _max = 3;

  ProfilesRepository._();
  static final ProfilesRepository instance = ProfilesRepository._();

  final List<UserProfile> _cache = [];
  bool _loaded = false;

  Future<List<UserProfile>> fetchAll() async {
    await _loadIfNeeded();
    return List.unmodifiable(_cache);
  }

  // ✅ timeUnknown 추가
  Future<void> addProfile({
    required String name,
    required DateTime birth,
    required String gender,
    bool timeUnknown = false,             // ✅
  }) async {
    await _loadIfNeeded();
    if (_cache.length >= _max) {
      throw Exception('프로필은 최대 $_max 명까지 저장할 수 있습니다');
    }

    final manse = await ManseLoader.load();
    final saju = SajuCalculator.fromDateTime(birth, manse, timeUnknown: timeUnknown); // ✅
    final missing = _calcMissing(saju);

    _cache.add(UserProfile(
      name: name,
      birth: birth,
      gender: gender,
      timeUnknown: timeUnknown,  // ✅
      saju: saju,
      missingElements: missing,
    ));
    await _save();
  }

  // ✅ update 시에도 사주/누락오행 재계산 (birth/gender/timeUnknown 바뀔 수 있으니)
  Future<void> updateProfile(int index, UserProfile profile) async {
    await _loadIfNeeded();
    if (index < 0 || index >= _cache.length) return;

    final manse = await ManseLoader.load();
    final saju = SajuCalculator.fromDateTime(
      profile.birth,
      manse,
      timeUnknown: profile.timeUnknown, // ✅
    );
    final missing = _calcMissing(saju);

    _cache[index] = profile.copyWith(
      saju: saju,
      missingElements: missing,
    );
    await _save();
  }

  Future<void> deleteProfile(int index) async {
    await _loadIfNeeded();
    if (index < 0 || index >= _cache.length) return;
    _cache.removeAt(index);
    await _save();
  }

  Future<void> _loadIfNeeded() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      _cache
        ..clear()
        ..addAll(list.map(UserProfile.fromJson));
    }
    _loaded = true;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_cache.map((p) => p.toJson()).toList());
    await prefs.setString(_prefsKey, raw);
  }

  // ✅ 시주 없을 수도 있으니, '-'/null은 건너뛰고 카운트
  List<String> _calcMissing(SajuData saju) {
    final counts = {'목': 0, '화': 0, '토': 0, '금': 0, '수': 0};

    // 천간
    final gans = [saju.yearGan, saju.monthGan, saju.dayGan];
    if (saju.hasHour) gans.add(saju.hourGan);

    for (final g in gans) {
      final elem = stemToElement[g];
      if (elem != null) counts[elem] = (counts[elem] ?? 0) + 1;
    }

    // 지지
    final zhis = [saju.yearZhi, saju.monthZhi, saju.dayZhi];
    if (saju.hasHour) zhis.add(saju.hourZhi);

    for (final z in zhis) {
      final elem = branchToElement[z];
      if (elem != null) counts[elem] = (counts[elem] ?? 0) + 1;
    }

    // 누락된 오행 반환
    return counts.entries.where((e) => e.value == 0).map((e) => e.key).toList();
  }

}
