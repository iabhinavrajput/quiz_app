import '../../data/models/question_model.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int score;
  final String? selectedAnswer;

  QuizLoaded({
    required this.questions,
    this.currentQuestionIndex = 0,
    this.score = 0,
    this.selectedAnswer,
  });
}

class QuizCompleted extends QuizState {
  final int score;
  final int total;

  QuizCompleted(this.score, this.total);
}

class QuizError extends QuizState {
  final String message;

  QuizError(this.message);
}
