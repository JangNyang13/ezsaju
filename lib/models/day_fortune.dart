class DayFortune {
  final DateTime date;      // 해당 날짜
  final int score;          // 점수
  final String grade;       // 등급 (아주 좋음 ~ 아주 안 좋음)
  final List<String> tags;  // 근거 태그
  final String message;     // 해석 메시지

  DayFortune({
    required this.date,
    required this.score,
    required this.grade,
    required this.tags,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'score': score,
    'grade': grade,
    'tags': tags,
    'message': message,
  };

  factory DayFortune.fromJson(Map<String, dynamic> json) => DayFortune(
    date: DateTime.parse(json['date'] as String),
    score: json['score'] as int,
    grade: json['grade'] as String,
    tags: List<String>.from(json['tags'] as List),
    message: json['message'] as String,
  );
}
