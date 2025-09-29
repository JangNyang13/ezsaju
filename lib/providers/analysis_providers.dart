// lib/providers/analysis_providers.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/saju_data.dart';
import '../models/analysis_report.dart';
import '../models/day_fortune.dart';
import '../services/analysis/analysis_engine.dart';
import '../services/analysis/daily_fortune_evaluator.dart';

/// ─────────────────────────────────────────────────────────────
/// 싱글턴처럼 재사용: 엔진 / 오늘의 운세 평가기
/// (앱 생명주기 동안 계속 유지되도록 keepAlive)
/// ─────────────────────────────────────────────────────────────
final analysisEngineProvider = FutureProvider<AnalysisEngine>((ref) async {
  ref.keepAlive();
  return AnalysisEngine.create();
});

final dailyEvaluatorProvider =
FutureProvider<DailyFortuneEvaluator>((ref) async {
  ref.keepAlive();
  return DailyFortuneEvaluator.create();
});

/// ─────────────────────────────────────────────────────────────
/// 사주 해석 Provider
/// ─────────────────────────────────────────────────────────────
final analysisReportProvider =
FutureProvider.family<AnalysisReport, SajuData>((ref, saju) async {
  final engine = await ref.watch(analysisEngineProvider.future);
  return engine.analyze(saju);
});

/// ─────────────────────────────────────────────────────────────
/// 오늘 운세 Provider
/// ─────────────────────────────────────────────────────────────
final todayFortuneProvider =
FutureProvider.family<DayFortune, SajuData>((ref, saju) async {
  final eval = await ref.watch(dailyEvaluatorProvider.future);
  return eval.evaluate(saju, DateTime.now());
});

/// ─────────────────────────────────────────────────────────────
/// narrations.json 로더 & strength[level] 라인 Provider
/// (오늘의 운세처럼 assets에서 가져와 UI에 바로 뿌리기)
/// ─────────────────────────────────────────────────────────────
final narrationsJsonProvider =
FutureProvider<Map<String, dynamic>>((ref) async {
  ref.keepAlive();
  final raw =
  await rootBundle.loadString('assets/data/analysis/narrations.json');
  return jsonDecode(raw) as Map<String, dynamic>;
});

/// strength 섹션만 레벨별로 뽑아오기
final strengthLinesProvider =
FutureProvider.family<List<String>, String>((ref, String level) async {
  final narr = await ref.watch(narrationsJsonProvider.future);
  final byLevel = narr['strength']?[level];
  if (byLevel is List) return byLevel.cast<String>();
  return const <String>[];
});
