import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/data/models/user_history_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserHistory(UserHistory history) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).collection('quizHistory').add({
        'score': history.score,
        'timestamp': FieldValue.serverTimestamp(),
        'answers': history.answers,
        'difficulty': history.difficulty,
      });
    }
  }
}
