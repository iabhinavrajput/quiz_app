import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/quiz/quiz_bloc.dart';
import 'data/services/quiz_service.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizBloc(QuizService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quiz App',
        home: const HomeScreen(),
      ),
    );
  }
}
