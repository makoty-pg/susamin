import 'package:flutter/material.dart';
import 'add_quiz_screen.dart';
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
        title: const Center(
          child: Text(
            'メモクロ',
            style: TextStyle(
              fontSize: 28, // 文字を大きくする
              fontWeight: FontWeight.bold, // 太字
              color: Colors.white, // 白色
              letterSpacing: 2.0, // 文字間を広げる
            ),
          ),
        ),
        backgroundColor: Colors.purple, // 背景色
        centerTitle: true, // タイトルを中央揃え
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFebc0fd), // ピンク系
              Color(0xFFd9ded8), // グレー系
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: _buildQuizList(), // クイズリストを表示
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuizList,
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddQuizScreen(ele: ele),
                )
              );
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

  _deleteQuizList(QuizList ele) async{
    await dbHelper.deleteData(ele.id!);
    _fetchQuizList();
  }

  _deleteAlart(QuizList ele) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('問題集削除'),
          content: const Text('削除しますか'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                _deleteQuizList(ele);
                Navigator.of(context).pop();
              },
              child: const Text('はい'),
            ),
          ],
        );
      }
    );
  }

  void _addQuizList() {
    TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('問題集の追加'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'タイトルを入力してください',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty){
                    QuizList newList = QuizList(title: controller.text);
                    _insertQuizList(newList);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('追加'),
              ),
            ],
          );
        }
    );
  }

  _insertQuizList(QuizList list) async {
    await dbHelper.insertList(list.toMap());
    _fetchQuizList();
  }
}

