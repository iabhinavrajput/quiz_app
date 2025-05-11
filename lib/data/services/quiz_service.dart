import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/data/models/question_model.dart';
import '../../utils/constants/api_constants.dart';

class QuizService {
  Future<List<Question>> fetchQuestions({required String difficulty}) async {
    final url = ApiConstants.baseUrl;

    final prompt =
        "Generate 5 $difficulty general knowledge multiple-choice questions. "
        "Respond only with valid JSON in this format: "
        "[{\"question\": \"<text>\", \"options\": [\"A. <option>\", \"B. <option>\", \"C. <option>\", \"D. <option>\"], \"answer\": \"<correct option label>\"}]. "
        "Do not include explanations or extra text.";

    final requestBody = {
      "model": "llama3-8b-8192",
      "messages": [
        {"role": "user", "content": prompt}
      ]
    };



    final response = await http.post(
      Uri.parse(url),
      headers: ApiConstants.headers,
      body: jsonEncode(requestBody),
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
