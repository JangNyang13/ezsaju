import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../constants/colors.dart';
import '../providers/profiles_provider.dart';
import '../models/saju_data.dart';
import '../repositories/memo_repository.dart';
import '../utils/elemental_relations.dart';
import '../services/manse_loader.dart';

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
    _controller = AnimationController(vsync: this);
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
      return const Scaffold(body: Center(child: Text('설정에서 프로필을 먼저 선택/추가하세요')));
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
            padding: const EdgeInsets.all(12),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Lottie 날씨 아이콘 (한 번만 재생 후 정지) ──
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

                  const SizedBox(height: 12),

                  // ── 오늘의 일진 (세로 표시) ──
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        todayGan,
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'SourceHanSansSC',
                          height: 1.0,
                          color: _colorForChar(todayGan),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        todayZhi,
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'SourceHanSansSC',
                          height: 1.0,
                          color: _colorForChar(todayZhi),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── 운세 결과 텍스트 ──
                  Text(
                    resultText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── 버튼 Row ──
                  Row(
                    children: [
                      // 오늘 하루 메모하기
                      // ────────── 오늘 하루 메모하기 버튼 ────────────────────
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final memoCtrl = TextEditingController();
                            String? selectedFeeling;

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return SingleChildScrollView(
                                        padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 20,
                                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                                          // ✅ 키보드 높이만큼 패딩 추가
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "오늘 하루 메모하기",
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),

                                            const SizedBox(height: 12),

                                            // 오늘의 일진 표시
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: todayGan,
                                                    style: TextStyle(
                                                      fontSize: 64,
                                                      fontWeight: FontWeight.bold,
                                                      color: _colorForChar(todayGan),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: todayZhi,
                                                    style: TextStyle(
                                                      fontSize: 64,
                                                      fontWeight: FontWeight.bold,
                                                      color: _colorForChar(todayZhi),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),

                                            const SizedBox(height: 12),

                                            // 5단계 버튼 (아이콘 + 라벨)
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                {"label": "화창함", "icon": Icons.sentiment_very_satisfied},
                                                {"label": "맑음", "icon": Icons.sentiment_satisfied},
                                                {"label": "보통", "icon": Icons.sentiment_neutral},
                                                {"label": "흐림", "icon": Icons.sentiment_dissatisfied},
                                                {"label": "아주흐림", "icon": Icons.sentiment_very_dissatisfied},
                                              ].map((item) {
                                                final label = item["label"] as String;
                                                final icon = item["icon"] as IconData;
                                                final isSelected = selectedFeeling == label;

                                                return GestureDetector(
                                                  onTap: () => setState(() => selectedFeeling = label),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(icon, size: 36,
                                                          color: isSelected ? Colors.blue : Colors.grey),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        label,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: isSelected ? Colors.blue : Colors.grey,
                                                          fontWeight: isSelected
                                                              ? FontWeight.bold
                                                              : FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),

                                            const SizedBox(height: 12),

                                            // 메모 입력
                                            TextField(
                                              controller: memoCtrl,
                                              maxLength: 140,
                                              maxLines: 3,
                                              decoration: const InputDecoration(
                                                hintText: "오늘 하루를 짧게 기록해보세요",
                                                border: OutlineInputBorder(),
                                              ),
                                            ),

                                            const SizedBox(height: 12),

                                            // 액션 버튼
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  child: const Text("취소"),
                                                  onPressed: () => Navigator.pop(ctx),
                                                ),
                                                ElevatedButton(
                                                  child: const Text("저장"),
                                                  onPressed: () async {
                                                    if (selectedFeeling == null) return;

                                                    final dateKey =
                                                        "${today.year}-${today.month}-${today.day}";

                                                    await MemoRepository.addMemo(
                                                      date: dateKey,
                                                      feeling: selectedFeeling!,
                                                      memo: memoCtrl.text,
                                                      yearGanZhi: todayRow['cd_hyganjee'] as String,
                                                      monthGanZhi: todayRow['cd_hmganjee'] as String,
                                                      dayGanZhi: todayRow['cd_hdganjee'] as String,
                                                    );

                                                    if (!context.mounted) return;
                                                    Navigator.pop(ctx);

                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text("오늘 메모가 저장되었습니다.")),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );

                          },
                          icon: const Icon(Icons.edit_note, size: 20),
                          label: const Text("오늘 하루 메모하기"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),

                      // 내일 운세 미리보기 (광고)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: 광고 시청 후 내일 운세 보여주기
                          },
                          icon: const Icon(Icons.ondemand_video, size: 20),
                          label: const Text("내일 운세 미리보기"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
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
