import 'package:flutter/material.dart';
import 'api_service.dart' show ApiService;
import 'questions.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _loading = true;
  bool _answered = false;
  String _feedback = "";

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    try {
      final questions = await ApiService.fetchQuestions();
      setState(() {
        _questions = questions;
        _loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _submitAnswer(String selected) {
    setState(() {
      _answered = true;
      final correct = _questions[_currentQuestionIndex].correctAnswer;
      if (selected == correct) {
        _score++;
        _feedback = "✅ Correct!";
      } else {
        _feedback = "❌ Incorrect. Answer: $correct";
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _answered = false;
      _feedback = "";
    });
  }

  Widget _buildOption(String option) {
    return ElevatedButton(
      onPressed: _answered ? null : () => _submitAnswer(option),
      child: Text(option),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentQuestionIndex >= _questions.length) {
      return Scaffold(
        body: Center(child: Text("🎉 Quiz Completed!\nScore: $_score/10")),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Trivia Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Q${_currentQuestionIndex + 1}/10",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text(question.question, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ...question.options.map(_buildOption),
            if (_answered) ...[
              SizedBox(height: 20),
              Text(_feedback,
                  style: TextStyle(
                      color: _feedback.contains("Correct") ? Colors.green : Colors.red,
                      fontSize: 16)),
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text("Next"),
              )
            ]
          ],
        ),
      ),
    );
  }
}
