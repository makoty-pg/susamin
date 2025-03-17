import 'package:memorization_and_clock/model/quiz_database_helper.dart';
import 'package:memorization_and_clock/model/quiz_manager.dart';

class LoadQuizData {
  List<QuizList> quizList = [];
  List<QuizData> quiz = [];
  QuizDatabaseHelper dbHelper = QuizDatabaseHelper();

  // 問題集そのもののリスト(idとtitleが呼び出せる(quiz_manager.dartを参照))
  Future<List<QuizList>> loadQuizList () async{
    List<Map<String, dynamic>> list = await dbHelper.getListData();
    return quizList = list.map((map) => QuizList.fromMap(map)).toList();
  }

  // 問題集内の問題のリスト(id（問題番号）とquizListId（loadQuizListのid），quiestion，select，answerなどが呼び出せる(quiz_manager.dartを参照))
  Future<List<QuizData>> loadQuiz (int quizListId) async {
    List<Map<String, dynamic>> list = await dbHelper.getQuizData(quizListId);
    return quiz = list.map((map) => QuizData.fromMap(map)).toList();
  }
}