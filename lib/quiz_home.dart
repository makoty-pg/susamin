import 'package:flutter/material.dart';
import 'model/quiz_database_helper.dart';
import 'model/quiz_manager.dart';

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  List<QuizList> _quizList = [];
  QuizDatabaseHelper dbHelper = QuizDatabaseHelper();

  @override
  void initState() {
    super.initState();
    _fetchQuizList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモクロ'),
        backgroundColor: Colors.purple,
      ),
      body: _buildQuizList(),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: const Icon(Icons.add),
      ),
    );
  }

  _fetchQuizList() async {
    List<Map<String, dynamic>> list = await dbHelper.getListData();
    setState(() {
      _quizList = list.map((map) => QuizList.fromMap(map)).toList();
    });
  }

  Widget _buildQuizList() {
    return ListView.builder(
      itemCount: _quizList.length,
      itemBuilder: (context, index){
        QuizList ele = _quizList[index];
        return Card(
          child: ListTile(
            title: Text(ele.title),
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

  _deleteQuizList(QuizList ele) async{
    await dbHelper.deleteData(ele.id!);
    _fetchQuizList();
  }

  _deleteAlart(QuizList ele) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('問題集削除'),
          content: Text('削除しますか'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                _deleteQuizList(ele);
                Navigator.of(context).pop();
              },
              child: Text('はい'),
            ),
          ],
        );
      }
    );
  }
}

