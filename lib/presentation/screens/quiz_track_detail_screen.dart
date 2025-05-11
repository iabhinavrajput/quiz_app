import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/utils/constants/colors.dart';

class DetailScreen extends StatelessWidget {
  final String quizDocId;

  const DetailScreen({super.key, required this.quizDocId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user == null) {
      return const Center(child: Text("No user signed in"));
    }

    return Scaffold(
      body: Container(
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
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('quiz_history')
              .doc(quizDocId) // Get the specific quiz document by ID
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('Quiz details not found'));
            }

            final quizData = snapshot.data!.data() as Map<String, dynamic>;
            final answers = quizData['answers'] as List;
            final score = quizData['score'] ?? 0;
            final total = quizData['total'] ?? 0;
            final timestamp = (quizData['timestamp'] as Timestamp?)?.toDate();
            double percentage = (total != 0) ? (score / total * 100) : 0;

            String formattedDate = DateFormat('MMM dd, yyyy').format(timestamp!);
            String formattedTime = DateFormat('hh:mm a').format(timestamp);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Quiz Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quiz Date and Time
                    Text(
                      'Taken on: $formattedDate at $formattedTime',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Score and Percentage
                    Text(
                      'Score: $score/$total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: percentage >= 80 ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                    Text(
                      'Percentage: ${percentage.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: percentage >= 80 ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Answers List
                    Text(
                      'Answers:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: answers.length,
                      itemBuilder: (context, index) {
                        final answer = answers[index] as Map<String, dynamic>;
                        final question = answer['question'] ?? 'N/A';
                        final selectedAnswer = answer['selectedAnswer'] ?? 'N/A';
                        final correctAnswer = answer['isCorrect'] != null && answer['isCorrect'] == true
                            ? selectedAnswer
                            : 'N/A'; // Only show correct answer if marked correct

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            color: Colors.white.withOpacity(0.9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 8,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              title: Text(
                                question,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Answer: $selectedAnswer',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: selectedAnswer == correctAnswer
                                          ? Colors.green[700]
                                          : Colors.red[700],
                                    ),
                                  ),
                                  Text(
                                    'Correct Answer: $correctAnswer',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Back Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGradientStart,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Navigate back to the previous screen
                      },
                      child: const Text(
                        'Back to History',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
