import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/text_styles.dart';
import '../models/calendar_day.dart';
import '../models/profile_model.dart';
import '../models/saju_data.dart';
import '../models/stem_branch.dart';
import '../providers/selected_profile_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _loadTodayData(); // 절기 + 일진 로드
  }

  /// 오늘 날짜의 절기 및 사주 데이터 불러오기
  Future<void> _loadTodayData() async {
    final profile = ref.read(selectedProfileProvider);
    if (profile == null) return;

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

    // 사주 계산
    final calculator = SajuCalculator(manse);
    final sajuData = calculator.calculate(profile.birthDate);

    setState(() {
      todayData = todayInfo.copyWith(termName: activeTermName);
      saju = sajuData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(selectedProfileProvider);

    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('⚠️ 먼저 프로필을 선택하세요.')),
      );
    }

    return Scaffold(
      appBar: AppBar( // ① 오늘 날짜 (서기)
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
          : _buildContent(profile),
    );
  }

  Widget _buildContent(Profile profile) {
    final today = todayData!;
    final iljin = today.hdGanJee; // 예: 甲子
    final termName = today.termName ?? "절기 없음";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ② 절기 표시 (Shimmer Bar)
          _buildSolarTermBar(termName),

          const SizedBox(height: 30),

          // ③ 오늘의 일진
          _buildIljinCard(iljin),

          const SizedBox(height: 30),

          // ④ 선택된 프로필의 대운 / 세운 / 월운 (임시 Placeholder)
          _buildFortunePlaceholder(profile),
        ],
      ),
    );
  }

  /// 절기 표시 물결 바 (절기별 오행 색 자동 적용)===============================
  Widget _buildSolarTermBar(String termName) {
    // 🔹 절기 설명 텍스트 가져오기
    final effect = getSolarTermEffect(termName);

    if (termName == "절기 없음") {
      // 절기 없을 때 기본색
      return WavyTermBar(
        label: termName,
        subtitle: effect,
        primaryColor: AppColors.earth,
        secondaryColor: AppColors.earth,
        backgroundColor: AppColors.earth.withValues(alpha: 0.15),
      );
    }

    // 🔹 절기 시작일 계산 (기존 코드 유지)
    final manse = ManseLoader.cachedData;
    DateTime? termStartDate;

    if (manse != null) {
      for (final day in manse) {
        if (day.termName == termName) {
          termStartDate = DateTime(day.solarYear, day.solarMonth, day.solarDay);
          break;
        }
      }
    }

    termStartDate ??= DateTime.now();
    final dayOffset = DateTime.now().difference(termStartDate).inDays;
    final colors = getSolarTermColors(termName, dayOffset);

    return WavyTermBar(
      label: termName,
      subtitle: effect, //해설문 추가
      primaryColor: colors.primary,
      secondaryColor: colors.secondary,
      backgroundColor: colors.primary.withValues(alpha: 0.15),
    );
  }//==============================================================



  /// 오늘의 일진 카드
  Widget _buildIljinCard(String iljin) {
    // 천간, 지지 분리
    final stem = iljin.substring(0, 1);
    final branch = iljin.substring(1, 2);

    // 천간/지지의 오행 요소 찾기
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
          const Text(
            "오늘의 일진",
            style: AppTextStyles.titleMedium,
          ),
          // 천간+지지를 색상별로 구분하여 표시
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
              const SizedBox(width: 4), // 천간-지지 간격
              Text(
                branch,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: branchColor,
                ),
              ),
            ],
          )


        ],
      ),
    );
  }

  /// 운세 정보 Placeholder (추후 모듈 연결 예정)
  Widget _buildFortunePlaceholder(Profile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          "- 공지 -\n앞으로의 진행과정",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text("대운과 세운, 월운은 개발중입니다."),
        Text("11월에 완성됩니다."),
        Text("12월에는 격국론과 해석이 추가됩니다."),
      ],
    );
  }


}