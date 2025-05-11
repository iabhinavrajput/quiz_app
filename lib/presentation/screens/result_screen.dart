import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants/colors.dart';
class ResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final List<Map<String, dynamic>> answerLogs;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.answerLogs,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _trophyOffset;
  late double percentage;

  @override
  void initState() {
    super.initState();

    percentage = (widget.total == 0)
        ? 0
        : (widget.score / widget.total * 100).toDouble();

    _saveResult();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _trophyOffset = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveResult() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('quiz_history')
          .doc(DateTime.now().toIso8601String());

      // Save the result including the correct answers
      await docRef.set({
        'score': widget.score,
        'total': widget.total,
        'percentage': percentage.toStringAsFixed(2),
        'timestamp': Timestamp.now(),
        'answers': widget.answerLogs.map((log) => {
          'question': log['question'],
          'selectedAnswer': log['selectedAnswer'],
          'correctAnswer': log['correctAnswer'],  // Store correct answer
          'isCorrect': log['isCorrect'],
        }).toList(),
      });
    }

    final history = prefs.getStringList('local_scores') ?? [];
    history.add('${widget.score}/${widget.total} - ${percentage.toStringAsFixed(2)}% - ${DateTime.now()}');
    prefs.setStringList('local_scores', history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _trophyOffset,
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 100,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You scored ${widget.score} out of ${widget.total}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${percentage.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.amberAccent,
                  letterSpacing: 1.0,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.signInGradientStart,
                        AppColors.signInGradientEnd
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
