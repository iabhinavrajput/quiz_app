import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/data/models/user_history_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserHistory(UserHistory history) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Save quiz history including correct answers
      await _db.collection('users').doc(user.uid).collection('quizHistory').add({
        'score': history.score,
        'timestamp': FieldValue.serverTimestamp(),
        'answers': history.answers.map((answer) {
          return {
            'question': answer['question'],
            'selectedAnswer': answer['selectedAnswer'],
            'correctAnswer': answer['correctAnswer'],  // Store correct answer
            'isCorrect': answer['isCorrect'],
          };
        }).toList(),
        'difficulty': history.difficulty,
      });
    }
  }
}

