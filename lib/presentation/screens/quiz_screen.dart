import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/quiz/quiz_bloc.dart';
import '../../../bloc/quiz/quiz_event.dart';
import '../../../bloc/quiz/quiz_state.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: BlocBuilder<QuizBloc, QuizState>(
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
                  Text(
                    'Q${state.currentQuestionIndex + 1}: ${question.question}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ...question.options.map((option) => ListTile(
                        title: Text(option),
                        leading: Radio<String>(
                          value: option,
                          groupValue: state.selectedAnswer,
                          onChanged: (value) {
                            context
                                .read<QuizBloc>()
                                .add(AnswerSelectedEvent(option));
                          },
                        ),
                      )),
                ],
              ),
            );
          } else if (state is QuizCompleted) {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultScreen(
                    score: state.score,
                    total: state.total,
                  ),
                ),
              );
            });
            return const SizedBox.shrink();
          } else if (state is QuizError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Press Start to begin the quiz.'));
        },
      ),
    );
  }
}
