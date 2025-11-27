import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SipsungCalcScreen extends StatefulWidget {
  const SipsungCalcScreen({super.key});

  @override
  State<SipsungCalcScreen> createState() => _SipsungCalcScreenState();
}

class _SipsungCalcScreenState extends State<SipsungCalcScreen> {
  String? dayStem;

  // 십성 결과 저장 (양/음 구분)
  Map<String, List<String>> result = {
    "비겁_양": [], "비겁_음": [],
    "식상_양": [], "식상_음": [],
    "재성_양": [], "재성_음": [],
    "관성_양": [], "관성_음": [],
    "인성_양": [], "인성_음": [],
  };

  final stems = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'];
  final branches = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];

  void calculate() {
    if (dayStem == null) return;

    // 초기화
    result = {
      "비겁_양": [], "비겁_음": [],
      "식상_양": [], "식상_음": [],
      "재성_양": [], "재성_음": [],
      "관성_양": [], "관성_음": [],
      "인성_양": [], "인성_음": [],
    };

    // 천간
    for (final g in stems) {
      final s = getSipsung(dayStem!, g);
      final yy = getYinyang(g, true);
      result["${s}_$yy"]!.add(g);
    }

    // 지지
    for (final j in branches) {
      final s = getSipsung(dayStem!, j);
      final yy = getYinyang(j, false);
      result["${s}_$yy"]!.add(j);
    }

    setState(() {});
  }

  // 음양 구분
  String getYinyang(String target, bool isStem) {
    final info = isStem ? ganElement[target]! : jiElement[target]!;
    return info.contains("양") ? "양" : "음";
  }

  String getYangName(String key) {
    switch (key) {
      case "비겁": return "비견";
      case "식상": return "식신";
      case "재성": return "정재";
      case "관성": return "정관";
      case "인성": return "정인";
    }
    return "";
  }

  String getEumName(String key) {
    switch (key) {
      case "비겁": return "겁재";
      case "식상": return "상관";
      case "재성": return "편재";
      case "관성": return "편관";
      case "인성": return "편인";
    }
    return "";
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final centerX = size.width / 2;        // 정확한 화면 중앙 (가로)
    final centerY = size.height * 0.33;    // 세로는 약간 위쪽

    final radius = size.width * 0.33;      // 오각형 크기

    const double itemSize = 140;           // 오각형 꼭짓점 박스 크기

    final titles = ["비겁", "식상", "재성", "관성", "인성"];

    List<Widget> pentagonItems = [];

    for (int i = 0; i < 5; i++) {
      final angle = (-90 + i * 72) * pi / 180;

      final x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);

      final key = titles[i];

      // 🔥 i=2(재성), i=3(관성)만 아래로 30 내려주기
      if (i == 2 || i == 3) {
        y += 50;   // ← 네 화면에 맞게 20~40 조절 가능
      }

      pentagonItems.add(
        Positioned(
          left: x - (itemSize / 2),
          top:  y - (itemSize / 2),
          child: SizedBox(
            width: itemSize,
            child: Column(
              children: [
                Text(
                  key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --------------------
                    // 왼쪽: 양(정)
                    // --------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          key == "비겁" ? "비견"
                              : key == "식상" ? "식신"
                              : key == "재성" ? "정재"
                              : key == "관성" ? "정관"
                              : "정인",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        ...result["${key}_양"]!.map((v) => SipsungChip(v)),
                      ],
                    ),
                    // --------------------
                    // 오른쪽: 음(편)
                    // --------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          key == "비겁" ? "겁재"
                              : key == "식상" ? "상관"
                              : key == "재성" ? "편재"
                              : key == "관성" ? "편관"
                              : "편인",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        ...result["${key}_음"]!.map((v) => SipsungChip(v)),
                      ],
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text("십성 계산 도구"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("일간"),
              SizedBox(width: 8),
              DropdownButton<String>(
                value: dayStem,
                hint: const Text("일간 선택"),
                items: stems.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) {
                  setState(() => dayStem = v);
                  calculate();
                },
              ),
            ],
          ),

          Expanded(
            child: Stack(children: pentagonItems),
          ),
        ],
      ),
    );
  }

}

// ===========================
// 십성 계산 로직
// ===========================

const ganElement = {
  '甲': '목양', '乙': '목음',
  '丙': '화양', '丁': '화음',
  '戊': '토양', '己': '토음',
  '庚': '금양', '辛': '금음',
  '壬': '수양', '癸': '수음',
};

const jiElement = {
  '子': '수음', '丑': '토음', '寅': '목양', '卯': '목음',
  '辰': '토양', '巳': '화양', '午': '화음', '未': '토음',
  '申': '금양', '酉': '금음', '戌': '토양', '亥': '수양',
};

String getSipsung(String dayStem, String target) {
  final me = ganElement[dayStem]!;
  final other = ganElement[target] ?? jiElement[target]!;

  final meEl = me.substring(0, 1);
  final otherEl = other.substring(0, 1);

  // 비겁(비견+겁재)
  if (meEl == otherEl) return "비겁";

  // 식상
  if ((meEl == '목' && otherEl == '화') ||
      (meEl == '화' && otherEl == '토') ||
      (meEl == '토' && otherEl == '금') ||
      (meEl == '금' && otherEl == '수') ||
      (meEl == '수' && otherEl == '목')) {return "식상";}

  // 재성
  if ((meEl == '목' && otherEl == '토') ||
      (meEl == '화' && otherEl == '금') ||
      (meEl == '토' && otherEl == '수') ||
      (meEl == '금' && otherEl == '목') ||
      (meEl == '수' && otherEl == '화')) {return "재성";}

  // 관성
  if ((meEl == '토' && otherEl == '목') ||
      (meEl == '금' && otherEl == '화') ||
      (meEl == '목' && otherEl == '금') ||
      (meEl == '화' && otherEl == '수') ||
      (meEl == '수' && otherEl == '토')) {return "관성";}

  // 인성
  return "인성";
}

// ===========================
// 칩 위젯
// ===========================
class SipsungChip extends StatelessWidget {
  final String text;
  const SipsungChip(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.fromGanji(text),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}
