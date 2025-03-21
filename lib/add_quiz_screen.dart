import 'package:flutter/material.dart';
import 'package:memorization_and_clock/model/load_quiz_data.dart';
import 'package:memorization_and_clock/model/start_quiz_service.dart';
import 'package:memorization_and_clock/quiz_format_screen.dart';
import 'package:memorization_and_clock/quiz_screen.dart';
import 'model/quiz_manager.dart';
import 'model/quiz_database_helper.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({super.key, required this.ele});

  final QuizList ele;

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  List<QuizData> _quizData = [];
  QuizDatabaseHelper dbHelper = QuizDatabaseHelper();
  late List<Map> quizMap;

  @override
  void initState() {
    super.initState();
    _fetchQuiz(widget.ele);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモクロ'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: _quizData.isEmpty
                ? null
                : () async {
                quizMap = await getQuizMap(widget.ele.id!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizScreen(quizMap: quizMap, isTest: false, alarmId: -1,),
                  ),
                );
              },
              child: const Text("解答スタート"),
            ),
          ),
          Expanded(
              child: _buildQuizData(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:  () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizFormatScreen(
                    ele: null,
                    quizListId: widget.ele.id!,
                  ),
              ),
          );
          if (result == true) {
            _fetchQuiz(widget.ele);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _fetchQuiz(QuizList ele) async {
    List<Map<String, dynamic>> list = await dbHelper.getQuizData(ele.id!);
    setState(() {
      _quizData = list.map((map) => QuizData.fromMap(map)).toList();
    });
  }

  Widget _buildQuizData() {
    return ListView.builder(
      itemCount: _quizData.length,
      itemBuilder: (context, index){
        QuizData ele = _quizData[index];
        return Card(
          child: ListTile(
            title: Text(ele.question),
            onTap: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizFormatScreen(
                          ele: ele,
                          quizListId: widget.ele.id!
                      ),
                  )
              );
              if (result == true) {
                _fetchQuiz(widget.ele);
              }
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteAlart(ele);
              },
            ),
          ),
        );
      },
    );
  }

  _deleteQuiz(QuizData ele) async{
    await dbHelper.deleteQuiz(ele.id!);
    _fetchQuiz(widget.ele);
  }

  _deleteAlart(QuizData ele) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('問題削除'),
            content: const Text('削除しますか'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('いいえ'),
              ),
              TextButton(
                onPressed: () {
                  _deleteQuiz(ele);
                  Navigator.of(context).pop();
                },
                child: const Text('はい'),
              ),
            ],
          );
        }
    );
  }
}