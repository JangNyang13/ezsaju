import 'package:flutter/material.dart';
import '../models/stem_branch.dart';
import '../widgets/gapja_box.dart';
import '../constants/app_colors.dart';
// ignore_for_file: deprecated_member_use

class SimulationSajuScreen extends StatefulWidget {
  const SimulationSajuScreen({super.key});

  @override
  State<SimulationSajuScreen> createState() => _SimulationSajuScreenState();
}

class _SimulationSajuScreenState extends State<SimulationSajuScreen> {
  // 사주 8칸
  List<String?> saju = List.filled(8, null);

  // 대운 (천간/지지)
  List<String?> daewoonStem = List.filled(8, null);
  List<String?> daewoonBranch = List.filled(8, null);

  double daewoonBoxSize(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.1;

  // 순/역
  bool isForward = true;

  // 천간/지지 리스트
  final stems = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'];
  final branches = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];

  // 음양간 rules
  final yangStems = ['甲','丙','戊','庚','壬'];
  final yinStems  = ['乙','丁','己','辛','癸'];

  // 음양지 rules
  final yangBranches = ['子','寅','辰','午','申','戌'];
  final yinBranches  = ['丑','卯','巳','未','酉','亥'];

  // ---- 반응형 사이즈 ----
  double boxSize(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.20;

  double gap(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.025;

  // ---- Picker: 천간 선택 ----
  Future<String?> _pickStem(int index) async {
    // 양/음 제한 처리
    final branch = saju[index + 4];
    List<String> allowed = stems;

    if (branch != null) {
      if (yangBranches.contains(branch)) {
        allowed = yangStems;
      } else if (yinBranches.contains(branch)) {
        allowed = yinStems;
      }
    }

    return await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: GridView.count(
          crossAxisCount: 5,   // 🔥 가로 5개
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: allowed.map((s) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, s),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.fromGanji(s),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  s,
                  style: const TextStyle(
                    fontSize: 42,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ---- Picker: 지지 선택 (음양 제한 적용됨!) ----
  Future<String?> _pickBranch(int index) async {
    // 양/음 제한 처리
    final stem = saju[index - 4];
    List<String> allowed = branches;

    if (stem != null) {
      if (yangStems.contains(stem)) {
        allowed = yangBranches;
      } else if (yinStems.contains(stem)) {
        allowed = yinBranches;
      }
    }

    return await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        height: 350,
        child: GridView.count(
          crossAxisCount: 4,   // 🔥 가로 6개
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: allowed.map((b) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, b),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.fromGanji(b),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  b,
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  // ---- GapjaBox 생성 ----
  Widget _sajuBox(int index, String? value, BuildContext context) {
    final size = boxSize(context);

    return GestureDetector(
      onTap: () async {
        if (index < 4) {
          // 천간
          saju[index] = await _pickStem(index);
        } else {
          // 지지 (음양 규칙 적용)
          saju[index] = await _pickBranch(index);
        }
        setState(() {});
      },
      child: _buildSajuContent(value, size),
    );
  }

  // 지장간 포함된 박스
  Widget _buildSajuContent(String? value, double size) {
    if (value == null) {
      return GapjaBox(
        text: "+",
        color: AppColors.secondary,
        size: size,
        showLabel: false,
      );
    }

    final branch = earthlyBranches.firstWhere(
          (e) => e.name == value,
      orElse: () => const StemBranch(name: '', element: '', yinYang: ''),
    );

    final hidden = branch.hiddenStems;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GapjaBox(
          text: value,
          color: AppColors.fromGanji(value),
          size: size,
          showLabel: true,
        ),
        if (hidden != null && hidden.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: hidden.map((h) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Text(
                    h,
                    style: TextStyle(
                      fontSize: size * 0.30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.fromGanji(h),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // ---- 대운 생성 ----
  void fillDaewoonFromWolju() {
    final wolgan = saju[2]; // 월간
    final wolji  = saju[6]; // 월지

    if (wolgan == null || wolji == null) return;

    final baseGanIndex = ganList.indexOf(wolgan);
    final baseJiIndex  = jiList.indexOf(wolji);

    for (int i = 0; i < 8; i++) {
      final targetIndex = 7 - i; // 오른쪽 → 왼쪽

      int gi, ji;

      if (isForward) {
        gi = (baseGanIndex + (i + 1)) % 10;
        ji = (baseJiIndex + (i + 1)) % 12;
      } else {
        gi = (baseGanIndex - (i + 1)) % 10;
        ji = (baseJiIndex - (i + 1)) % 12;
        if (gi < 0) gi += 10;
        if (ji < 0) ji += 12;
      }

      daewoonStem[targetIndex] = ganList[gi];
      daewoonBranch[targetIndex] = jiList[ji];
    }

    setState(() {});
  }

  Widget _daewoonBox(String? value, BuildContext context) {
    final size = daewoonBoxSize(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: GapjaBox(
        text: value ?? "-",
        color: value == null ? AppColors.secondary : AppColors.fromGanji(value),
        size: size,
        showLabel: false,
      ),
    );
  }

  // ---- 20% 박스 × 4 + 2.5% × 8 Row ----
  Widget fourBoxRow(List<Widget> items, BuildContext context) {
    final g = gap(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: g),
        items[0],
        SizedBox(width: g),
        items[1],
        SizedBox(width: g),
        items[2],
        SizedBox(width: g),
        items[3],
        SizedBox(width: g),
      ],
    );
  }

  /// 천간 / 지지 리스트
  final List<String> ganList = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'];
  final List<String> jiList  = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("사주 시뮬레이션"),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // --- 천간 4칸 ---
            fourBoxRow(
              List.generate(4, (i) => _sajuBox(i, saju[i], context)),
              context,
            ),

            const SizedBox(height: 8),

            // --- 지지 4칸 ---
            fourBoxRow(
              List.generate(4, (i) => _sajuBox(4 + i, saju[4 + i], context)),
              context,
            ),

            const SizedBox(height: 40),

            // ================================
            // 🔥 대운 1줄 + 2줄 통합 스크롤
            // ================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: List.generate(
                            8, (i) => _daewoonBox(daewoonStem[i], context)),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: List.generate(
                            8, (i) => _daewoonBox(daewoonBranch[i], context)),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: isForward,
                            onChanged: (v) =>
                                setState(() => isForward = v!),
                          ),
                          const Text("순행"),

                          const SizedBox(width: 20),

                          Radio<bool>(
                            value: false,
                            groupValue: isForward,
                            onChanged: (v) =>
                                setState(() => isForward = v!),
                          ),
                          const Text("역행"),

                          const SizedBox(width: 30),

                          ElevatedButton(
                            onPressed: fillDaewoonFromWolju,
                            child: const Text("대운 생성"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
