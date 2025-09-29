import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../repositories/memo_repository.dart';
import '../utils/elemental_relations.dart';

class TodayMemoDialog extends StatefulWidget {
  final String todayGan;
  final String todayZhi;
  final DateTime today;
  final Map<String, dynamic> todayRow;

  const TodayMemoDialog({
    super.key,
    required this.todayGan,
    required this.todayZhi,
    required this.today,
    required this.todayRow,
  });

  @override
  State<TodayMemoDialog> createState() => _TodayMemoDialogState();
}

class _TodayMemoDialogState extends State<TodayMemoDialog> {
  late final TextEditingController memoCtrl;
  String? selectedFeeling;

  @override
  void initState() {
    super.initState();
    memoCtrl = TextEditingController();
  }

  @override
  void dispose() {
    memoCtrl.dispose(); // ✅ 여기서 안전하게 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("오늘 하루 메모하기",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // 오늘의 일진 표시
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: widget.todayGan,
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: _colorForChar(widget.todayGan),
                  ),
                ),
                TextSpan(
                  text: widget.todayZhi,
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: _colorForChar(widget.todayZhi),
                  ),
                ),
              ]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 기분 선택 버튼들
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
                    children: [
                      Icon(icon, size: 36,
                          color: isSelected ? Colors.blue : Colors.grey),
                      const SizedBox(height: 4),
                      Text(label,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.blue : Colors.grey,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          )),
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
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text("저장"),
                  onPressed: () async {
                    if (selectedFeeling == null) return;

                    final dateKey =
                        "${widget.today.year}-${widget.today.month}-${widget.today.day}";

                    await MemoRepository.addMemo(
                      date: dateKey,
                      feeling: selectedFeeling!,
                      memo: memoCtrl.text,
                      yearGanZhi: widget.todayRow['cd_hyganjee'] as String,
                      monthGanZhi: widget.todayRow['cd_hmganjee'] as String,
                      dayGanZhi: widget.todayRow['cd_hdganjee'] as String,
                    );

                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("오늘 메모가 저장되었습니다.")),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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