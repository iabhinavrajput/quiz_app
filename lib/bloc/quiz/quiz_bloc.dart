import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/data/services/quiz_service.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizService quizService;

  List<AnswerLog> _answerLogs = [];
  List _questions = [];

  QuizBloc(this.quizService) : super(QuizInitial()) {
    on<LoadQuizEvent>(_onLoadQuiz);
    on<AnswerSelectedEvent>(_onAnswerSelected);
  }

  void _onLoadQuiz(LoadQuizEvent event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    _answerLogs = [];
    try {
      final questions = await quizService.fetchQuestions(difficulty: event.difficulty);
      emit(QuizLoaded(questions: questions));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  void _onAnswerSelected(AnswerSelectedEvent event, Emitter<QuizState> emit) {
    final currentState = state;
    if (currentState is QuizLoaded) {
      final question = currentState.questions[currentState.currentQuestionIndex];
      final isCorrect = event.selectedAnswer == question.answer;

      _answerLogs.add(AnswerLog(
        question: question.question,
        selectedAnswer: event.selectedAnswer,
        isCorrect: isCorrect,
      ));

      final nextIndex = currentState.currentQuestionIndex + 1;
      final newScore = isCorrect ? currentState.score + 1 : currentState.score;

      if (nextIndex < currentState.questions.length) {
        emit(QuizLoaded(
          questions: currentState.questions,
          currentQuestionIndex: nextIndex,
          score: newScore,
        ));
      } else {
        emit(QuizCompleted(newScore, currentState.questions.length, _answerLogs));
      }
    }
  }
}
