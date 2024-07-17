import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question_model.dart';

class QuestionService {
  Future<List<Question>> fetchQuestions() async {
    final response =
        await http.get(Uri.parse('https://api.example.com/questions'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
