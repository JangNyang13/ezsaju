// lib/screens/memo_archive_screen.dart
import 'package:flutter/material.dart';
import '../repositories/memo_repository.dart';
import '../constants/colors.dart';
import '../utils/elemental_relations.dart';
import '../constants/text_styles.dart';
import '../utils/ganji_describe.dart';

class MemoArchiveScreen extends StatefulWidget {
  const MemoArchiveScreen({super.key});

  @override
  State<MemoArchiveScreen> createState() => _MemoArchiveScreenState();
}

class _MemoArchiveScreenState extends State<MemoArchiveScreen> {
  List<Map<String, dynamic>> _memos = [];
  String _selectedFilter = "전체";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await MemoRepository.fetchAll();
    setState(() => _memos = list.reversed.toList()); // 최신순 정렬
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedFilter == "전체"
        ? _memos
        : _memos.where((m) => m["feeling"] == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("운세 보관함")),
      body: Column(
        children: [
          // ── 필터 바 ──
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["전체", "화창함", "맑음", "보통", "흐림", "아주흐림"].map((f) {
                  final selected = _selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: selected,
                      selectedColor: Colors.blue.shade200,
                      onSelected: (_) => setState(() => _selectedFilter = f),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),

          // ── 메모 리스트 ──
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("저장된 메모가 없습니다."))
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final m = filtered[i];
                      final year = m["yearGanZhi"] as String? ?? "—";
                      final month = m["monthGanZhi"] as String? ?? "—";
                      final day = m["dayGanZhi"] as String? ?? "—";

                      return Dismissible(
                        key: ValueKey(m["date"] + m["feeling"]),
                        // 고유 키
                        direction: DismissDirection.endToStart,
                        // 오른쪽 → 왼쪽 스와이프
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          // 삭제 확인 다이얼로그
                          return await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("삭제 확인"),
                              content: const Text("이 메모를 삭제하시겠습니까?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text("취소"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text(
                                    "삭제",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (_) async {
                          await MemoRepository.deleteMemo(m);

                          if (!mounted) return;
                          setState(() => _memos.remove(m));

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("메모가 삭제되었습니다.")),
                            );
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 년/월/일 두칸씩 표시
                              Column(
                                children: [
                                  _GanZhiPair(label: "년", ganZhi: year),
                                  const SizedBox(height: 6),
                                  _GanZhiPair(label: "월", ganZhi: month),
                                  const SizedBox(height: 6),
                                  _GanZhiPair(label: "일", ganZhi: day),
                                ],
                              ),
                              const SizedBox(width: 12),

                              // 오른쪽 내용
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${m["date"]} "
                                      "(${ganZhiToKo(m["yearGanZhi"])}년 "
                                      "${ganZhiToKo(m["monthGanZhi"])}월 "
                                      "${ganZhiToKo(m["dayGanZhi"])}일) ",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Text("${m["feeling"]}"),
                                    const SizedBox(height: 4),
                                    if ((m["memo"] as String).isNotEmpty)
                                      Text(
                                        m["memo"],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// ───────── 작은 간지 위젯 (색 적용) ─────────
class _GanZhiTile extends StatefulWidget {
  final String gan, zhi;

  const _GanZhiTile({required this.gan, required this.zhi});

  @override
  State<_GanZhiTile> createState() => _GanZhiTileState();
}

class _GanZhiTileState extends State<_GanZhiTile> {
  Color _bgFor(String ch, {required bool branch}) {
    final elem = branch ? branchToElement[ch] : stemToElement[ch];
    switch (elem) {
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
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 천간
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _bgFor(widget.gan, branch: false),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.gan,
            style: AppTextStyles.body.copyWith(
              fontSize: 18,
              color: Colors.white,
              fontFamily: "SourceHanSansSC",
            ),
          ),
        ),
        const SizedBox(height: 2),
        // 지지
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _bgFor(widget.zhi, branch: true),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.zhi,
            style: AppTextStyles.body.copyWith(
              fontSize: 18,
              color: Colors.white,
              fontFamily: "SourceHanSansSC",
            ),
          ),
        ),
      ],
    );
  }
}

class _GanZhiPair extends StatelessWidget {
  final String label;
  final String ganZhi;

  const _GanZhiPair({required this.label, required this.ganZhi});

  Color _bgFor(String ch, {required bool branch}) {
    final elem = branch ? branchToElement[ch] : stemToElement[ch];
    switch (elem) {
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
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ganZhi == "—" || ganZhi.length < 2) {
      return const SizedBox(width: 60, height: 40);
    }

    final gan = ganZhi.substring(0, 1);
    final zhi = ganZhi.substring(1);

    return Row(
      children: [
        // 천간
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _bgFor(gan, branch: false),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            gan,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: "SourceHanSansSC",
              color: Colors.white,
              height: 1.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 4),
        // 지지
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _bgFor(zhi, branch: true),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            zhi,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: "SourceHanSansSC",
              color: Colors.white,
              height: 1.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
