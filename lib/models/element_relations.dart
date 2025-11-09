//오행의 상극상생관계

class ElementRelations {
  static const List<String> elements = ['목', '화', '토', '금', '수'];

  /// 상생 관계 (예: 목 → 화)
  static const Map<String, String> generating = {
    '목': '화',
    '화': '토',
    '토': '금',
    '금': '수',
    '수': '목',
  };

  /// 상극 관계 (예: 목 → 토)
  static const Map<String, String> overcoming = {
    '목': '토',
    '토': '수',
    '수': '화',
    '화': '금',
    '금': '목',
  };

  static bool isGenerating(String from, String to) => generating[from] == to;
  static bool isOvercoming(String from, String to) => overcoming[from] == to;
}
