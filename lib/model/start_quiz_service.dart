import 'package:flutter/material.dart';
import 'package:memorization_and_clock/model/load_quiz_data.dart';
import 'package:memorization_and_clock/model/quiz_manager.dart';

Future<List<Map>> getQuizMap(int quizListId) async {
  List<Map> quizList = [];
  LoadQuizData loader = LoadQuizData();

  List<QuizData> quizzes = await loader.loadQuiz(quizListId);

  for (QuizData quiz in quizzes) {
    Map<String, dynamic> quizMap = quiz.toMap();
    quizList.add(quizMap);
  }

  return quizList;
}