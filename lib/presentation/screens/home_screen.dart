import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/quiz/quiz_bloc.dart';
import '../../../bloc/quiz/quiz_event.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<QuizBloc>().add(LoadQuizEvent());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuizScreen()),
            );
          },
          child: const Text('Start Quiz'),
        ),
      ),
    );
  }
}
