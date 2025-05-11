abstract class QuizEvent {}

class LoadQuizEvent extends QuizEvent {
  final String difficulty;
  LoadQuizEvent({required this.difficulty});
}

class AnswerSelectedEvent extends QuizEvent {
  final String selectedAnswer;
  AnswerSelectedEvent(this.selectedAnswer);
}
