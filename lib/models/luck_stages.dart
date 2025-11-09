//lib/models/luck_stages.dart
//12운성(생왕사절)
class LuckStages {
  static const List<String> stages = [
    '장생', '목욕', '관대', '건록', '제왕',
    '쇠', '병', '사', '묘', '절', '태', '양'
  ];

  static const Map<String, String> startBranch = {
    '甲': '亥', '乙': '午',
    '丙': '寅', '丁': '酉',
    '戊': '寅', '己': '酉',
    '庚': '巳', '辛': '子',
    '壬': '申', '癸': '卯',
  };

  static const Map<String, bool> isYangStem = {
    '甲': true, '乙': false,
    '丙': true, '丁': false,
    '戊': true, '己': false,
    '庚': true, '辛': false,
    '壬': true, '癸': false,
  };

  static const List<String> branchesOrder = [
    '子', '丑', '寅', '卯', '辰', '巳',
    '午', '未', '申', '酉', '戌', '亥'
  ];

  static String getStage(String stem, String branch) {
    final start = startBranch[stem];
    if (start == null) return '無';
    final startIndex = branchesOrder.indexOf(start);
    final targetIndex = branchesOrder.indexOf(branch);
    if (targetIndex == -1) return '無';

    final isYang = isYangStem[stem] ?? true;
    int diff = isYang
        ? (targetIndex - startIndex) % 12
        : (startIndex - targetIndex) % 12;

    return stages[diff];
  }
}
