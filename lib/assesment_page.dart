import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth.dart';
import 'login.dart';

class AssessmentPage extends StatefulWidget {
  final AuthService authService;
  final List<int>? initialSelectedOptions;
  final List<String>? initialQuestions;
  final List<List<String>>? initialOptions;
  final List<String>? initialCorrectAnswers;

  AssessmentPage({
    required this.authService,
    this.initialSelectedOptions,
    this.initialQuestions,
    this.initialOptions,
    this.initialCorrectAnswers,
  });

  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  List<int> _selectedOptions = List.filled(5, -1);
  List<String> _questions = [];
  List<List<String>> _options = [];
  List<String> _correctAnswers = [];
  bool _loading = true;
  bool _hasTakenAssessment = false;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=5&category=21&difficulty=easy&type=multiple'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'];
      setState(() {
        _questions =
            results.map<String>((q) => q['question'].toString()).toList();
        _options = results.map<List<String>>((q) {
          List<String> options = List<String>.from(q['incorrect_answers']);
          options.add(q['correct_answer']);
          options.shuffle();
          return options;
        }).toList();
        _correctAnswers =
            results.map<String>((q) => q['correct_answer'].toString()).toList();
        _loading = false;
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < _selectedOptions.length; i++) {
      if (_selectedOptions[i] != -1 &&
          _options[i][_selectedOptions[i]] == _correctAnswers[i]) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assessment')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_questions[index],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                ...List.generate(4, (optionIndex) {
                                  return RadioListTile(
                                    title: Text(_options[index][optionIndex]),
                                    value: optionIndex,
                                    groupValue: _selectedOptions[index],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedOptions[index] = value!;
                                      });
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (await widget.authService.isLoggedIn()) {
                        _showResultDialog();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              authService: widget.authService,
                              redirectToAssessment: true,
                              selectedOptions: _selectedOptions,
                              questions: _questions,
                              options: _options,
                              correctAnswers: _correctAnswers,
                            ),
                          ),
                        ).then((loggedIn) {
                          if (loggedIn == true) {
                            _hasTakenAssessment = true;
                          }
                        });
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Result'),
          content: Text('Your score is ${_calculateScore()}/5'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
