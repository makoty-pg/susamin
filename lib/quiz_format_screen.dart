import 'package:flutter/material.dart';
import 'package:memorization_and_clock/model/quiz_manager.dart';
import 'model/quiz_database_helper.dart';

class QuizFormatScreen extends StatefulWidget {
  const QuizFormatScreen({
    super.key,
    required this.ele,
    required this.quizListId,
  });

  final QuizData? ele; // 編集の場合に渡されるクイズデータ
  final int quizListId; // 所属するクイズリストのID

  @override
  State<QuizFormatScreen> createState() => _QuizFormatScreenState();
}

class _QuizFormatScreenState extends State<QuizFormatScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  late QuizDatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = QuizDatabaseHelper();

    // 編集モードの場合、既存のクイズデータを設定
    if (widget.ele != null) {
      _questionController.text = widget.ele!.question;
      _option1Controller.text = widget.ele!.option1; // 修正済み
      _option2Controller.text = widget.ele!.option2;
      _option3Controller.text = widget.ele!.option3;
      _option4Controller.text = widget.ele!.option4;
      _answerController.text = widget.ele!.answer.toString(); // 安全に型を変換
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    _option4Controller.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _saveQuiz() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // フォーカスをリセット

      final quizData = QuizData(
        id: widget.ele?.id, // 既存データの編集の場合はIDを保持
        quizListId: widget.quizListId,
        question: _questionController.text,
        option1: _option1Controller.text,
        option2: _option2Controller.text,
        option3: _option3Controller.text,
        option4: _option4Controller.text,
        answer: int.tryParse(_answerController.text) ?? 0, // 安全に変換
      );


      if (widget.ele == null) {
        // 新規追加
        await dbHelper.insertQuiz(quizData.toMap());
      } else {
        // 編集
        await dbHelper.updateQuiz(quizData.id!, quizData.toMap());
      }
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ele == null ? 'クイズ追加' : 'クイズ編集'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: '問題文'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '問題文を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _option1Controller,
                decoration: const InputDecoration(labelText: '選択肢1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '選択肢1を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _option2Controller,
                decoration: const InputDecoration(labelText: '選択肢2'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '選択肢2を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _option3Controller,
                decoration: const InputDecoration(labelText: '選択肢3'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '選択肢3を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _option4Controller,
                decoration: const InputDecoration(labelText: '選択肢4'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '選択肢4を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _answerController,
                decoration: const InputDecoration(labelText: '正解'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '正解の選択肢番号を入力';
                  }
                  if (int.tryParse(value) == null) {
                    return '数値で入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveQuiz,
                child: Text(widget.ele == null ? '追加' : '変更'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
