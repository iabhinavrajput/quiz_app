import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:no_screenshot/no_screenshot.dart'; // Correct import for no_screenshot
import 'package:quiz_app/bloc/auth/auth_bloc.dart';
import 'package:quiz_app/bloc/quiz/quiz_bloc.dart';
import 'package:quiz_app/data/services/quiz_service.dart';
import 'package:quiz_app/presentation/screens/auth_screen.dart';
import 'package:quiz_app/presentation/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   await dotenv.load();
  NoScreenshot.instance; 

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const QuizApp());
  });
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
        home: _buildHomeScreen(),
      ),
    );
  }

  // Check if the user is already signed in
  Widget _buildHomeScreen() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const HomeScreen(); // If the user is logged in, go to HomeScreen
    } else {
      return const AuthScreen(); // If the user is not logged in, go to AuthScreen
    }
  }
}
