import 'package:flutter/material.dart';
import 'model/quiz_manager.dart';
import 'model/quiz_database_helper.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({super.key});

  _AddQuizScreenState createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: Column(),
      )
    );
  }
}