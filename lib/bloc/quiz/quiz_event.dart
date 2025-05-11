abstract class QuizEvent {}

class LoadQuizEvent extends QuizEvent {}
class AnswerSelectedEvent extends QuizEvent {
  final String selectedAnswer;
  AnswerSelectedEvent(this.selectedAnswer);
}
