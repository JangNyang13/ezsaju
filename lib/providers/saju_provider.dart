import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/saju_data.dart';
import '../models/calendar_day.dart';
import '../services/manse_loader.dart';
import '../services/saju_calculator.dart';
import '../services/saju_storage.dart';
import '../services/module/shibsung_module.dart';
import '../services/module/yukchin_module.dart';
import '../services/module/unse_module.dart';
import '../services/module/goongtong_module.dart';
import '../services/module/japyung_module.dart';
import '../services/module/jeokcheon_module.dart';

/// ✅ 사주 상태 데이터
class SajuState {
  final bool isLoading;
  final SajuData? saju;
  final Map<String, dynamic>? interpretations;

  const SajuState({
    this.isLoading = false,
    this.saju,
    this.interpretations,
  });

  SajuState copyWith({
    bool? isLoading,
    SajuData? saju,
    Map<String, dynamic>? interpretations,
  }) {
    return SajuState(
      isLoading: isLoading ?? this.isLoading,
      saju: saju ?? this.saju,
      interpretations: interpretations ?? this.interpretations,
    );
  }
}

/// ✅ 사주 계산 및 상태관리 Notifier
class SajuNotifier extends Notifier<SajuState> {
  List<CalendarDay> _manse = [];

  @override
  SajuState build() => const SajuState(isLoading: false);

  /// ✅ 만세력 초기화
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      _manse = await ManseLoader.load();
      debugPrint('📘 만세력 데이터 ${_manse.length}건 로드 완료');
    } catch (e, st) {
      debugPrint('❌ 만세력 로드 실패: $e');
      debugPrint(st.toString());
    }
    state = state.copyWith(isLoading: false);
  }

  /// ✅ 사주 계산
  Future<void> calculate(DateTime birthDateTime) async {
    try {
      if (_manse.isEmpty) await initialize();

      state = state.copyWith(isLoading: true);

      final calculator = SajuCalculator(_manse);
      final saju = calculator.calculate(birthDateTime);

      await SajuStorage.save(saju);
      final interpretations = _interpretAll(saju);

      state = state.copyWith(
        saju: saju,
        interpretations: interpretations,
        isLoading: false,
      );

      debugPrint('✅ 사주 계산 완료: ${saju.yearPillar} / ${saju.monthPillar} / ${saju.dayPillar} / ${saju.hourPillar}');
    } catch (e, st) {
      debugPrint('❌ 사주 계산 실패: $e');
      debugPrint(st.toString());
      state = state.copyWith(isLoading: false);
      rethrow; // 화면에서 AlertDialog로 표시
    }
  }

  /// ✅ 저장된 사주 불러오기
  Future<void> loadSaved() async {
    try {
      final saved = await SajuStorage.load();
      if (saved == null) return;
      final interpretations = _interpretAll(saved);
      state = state.copyWith(saju: saved, interpretations: interpretations);
      debugPrint('📦 저장된 사주 불러오기 완료');
    } catch (e) {
      debugPrint('⚠️ 저장된 사주 불러오기 실패: $e');
    }
  }

  /// ✅ 전체 해석 모듈 실행
  Map<String, dynamic> _interpretAll(SajuData saju) {
    final tenGods = ShibsungModule.interpret(saju);
    return {
      '십성': tenGods,
      '육친': YukchinModule.interpret(tenGods),
      '12운성': UnseModule.interpret(saju),
      '궁통보감': GoongtongModule.interpret(saju),
      '자평진전': JapyungModule.interpret(saju),
      '적천수': JeokcheonModule.interpret(saju),
    };
  }



  /// ✅ 초기화 (데이터 삭제)
  Future<void> clear() async {
    await SajuStorage.clear();
    state = const SajuState();
    debugPrint('🧹 사주 데이터 초기화 완료');
  }
}

/// ✅ 전역 Provider (정상 선언)
final sajuProvider =
NotifierProvider<SajuNotifier, SajuState>(SajuNotifier.new);
