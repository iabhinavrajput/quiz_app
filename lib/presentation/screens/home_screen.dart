import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/bloc/quiz/quiz_bloc.dart';
import 'package:quiz_app/bloc/quiz/quiz_event.dart';
import 'package:quiz_app/presentation/screens/quiz_screen.dart';
import 'package:quiz_app/presentation/screens/profile_screen.dart';
import 'package:quiz_app/presentation/screens/tracking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _difficulty;

  int _currentIndex = 0;

  // Method to change the bottom navigation index
  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz App')),
      body: _currentIndex == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Select Difficulty:'),
                  DropdownButton<String>(
                    value: _difficulty,
                    items: ['easy', 'medium', 'hard']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (value) => setState(() => _difficulty = value),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _difficulty == null
                        ? null
                        : () {
                            context.read<QuizBloc>().add(LoadQuizEvent(difficulty: _difficulty!));
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const QuizScreen()),
                            );
                          },
                    child: const Text('Start Quiz'),
                  ),
                ],
              ),
            )
          : _currentIndex == 1
              ? const ProfileScreen() // Profile Screen
              : const TrackingScreen(), // Tracking Screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Tracking',
          ),
        ],
      ),
    );
  }
}
