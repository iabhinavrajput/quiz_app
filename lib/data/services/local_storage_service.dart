import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList('scores') ?? [];
    scores.add(score.toString());
    await prefs.setStringList('scores', scores);
  }

  Future<List<int>> getPastScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList('scores') ?? [];
    return scores.map((e) => int.parse(e)).toList();
  }
}
