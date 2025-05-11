import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/bloc/auth/auth_bloc.dart';
import 'bloc/quiz/quiz_bloc.dart';
import 'data/services/quiz_service.dart';
import 'presentation/screens/auth_screen.dart'; // Add your Auth screen import

void main() async {
  // Ensure proper initialization of Firebase before the app runs
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const QuizApp());
}



class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => QuizBloc(QuizService())),
        BlocProvider(create: (_) => AuthBloc()), // Add AuthBloc here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quiz App',
        home: const AuthScreen(), // <- Start from AuthScreen, not HomeScreen
      ),
    );
  }
}