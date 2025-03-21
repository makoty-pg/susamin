import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({super.key, required this.result, required this.length, required this.isTest, required this.alarmId});
  int result;
  int length;
  bool isTest;
  int alarmId;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
