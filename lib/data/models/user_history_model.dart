
class UserHistory {
  final int score;
  final String difficulty;
  final List<Map<String, dynamic>> answers; 

  UserHistory({
    required this.score,
    required this.difficulty,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'difficulty': difficulty,
      'answers': answers.map((answer) {
        return {
          'question': answer['question'],
          'selectedAnswer': answer['selectedAnswer'],
          'correctAnswer': answer['correctAnswer'], 
          'isCorrect': answer['isCorrect'],
        };
      }).toList(),
    };
  }
}
