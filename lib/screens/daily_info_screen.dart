import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/text_styles.dart';
import '../models/calendar_day.dart';
import '../models/saju_data.dart';
import '../models/stem_branch.dart';
import '../services/manse_loader.dart';
import '../services/saju_calculator.dart';
import '../constants/app_colors.dart';
import '../utils/solar_term_color.dart';
import '../utils/solar_term_effect.dart';
import '../widgets/wavy_term_bar.dart';

class DailyInfoScreen extends ConsumerStatefulWidget {
  const DailyInfoScreen({super.key});

  @override
  ConsumerState<DailyInfoScreen> createState() => _DailyInfoScreenState();
}

class _DailyInfoScreenState extends ConsumerState<DailyInfoScreen> {
  CalendarDay? todayData;
  SajuData? saju;

  /// 절기 + 사주 데이터 로드 함수
  Future<void> _loadTodayData() async {
    final manse = await ManseLoader.load();
    final today = DateTime.now();

    // 오늘 날짜 찾기
    final todayInfo = manse.firstWhere(
          (d) =>
      d.solarYear == today.year &&
          d.solarMonth == today.month &&
          d.solarDay == today.day,
      orElse: () => manse.last,
    );

    // 절기 지속 적용 (이전 절기 유지)
    String? activeTermName = todayInfo.termName;
    if (activeTermName == null) {
      for (int i = manse.indexOf(todayInfo) - 1; i >= 0; i--) {
        if (manse[i].termName != null) {
          activeTermName = manse[i].termName;
          break;
        }
      }
    }

    // 사주 계산 (오늘 날짜 기준)
    final calculator = SajuCalculator(manse);
    final sajuData = calculator.calculate(today);

    if (!mounted) return;
    setState(() {
      todayData = todayInfo.copyWith(termName: activeTermName);
      saju = sajuData;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTodayData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        elevation: 0,
        title: todayData == null
            ? const SizedBox()
            : Text(
          "${todayData!.solarYear}년 ${todayData!.solarMonth}월 ${todayData!.solarDay}일",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      body: todayData == null
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  /// 메인 콘텐츠
  Widget _buildContent() {
    final today = todayData!;
    final iljin = today.hdGanJee; // 예: 甲子
    final termName = today.termName ?? "절기 없음";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 절기 표시 바
          _buildSolarTermBar(termName),
          const SizedBox(height: 30),

          // 오늘의 일진
          _buildIljinCard(iljin),
          const SizedBox(height: 30),

          // 운세 정보
          _buildPersonalFortune(iljin),
        ],
      ),
    );
  }

  /// 절기 표시 물결 바
  Widget _buildSolarTermBar(String termName) {
    final effect = getSolarTermEffect(termName);

    if (termName == "절기 없음") {
      return WavyTermBar(
        label: termName,
        subtitle: effect,
        primaryColor: AppColors.earth,
        secondaryColor: AppColors.earth,
        backgroundColor: AppColors.earth.withValues(alpha: 0.15),
      );
    }

    final manse = ManseLoader.cachedData;
    DateTime? termStartDate;

    if (manse != null) {
      for (final day in manse) {
        if (day.termName == termName) {
          termStartDate =
              DateTime(day.solarYear, day.solarMonth, day.solarDay);
          break;
        }
      }
    }

    termStartDate ??= DateTime.now();
    final dayOffset = DateTime.now().difference(termStartDate).inDays;
    final colors = getSolarTermColors(termName, dayOffset);

    return WavyTermBar(
      label: termName,
      subtitle: effect,
      primaryColor: colors.primary,
      secondaryColor: colors.secondary,
      backgroundColor: colors.primary.withValues(alpha: 0.15),
    );
  }

  /// 오늘의 일진 카드
  Widget _buildIljinCard(String iljin) {
    final stem = iljin.substring(0, 1);
    final branch = iljin.substring(1, 2);

    final stemElement = heavenlyStems.firstWhere(
          (e) => e.name == stem,
      orElse: () => const StemBranch(name: '', element: '', yinYang: ''),
    ).element;

    final branchElement = earthlyBranches.firstWhere(
          (e) => e.name == branch,
      orElse: () => const StemBranch(name: '', element: '', yinYang: ''),
    ).element;

    final stemColor = AppColors.elementColor(stemElement);
    final branchColor = AppColors.elementColor(branchElement);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("오늘의 일진", style: AppTextStyles.titleMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stem,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: stemColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                branch,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: branchColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 개인 운세 카드 (이름 표시 제거)
  Widget _buildPersonalFortune(String iljin) {
    final fortuneMsg = switch (iljin.substring(0, 1)) {
      '甲' => '새로운 시작에 적합한 하루입니다.',
      '乙' => '유연하게 대처하면 복이 따릅니다.',
      '丙' => '열정이 넘치지만 과열에 주의하세요.',
      '丁' => '세심함이 빛나는 하루입니다.',
      '戊' => '안정과 신뢰가 중심이 되는 날입니다.',
      '己' => '정리와 계획에 집중하면 좋습니다.',
      '庚' => '결단력이 필요한 시점입니다.',
      '辛' => '차분히 행동하면 길합니다.',
      '壬' => '마음이 넓어지는 하루입니다.',
      '癸' => '감정이 예민해지니 휴식이 필요합니다.',
      _ => '평온한 하루입니다.',
    };

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.card,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            const Text('오늘의 운세', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              fortuneMsg,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            Text(
              '($iljin) 일진 기준 해석',
              style:
              AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
