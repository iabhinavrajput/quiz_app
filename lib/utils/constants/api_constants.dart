import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final baseUrl = dotenv.env['API_BASE_URL']!;
  static final headers = {
    'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
    'Content-Type': 'application/json',
  };
}
