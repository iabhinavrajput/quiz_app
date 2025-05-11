class UserHistory {
  final int score;
  final String difficulty;
  final List<String> answers;

  UserHistory({required this.score, required this.difficulty, required this.answers});

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'difficulty': difficulty,
      'answers': answers,
    };
  }

  factory UserHistory.fromJson(Map<String, dynamic> json) {
    return UserHistory(
      score: json['score'],
      difficulty: json['difficulty'],
      answers: List<String>.from(json['answers']),
    );
  }
}

