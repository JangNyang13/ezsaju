enum EnvironmentEffect { positive, negative }

class JoyongEnvironmentRule {
  final String id; // 메시지 키 (JSON 매핑)
  final EnvironmentEffect effect;
  final bool Function(EnvironmentContext ctx) condition;

  const JoyongEnvironmentRule({
    required this.id,
    required this.effect,
    required this.condition,
  });
}

class EnvironmentContext {
  final Set<String> stems;        // 천간
  final Set<String> branches;     // 지지
  final Set<String> juGroups;     // 삼합
  final Set<String> bangGroups;   // 방합
  final Set<String> gukGroups;    // 금국·목국·화국·수국

  const EnvironmentContext({
    required this.stems,
    required this.branches,
    required this.juGroups,
    required this.bangGroups,
    required this.gukGroups,
  });
}
