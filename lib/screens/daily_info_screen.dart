import 'package:ezsaju/screens/simulation_saju_screen.dart';
import 'package:ezsaju/screens/sipsung_calc_screen.dart';
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
          const SizedBox(height: 10),

          // 오늘의 일진
          _buildIljinCard(iljin),
          const SizedBox(height: 10),

          // 운세 정보
          _buildPersonalFortune(iljin),
          const SizedBox(height: 20),

          // 사주 시뮬레이션
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 십성 계산 툴 버튼 추가
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SipsungCalcScreen()),
                  );
                },
                child: const Text(
                  "십성 계산 도구",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              //사주 시뮬레이션
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SimulationSajuScreen()),
                  );
                },
                child: const Text(
                  "사주 시뮬레이션",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

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
      '甲' => ' 갑목은 시작과 전진의 기운으로, 저항을 뚫고 위로 솟구치려는 의지가 강하며 중력의 기운을 이겨냅니다.',
      '乙' => '을목은 덩굴식물처럼 부드럽게 뻗어 나가며, 때를 얻으면 번영하지만 그렇지 못하면 마르거나 썩는 특징이 있습니다.',
      '丙' => '병화는 발산하는 태양의 기운으로, 겉으로 드러나고 창의적인 성향을 가집니다.',
      '丁' => '정화는 빛나는 등불의 기운으로, 병화(丙)보다 은밀하게 빛나며 내면의 에너지가 강합니다.',
      '戊' => '무토는 만물을 포용하는 넓고 안정적인 대지(흙)의 기운입니다.',
      '己' => '기토는 무토(戊)와 같은 흙이지만, 밭이나 논처럼 가꾸고 기름진 토지의 의미를 지닙니다.',
      '庚' => '경금은 단단한 바위나 광석의 기운으로, 굳건하고 강인한 성질을 가지고 있습니다.',
      '辛' => '신금은 보석이나 칼날의 기운으로, 예리하고 날카로우며 섬세한 면이 있습니다.',
      '壬' => '임수는 바다처럼 넓고 깊은 물의 기운으로, 지혜롭고 지적인 능력이 뛰어납니다.',
      '癸' => '계수는 이슬이나 비, 눈처럼 차분하고 부드러운 물의 기운으로, 임수(壬)보다 은밀하고 침착합니다.',
      _ => '',
    };
    final fortuneMsg2 = switch (iljin.substring(1, 2)) {
      '子' => '자수는 지혜롭고 유연하며 변화에 민첩한 수(水)의 기운입니다.',
      '丑' => '축토는 인내심 강하고 느리지만 끝까지 완수하는 겨울 토(土)의 기운입니다.',
      '寅' => '인목은 추진력과 개척정신이 강한 생동하는 목(木)의 기운입니다.',
      '卯' => '묘목은 부드럽고 예술적 감성이 풍부한 균형 잡힌 목(木)의 기운입니다.',
      '辰' => '진토는 현실 감각과 통솔력이 뛰어난 변화무쌍한 봄의 토(土) 기운입니다.',
      '巳' => '사화는 예리하고 직관적이며 비밀을 간직한 불(火)의 기운입니다.',
      '午' => '오화는 활달하고 열정적이며 강렬한 자기표현의 불(火)의 기운입니다.',
      '未' => '미토는 온화하고 세심하며 타인을 배려하는 포용적 여름 토(土)의 기운입니다.',
      '申' => '신금은 영리하고 분석적이며 전략적인 금(金)의 기운입니.',
      '酉' => '유금은 세련되고 정제된 감각과 완벽주의가 돋보이는 금(金)의 기운입니다.',
      '戌' => '술토는 의리와 책임감이 강하고 정의로운 가을 토(土)의 기운입니다.',
      '亥' => '해수는 포용력 있고 감수성이 풍부하며 깊은 내면을 가진 수(水)의 기운입니다.',
      _ => '',
    };

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.card,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Text('$iljin 천간과 지지 특징', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              fortuneMsg,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12,),
            Text(
              fortuneMsg2,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
