class YukchinModule {
  static String getRelation(String tenGod) {
    switch (tenGod) {
      case '비견':
      case '겁재':
        return '형제자매';
      case '식신':
      case '상관':
        return '자녀';
      case '정재':
      case '편재':
        return '배우자';
      case '정관':
      case '편관':
        return '자식의 부친 / 상사';
      case '정인':
      case '편인':
        return '부모';
      default:
        return '기타';
    }
  }

  static Map<String, String> interpret(Map<String, String> tenGodsResult) {
    final result = <String, String>{};
    tenGodsResult.forEach((pillar, god) {
      result[pillar] = getRelation(god);
    });
    return result;
  }
}
