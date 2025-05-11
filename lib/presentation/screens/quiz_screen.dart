import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/quiz/quiz_bloc.dart';
import '../../../bloc/quiz/quiz_event.dart';
import '../../../bloc/quiz/quiz_state.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Timer? _timer;
  int _timeLeft = 30;

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        _submitAnswer(null);
      }
    });
  }

  void _submitAnswer(String? answer) {
    context.read<QuizBloc>().add(AnswerSelectedEvent(answer ?? ''));
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizLoaded) _startTimer();
          if (state is QuizCompleted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ResultScreen(
                  score: state.score,
                  total: state.total,
                  answerLogs: state.answerLogs.map((log) => log.toMap()).toList(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is QuizLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuizLoaded) {
            final question = state.questions[state.currentQuestionIndex];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time left: $_timeLeft sec', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  Text('Q${state.currentQuestionIndex + 1}: ${question.question}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ...question.options.map((option) => ListTile(
                        title: Text(option),
                        leading: Radio<String>(
                          value: option,
                          groupValue: state.selectedAnswer,
                          onChanged: (_) => _submitAnswer(option),
                        ),
                      )),
                ],
              ),
            );
          } else if (state is QuizError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Press Start to begin the quiz.'));
        },
      ),
    );
  }
}
