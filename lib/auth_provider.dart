import 'package:flutter/material.dart';
import 'question_model.dart';
import 'question_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  List<int> _selectedOptions = List.filled(5, -1);
  List<Question> _questions = [];

  List<int> get selectedOptions => _selectedOptions;
  List<Question> get questions => _questions;

  Future<void> login(String email, String password) async {
    // Simulate login process
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> fetchQuestions() async {
    QuestionService questionService = QuestionService();
    _questions = await questionService.fetchQuestions();
    notifyListeners();
  }

  int calculateScore() {
    int score = 0;
    for (int i = 0; i < _selectedOptions.length; i++) {
      if (_selectedOptions[i] != -1) {
        score += _questions[i].options[_selectedOptions[i]].score;
      }
    }
    return score;
  }
}
