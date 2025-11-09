import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calendar_day.dart';
import '../models/profile_model.dart';
import '../models/saju_data.dart';
import '../providers/selected_profile_provider.dart';
import '../constants/app_colors.dart';
import '../services/manse_loader.dart';
import '../services/saju_calculator.dart';
import '../widgets/profile_header.dart';
import '../widgets/saju_box_view.dart';
import '../widgets/daewoon_section.dart';

class SajuViewerScreen extends ConsumerStatefulWidget {
  const SajuViewerScreen({super.key});

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

  Future<void> _calculateIfProfileExists() async {
    final profile = ref.read(selectedProfileProvider);
    if (profile == null) return;

    setState(() => _loading = true);
    try {
      final manse = await ManseLoader.load();
      final calculator = SajuCalculator(manse);
      final result = calculator.calculate(profile.birthDate);

      setState(() {
        _saju = result;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ 사주 계산 실패: $e')),
      );
    }
  }

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
    final profile = ref.watch(selectedProfileProvider);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이름과 프로필 정보
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
                  // 🔹 사주팔자 및 신살
                  SajuBoxView(saju: _saju!, profile: profile),

                  const SizedBox(height: 8),

                  const Divider(
                    height: 15,
                    thickness: 1,
                    color: AppColors.primary,
                    indent: 8,
                    endIndent: 8,
                  ),

                  // 🔹 대운 / 세운 / 월운
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
