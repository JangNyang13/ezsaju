class SajuMath {
  /// 10간 순환
  static const List<String> stems = [
    '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'
  ];

  /// 12지 순환
  static const List<String> branches = [
    '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'
  ];

  /// 다음 천간
  static String nextStem(String current) {
    final i = stems.indexOf(current);
    return stems[(i + 1) % 10];
  }

  /// 다음 지지
  static String nextBranch(String current) {
    final i = branches.indexOf(current);
    return branches[(i + 1) % 12];
  }

  /// 두 간지의 간격(거리) 계산
  static int distance(String from, String to) {
    final fi = branches.indexOf(from);
    final ti = branches.indexOf(to);
    return (ti - fi + 12) % 12;
  }

    /// 시주 계산: 일간 + 시간 입력 → 시주 산출
    static String calculateHourPillar(String dayStem, int hour) {
      // 일간별 자시 천간 기준표
      const headStemByDay = {
        '甲': '甲', '己': '甲',
        '乙': '丙', '庚': '丙',
        '丙': '戊', '辛': '戊',
        '丁': '庚', '壬': '庚',
        '戊': '壬', '癸': '壬',
      };

      const hourBranches = [
        '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'
      ];

      final head = headStemByDay[dayStem] ?? '甲';
      final branchIndex = (hour + 1) ~/ 2 % 12;
      final branch = hourBranches[branchIndex];

      final stemIndex = stems.indexOf(head);
      final stem = stems[(stemIndex + branchIndex) % 10];
      return stem + branch;
    }

  /// 간지 병합 (예: "甲"+"子" → "甲子")
  static String combine(String stem, String branch) => stem + branch;
}
