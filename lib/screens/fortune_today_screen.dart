import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../constants/colors.dart';
import '../providers/profiles_provider.dart';
import '../models/saju_data.dart';
import '../utils/elemental_relations.dart';
import '../services/manse_loader.dart';
import '../widgets/today_memo_dialog.dart';
import 'main_navigation_screen.dart';

class FortuneTodayScreen extends ConsumerStatefulWidget {
  const FortuneTodayScreen({super.key});

  @override
  ConsumerState<FortuneTodayScreen> createState() => _FortuneTodayScreenState();
}

class _FortuneTodayScreenState extends ConsumerState<FortuneTodayScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  DateTime _logicalToday() {
    final now = DateTime.now();
    final anchor = DateTime(now.year, now.month, now.day, 23, 30);

    if (now.isBefore(anchor)) {
      return DateTime(now.year, now.month, now.day);
    } else {
      final tomorrow = now.add(const Duration(days: 1));
      return DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ 화면 보일 때마다 1회 재생 후 정지
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller
          ..reset()
          ..forward().whenComplete(() => _controller.stop());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider);

    if (profile == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('설정에서 프로필을 먼저 선택/추가하세요'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text("프로필 추가하기"),
                onPressed: () {
                  MainNavigationScreen.goToTab(4); // 👈 Settings 탭으로 이동
                },
              ),
            ],
          ),
        ),
      );
    }

    final today = _logicalToday();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${today.year}년 ${today.month}월 ${today.day}일'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: ManseLoader.get(today),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final todayRow = snap.data!;
          final todayGanZhi = todayRow['cd_hdganjee'] as String; // 예: "甲戌"
          final todayGan = todayGanZhi.substring(0, 1);
          final todayZhi = todayGanZhi.substring(1);

          final todayCounts = _countFromChars([todayGan, todayZhi]);

          // 점수 계산
          final score = _evaluateFortuneScore(
            profile.saju,
            todayCounts,
            todayZhi,
          );
          final resultText = fortuneLabel(score);

          return ListView(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── 오늘 운세 카드 ──
                  Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                        left: 40,
                        right: 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── Lottie 날씨 아이콘 ──
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: Lottie.asset(
                              _lottieForResult(resultText),
                              controller: _controller,
                              onLoaded: (composition) {
                                _controller
                                  ..duration = composition.duration
                                  ..forward().whenComplete(() {
                                    _controller.stop(); // ✅ 끝나면 멈춤
                                  });
                              },
                            ),
                          ),

                          // ── 오늘의 일진 ──
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                todayGan,
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'HangGang',
                                  height: 1.0,
                                  color: _colorForChar(todayGan),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                todayZhi,
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'HangGang',
                                  height: 1.0,
                                  color: _colorForChar(todayZhi),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // ── 오늘 운세 결과 텍스트 ──
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "오늘 당신의 운세는 ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: resultText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600, // ✅ 굵게
                                    decoration: TextDecoration.underline, // ✅ 밑줄
                                  ),
                                ),
                                const TextSpan(
                                  text: "이에요!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── 버튼 Column ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 내일 운세 미리보기 (광고 대체)
                        ElevatedButton.icon(
                          onPressed: () async {
                            final tomorrow = today.add(const Duration(days: 1));
                            final tomorrowRow = await ManseLoader.get(tomorrow);

                            if (tomorrowRow == null) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("내일 운세 데이터를 불러올 수 없습니다."),
                                ),
                              );
                              return;
                            }

                            final ganZhi = tomorrowRow['cd_hdganjee'] as String;
                            final gan = ganZhi.substring(0, 1);
                            final zhi = ganZhi.substring(1);

                            final tomorrowCounts = _countFromChars([gan, zhi]);
                            final score = _evaluateFortuneScore(
                              profile.saju,
                              tomorrowCounts,
                              zhi,
                            );
                            final resultText = fortuneLabel(score);

                            if (!context.mounted) return;
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: Lottie.asset(
                                          _lottieForResult(resultText),
                                          repeat: false,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: gan,
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'SourceHanSansSC',
                                                color: _colorForChar(gan), // ✅ 천간 색상
                                              ),
                                            ),
                                            TextSpan(
                                              text: zhi,
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'SourceHanSansSC',
                                                color: _colorForChar(zhi), // ✅ 지지 색상
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      const SizedBox(height: 16),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "내일 당신의 운세는 ",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: resultText,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600, // ✅ 굵게
                                                decoration: TextDecoration.underline, // ✅ 밑줄
                                              ),
                                            ),
                                            const TextSpan(
                                              text: "이에요!",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text("확인"),
                                      onPressed: () => Navigator.pop(ctx),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.ondemand_video, size: 20),
                          label: const Text("내일 운세 미리보기"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        // 오늘 하루 메모하기
                        // ────────── 오늘 하루 메모하기 버튼 ────────────────────
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => TodayMemoDialog(
                                todayGan: todayGan,
                                todayZhi: todayZhi,
                                today: today,
                                todayRow: todayRow,
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_note, size: 20),
                          label: const Text("오늘 하루 메모하기"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// 내 사주 오행 카운트
  static Map<String, int> _countElements(SajuData saju) {
    final chars = <String>[
      saju.yearGan,
      saju.yearZhi,
      saju.monthGan,
      saju.monthZhi,
      saju.dayGan,
      saju.dayZhi,
      if (saju.hasHour) saju.hourGan,
      if (saju.hasHour) saju.hourZhi,
    ];
    return _countFromChars(chars);
  }

  /// 글자 리스트 → 오행 카운트
  static Map<String, int> _countFromChars(List<String> chars) {
    final counts = {'목': 0, '화': 0, '토': 0, '금': 0, '수': 0};
    for (final ch in chars) {
      if (ch.isEmpty) continue;
      final el = stemToElement[ch] ?? branchToElement[ch];
      if (el != null) counts[el] = counts[el]! + 1;
    }
    return counts;
  }

  /// 하루 운세 판별 (점수)
  static int _evaluateFortuneScore(
    SajuData saju,
    Map<String, int> today,
    String todayZhi,
  ) {
    final sajuCounts = _countElements(saju);

    final weak = sajuCounts.entries
        .where((e) => e.value <= 1)
        .map((e) => e.key)
        .toSet();
    final strong = sajuCounts.entries
        .where((e) => e.value >= 2)
        .map((e) => e.key)
        .toSet();

    final todayElems = today.entries
        .where((e) => e.value > 0)
        .map((e) => e.key)
        .toSet();

    int score = 0;

    // ── 기본 규칙 ──
    if (todayElems.intersection(weak).length >= 2) {
      score = 20;
    } else if (todayElems.intersection(weak).length == 1) {
      score = 10;
    } else if (todayElems.intersection(strong).length >= 2) {
      score = -20;
    } else if (todayElems.intersection(strong).length == 1) {
      score = -10;
    } else {
      score = 0;
    }

    // ── 합/충 규칙 ──
    final monthZhi = saju.monthZhi;

    const chongPairs = {
      '子': '午',
      '午': '子',
      '巳': '亥',
      '亥': '巳',
      '寅': '申',
      '申': '寅',
      '卯': '酉',
      '酉': '卯',
      '辰': '戌',
      '戌': '辰',
      '丑': '未',
      '未': '丑',
    };

    const hapPairs = {
      '子': '丑',
      '丑': '子',
      '寅': '亥',
      '亥': '寅',
      '卯': '戌',
      '戌': '卯',
      '辰': '酉',
      '酉': '辰',
      '巳': '申',
      '申': '巳',
      '午': '未',
      '未': '午',
    };

    if (chongPairs[monthZhi] == todayZhi) {
      score -= 30;
    } else if (hapPairs[monthZhi] == todayZhi) {
      score += 30;
    }

    return score;
  }

  /// 점수 → 텍스트
  static String fortuneLabel(int score) {
    if (score >= 20) return '화창한 날';
    if (score >= 10) return '맑은 날';
    if (score >= -9) return '보통';
    if (score >= -19) return '흐린 날';
    return '아주 흐린 날';
  }

  /// 운세 결과 → Lottie 파일 경로
  static String _lottieForResult(String result) {
    switch (result) {
      case '화창한 날':
        return 'assets/lottie/Weather-sunny.json';
      case '맑은 날':
        return 'assets/lottie/Weather-partly cloudy.json';
      case '보통':
        return 'assets/lottie/Foggy.json';
      case '흐린 날':
        return 'assets/lottie/Weather-partly shower.json';
      case '아주 흐린 날':
        return 'assets/lottie/Weather-storm&showers(day).json';
      default:
        return 'assets/lottie/Foggy.json';
    }
  }
}

// ── 글씨 오행 컬러 매핑 ──
Color _colorForChar(String ch) {
  final el = stemToElement[ch] ?? branchToElement[ch];
  switch (el) {
    case '목':
      return AppColors.wood;
    case '화':
      return AppColors.fire;
    case '토':
      return AppColors.earth;
    case '금':
      return AppColors.metal;
    case '수':
      return AppColors.water;
    default:
      return Colors.black;
  }
}
