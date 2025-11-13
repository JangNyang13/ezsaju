import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calendar_day.dart';
import '../models/profile_model.dart';
import '../models/saju_data.dart';
import '../providers/selected_profile_provider.dart';
import '../constants/app_colors.dart';
import '../services/manse_loader.dart';
import '../services/module/sinsal_module.dart';
import '../services/saju_calculator.dart';
import '../widgets/profile_header.dart';
import '../widgets/saju_box_view.dart';
import '../widgets/daewoon_section.dart';

class SajuViewerScreen extends ConsumerStatefulWidget {
  final Profile? profileOverride;
  const SajuViewerScreen({super.key, this.profileOverride});

  @override
  ConsumerState<SajuViewerScreen> createState() => _SajuViewerScreenState();
}

class _SajuViewerScreenState extends ConsumerState<SajuViewerScreen> {
  SajuData? _saju;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculateIfProfileExists();
  }

  /// ✅ 사주 계산 (이제 항상 양력으로 저장되어 있으므로 변환 불필요)
  Future<void> _calculateIfProfileExists() async {
    final profile = widget.profileOverride ?? ref.read(selectedProfileProvider);
    if (profile == null) return;

    setState(() => _loading = true);
    try {
      final manse = await ManseLoader.load();
      if (manse.isEmpty) throw Exception('만세력 데이터 로드 실패');

      final calculator = SajuCalculator(manse);
      final result = calculator.calculate(
        profile.birthDate,
        isLunar: false, // ✅ 항상 양력 기준 계산
        isLeapMonth: profile.isLeapMonth,
      );

      if (!mounted) return;
      setState(() {
        _saju = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ 사주 계산 실패: $e')),
      );
    }
  }

  /// ✅ 만세력 매칭 (양력 기준으로만)
  Future<CalendarDay?> _findManseDate(Profile profile) async {
    final manse = await ManseLoader.load();

    return manse.firstWhere(
          (d) =>
      d.solarYear == profile.birthDate.year &&
          d.solarMonth == profile.birthDate.month &&
          d.solarDay == profile.birthDate.day,
      orElse: () => CalendarDay(
        solarYear: profile.birthDate.year,
        solarMonth: profile.birthDate.month,
        solarDay: profile.birthDate.day,
        lunarYear: profile.birthDate.year,
        lunarMonth: profile.birthDate.month,
        lunarDay: profile.birthDate.day,
        hyGanJee: '',
        hmGanJee: '',
        hdGanJee: '',
        isLeapMonth: false,
        isHoliday: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profileOverride ?? ref.watch(selectedProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('사주 조회'),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: profile == null
          ? const Center(
        child: Text(
          '⚠️ 설정에서 프로필을 선택하세요.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      )
          : _loading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<CalendarDay?>(
        future: _findManseDate(profile),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lunar = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 이름 + 프로필 헤더
                ProfileHeader(profile: profile, lunar: lunar),

                const Divider(
                  height: 15,
                  thickness: 1,
                  color: AppColors.primary,
                  indent: 8,
                  endIndent: 8,
                ),

                if (_saju == null)
                  const Text('사주 데이터를 불러오는 중입니다...')
                else ...[
                  // 사주팔자 및 신살
                  SajuBoxView(saju: _saju!, profile: profile),

                  // 공망 표시
                  Builder(builder: (_) {
                    final sinsal = SinsalEngine.interpret(_saju!);
                    final gongInfo =
                    sinsal['공망정보'] as Map<String, List<String>>?;
                    if (gongInfo == null) return const SizedBox.shrink();

                    final yearGong = gongInfo['년공망']?.join(', ') ?? '';
                    final dayGong = gongInfo['일공망']?.join(', ') ?? '';

                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '(일)공망 : $dayGong   (년)공망 : $yearGong',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }),

                  const Divider(
                    height: 15,
                    thickness: 1,
                    color: AppColors.primary,
                    indent: 8,
                    endIndent: 8,
                  ),

                  // 대운 / 세운 / 월운
                  DaewoonSection(
                    saju: _saju!,
                    birthDate: profile.birthDate,
                    isMale: profile.gender == '남',
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
