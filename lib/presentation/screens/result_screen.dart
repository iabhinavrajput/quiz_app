import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<Map<String, dynamic>> answerLogs;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.answerLogs,
  });

  Future<void> _saveResult() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('quiz_history')
          .doc(DateTime.now().toIso8601String());

      await docRef.set({
        'score': score,
        'total': total,
        'timestamp': Timestamp.now(),
        'answers': answerLogs,
      });
    }

    // Local storage
    final history = prefs.getStringList('local_scores') ?? [];
    history.add('$score/$total - ${DateTime.now()}');
    prefs.setStringList('local_scores', history);
  }

  @override
  Widget build(BuildContext context) {
    _saveResult(); // fire once on load

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You scored $score out of $total',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('Back to Home'),
            )
          ],
        ),
      ),
    );
  }
}
