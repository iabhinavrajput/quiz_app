import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user == null) {
      return const Center(child: Text("No user signed in"));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tracking')),
      body: FutureBuilder<QuerySnapshot>(
        // Access the correct path to fetch quiz history for the current user
        future: FirebaseFirestore.instance
            .collection('users') // Access the 'users' collection
            .doc(user.uid) // Access the document corresponding to the current user
            .collection('quiz_history') // Access the 'quiz_history' sub-collection
            .orderBy('timestamp', descending: true) // Optionally order by timestamp to show the latest quizzes first
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data?.docs ?? [];

          if (data.isEmpty) {
            return const Center(child: Text('No quiz history available'));
          }

          // List each quiz history document
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final quizData = data[index].data() as Map<String, dynamic>;
              final answers = quizData['answers'] as List;
              final score = quizData['score'] ?? 0;
              final total = quizData['total'] ?? 0;
              final timestamp = (quizData['timestamp'] as Timestamp?)?.toDate();
              
              return ListTile(
                title: Text('Quiz taken at: ${timestamp?.toString()}'),
                subtitle: Text('Score: $score / $total'),
                trailing: Text('Answers: ${answers.length}'),
              );
            },
          );
        },
      ),
    );
  }
}
