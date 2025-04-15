import 'dart:convert';
import 'package:http/http.dart' as http;
import 'questions.dart';


class ApiService {
  static Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((q) => Question.fromJson(q))
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
