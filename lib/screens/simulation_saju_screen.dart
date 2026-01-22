import 'package:ezsaju/screens/sipsung_calc_screen.dart';
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

  String getSipsung(String dayStem, String target) {
    final me = ganElement[dayStem]!;
    final other = ganElement[target] ?? jiElement[target]!;

    final meEl = me.substring(0, 1);
    final meYY = me.substring(1, 2);
    final otherEl = other.substring(0, 1);
    final otherYY = other.substring(1, 2);

    // 비견 / 겁재
    if (meEl == otherEl) {
      return (meYY == otherYY) ? "비견" : "겁재";
    }

    // 식신 / 상관 (내가 생함)
    if ((meEl == '목' && otherEl == '화') ||
        (meEl == '화' && otherEl == '토') ||
        (meEl == '토' && otherEl == '금') ||
        (meEl == '금' && otherEl == '수') ||
        (meEl == '수' && otherEl == '목')) {
      return (otherYY == '양') ? "식신" : "상관";
    }

    // 정재 / 편재 (내가 극함)
    if ((meEl == '목' && otherEl == '토') ||
        (meEl == '화' && otherEl == '금') ||
        (meEl == '토' && otherEl == '수') ||
        (meEl == '금' && otherEl == '목') ||
        (meEl == '수' && otherEl == '화')) {
      return (otherYY == '양') ? "편재" : "정재";
    }

    // 정관 / 편관 (나를 극함)
    if ((meEl == '토' && otherEl == '목') ||
        (meEl == '금' && otherEl == '화') ||
        (meEl == '목' && otherEl == '금') ||
        (meEl == '화' && otherEl == '수') ||
        (meEl == '수' && otherEl == '토')) {
      return (otherYY == '양') ? "편관" : "정관";
    }

    // 정인 / 편인 (나를 생함)
    return (otherYY == '양') ? "정인" : "편인";
  }




  // ---- GapjaBox 생성 ----
  Widget _sajuBox(int index, String? value, BuildContext context, int realIndex) {
    final size = boxSize(context);

    return GestureDetector(
      onTap: () async {
        if (index < 4) {
          saju[index] = await _pickStem(index);
        } else {
          saju[index] = await _pickBranch(index);
        }
        setState(() {});
      },
      child: _buildSajuContent(value, size, realIndex),
    );
  }


  // 십성 표시 + 지장간 제거된 버전
  Widget _buildSajuContent(String? value, double size, int index) {
    if (value == null) {
      return GapjaBox(
        text: "+",
        color: AppColors.secondary,
        size: size,
        showLabel: false,
      );
    }

    final dayStem = saju[1]; // 🔥 일간 = index 1
    if (dayStem == null) {
      return GapjaBox(
        text: value,
        color: AppColors.fromGanji(value),
        size: size,
        showLabel: true,
      );
    }

    final isStem = index < 4;
    final sipsung = getSipsung(dayStem, value);

    // ===========================
    // 1) 천간
    // ===========================
    if (isStem) {
      return Column(
        children: [
          Text(
            sipsung,
            style: TextStyle(
              fontSize: size * 0.19,
              color: Colors.grey[800],
            ),
          ),
          GapjaBox(
            text: value,
            color: AppColors.fromGanji(value),
            size: size,
            showLabel: true,
          ),
        ],
      );
    }

    // ===========================
    // 2) 지지 + 지장간
    // ===========================
    final branch = earthlyBranches.firstWhere(
          (e) => e.name == value,
      orElse: () => const StemBranch(name: '', element: '', yinYang: ''),
    );

    final hidden = branch.hiddenStems ?? [];

    return Column(
      children: [
                // 지지 본체
        GapjaBox(
          text: value,
          size: size,
          color: AppColors.fromGanji(value),
          showLabel: true,
        ),
        // 십성 (정확한 이름)
        Text(
          sipsung,
          style: TextStyle(
            fontSize: size * 0.18,
            color: Colors.grey[800],
          ),
        ),

        // 🔥 지장간 (십성 표시 X, 이름만)
        if (hidden.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: hidden.map((h) {
              return Text(
                h,
                style: TextStyle(
                  fontSize: size * 0.28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.fromGanji(h),
                ),
              );
            }).toList(),
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
        
              // --- 천간 4칸 ---
              fourBoxRow(
                List.generate(4, (i) => _sajuBox(i, saju[i], context, i)),
                context,
              ),
        
              const SizedBox(height: 8),
        
              // --- 지지 4칸 ---
              fourBoxRow(
                List.generate(4, (i) => _sajuBox(4 + i, saju[4 + i], context, 4 + i)),
                context,
              ),
        
        
              const SizedBox(height: 20),
        
              // ================================
              // 🔥 대운 1줄 + 2줄 통합 스크롤
              // ================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          8, (i) => _daewoonBox(daewoonStem[i], context)),
                    ),
        
                    const SizedBox(height: 6),
        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          8, (i) => _daewoonBox(daewoonBranch[i], context)),
                    ),
        
                    const SizedBox(height: 10),
        
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
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,              // 🔥 줄 간격 살짝 넓게
                        color: AppColors.primary,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text("=====방위운====="),
                          Text("인묘진(동방목), 사오미(남방화)"),
                          Text("신유술(서방금), 해자축(북방수)"),
                          SizedBox(height: 4),
                          Text("=====천간합====="),
                          Text("갑기(토), 을경(금)"),
                          Text("병신(수), 정임(목), 무계(화)"),
                          SizedBox(height: 4),
                          Text("=====삼합====="),
                          Text("신자진(수국), 해묘미(목국) "),
                          Text("인오술(화), 사유축(금)"),
                          Text("[3개중 2개만 와도 반합]"),
                          SizedBox(height: 4),
                          Text("=====방합====="),
                          Text("인묘진(목), 사오미(화), 신유술(금), 해자축(수)"),
                          Text("[느슨하지만 운에서 충오면 가족처럼 끈끈해짐]"),
                          SizedBox(height: 4),
                          Text("=====지지충====="),
                          Text("인신, 사해, 자오, 묘유, 진술, 축미"),
                        ],
                      ),
                    ),
                  ],
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
