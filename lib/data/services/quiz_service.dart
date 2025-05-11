import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/data/models/question_model.dart';
import '../../utils/constants/api_constants.dart';

class QuizService {
  Future<List<Question>> fetchQuestions() async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl),
      headers: ApiConstants.headers,
      body: jsonEncode(ApiConstants.requestBody),
    );

    if (response.statusCode == 200) {
      final content =
          jsonDecode(response.body)['choices'][0]['message']['content'];
      final jsonStart = content.indexOf('[');
      final jsonEnd = content.lastIndexOf(']');
      final jsonString = content.substring(jsonStart, jsonEnd + 1);
      final List<dynamic> data = jsonDecode(jsonString);
      return data.map((e) => Question.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
