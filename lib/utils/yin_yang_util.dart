import '../models/element_relations.dart';

class YinYangUtil {
  /// 오행 상생 여부
  static bool isGenerating(String from, String to) =>
      ElementRelations.isGenerating(from, to);

  /// 오행 상극 여부
  static bool isOvercoming(String from, String to) =>
      ElementRelations.isOvercoming(from, to);

  /// 오행 상생 방향 설명
  static String describeGenerating(String from) {
    final to = ElementRelations.generating[from];
    return '$from → $to (상생)';
  }

  /// 오행 상극 방향 설명
  static String describeOvercoming(String from) {
    final to = ElementRelations.overcoming[from];
    return '$from → $to (상극)';
  }

  /// 음양 짝 여부 (같은 음양이면 True)
  static bool isSameYinYang(String yin1, String yin2) => yin1 == yin2;
}
