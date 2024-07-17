class Question {
  final String question;
  final List<Option> options;

  Question({required this.question, required this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    var optionsJson = json['options'] as List;
    List<Option> optionsList =
        optionsJson.map((i) => Option.fromJson(i)).toList();

    return Question(
      question: json['question'],
      options: optionsList,
    );
  }
}

class Option {
  final String text;
  final int score;

  Option({required this.text, required this.score});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      text: json['text'],
      score: json['score'],
    );
  }
}
