import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/presentation/screens/quiz_track_detail_screen.dart';
import 'package:quiz_app/utils/constants/colors.dart';

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
        child: FutureBuilder<QuerySnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('quiz_history')
                  .orderBy('timestamp', descending: true)
                  .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: SpinKitChasingDots(
                              color: AppColors.white,
                              size: 30.0,
                            ),);
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
                final timestamp =
                    (quizData['timestamp'] as Timestamp?)?.toDate();

                String formattedDate = DateFormat(
                  'MMM dd, yyyy',
                ).format(timestamp!);
                String formattedTime = DateFormat('hh:mm a').format(timestamp);

                // Calculate percentage if not stored
                double percentage = (total != 0) ? (score / total * 100) : 0;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 10,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryGradientStart,
                        child: Icon(Icons.track_changes, color: Colors.white),
                      ),
                      title: Text(
                        'Quiz taken at: $formattedDate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time: $formattedTime',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Score: $score / $total',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  score >= total * 0.8
                                      ? Colors.green[700]
                                      : Colors.red[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Percentage: ${percentage.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  percentage >= 80
                                      ? Colors.green[700]
                                      : Colors.red[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Answers: ${answers.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primaryGradientStart,
                      ),
                      onTap: () {
                        // Navigate to the detail screen of the selected quiz
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DetailScreen(quizDocId: data[index].id),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
