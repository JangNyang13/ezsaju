class SajuFormResult {
  final String name;
  final DateTime birth;   // (양력) 최종 DateTime
  final String gender;    // 'M' | 'F'
  final bool timeUnknown;

  const SajuFormResult({
    required this.name,
    required this.birth,
    required this.gender,
    required this.timeUnknown,
  });
}
