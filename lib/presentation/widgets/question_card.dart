import 'package:flutter/material.dart';
import 'package:quiz_app/data/models/question_model.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final Function(String) onOptionSelected;
  const QuestionCard({super.key, required this.question, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.question, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          for (var option in question.options)
            ListTile(
              title: Text(option),
              onTap: () => onOptionSelected(option),
            ),
        ],
      ),
    );
  }
}
