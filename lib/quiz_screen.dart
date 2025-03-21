import 'package:flutter/material.dart';
import 'package:memorization_and_clock/result_screen.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({super.key, required this.quizMap, required this.isTest, required this.alarmId});
  final List<Map> quizMap;
  final bool isTest;
  final int alarmId;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Map> quizMap;
  int index = 0;
  int result = 0;
  bool isSelectNow = true;

  @override
  void initState() {
    quizMap = widget.quizMap;
    super.initState();
  }

  Future<void> updateQuiz(BuildContext context, int selectAnswer) async {
    setState(() {
      isSelectNow = false;
    });
    if (quizMap[index]["answer"] == selectAnswer) {
      result++;
    }

    await Future.delayed(const Duration(seconds: 1));
    isSelectNow = true;
    setState(() {});
    index++;
    if (index == quizMap.length) {
      await goToResult(context, widget.isTest, widget.alarmId);
    }
    setState(() {});
  }

  Future<void> goToResult(BuildContext context, bool isTest, int alarmId) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreen(result: result, length: quizMap.length, isTest: isTest, alarmId: alarmId,)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: index < quizMap.length
      ? CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3
                  )
              ),
              Text(
                quizMap[index]['question'],
                textAlign: TextAlign.center,
              ),
            ])
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, key) {
                  int useKey = key + 1;
                  return TextButton(
                    onPressed: () async {
                      if (!isSelectNow) return;
                      await updateQuiz(context, useKey);
                    },
                    child: isSelectNow
                    ? Text(quizMap[index]["option$useKey"])
                    : quizMap[index]["answer"] == useKey
                      ? Text(quizMap[index]["option$useKey"] + "○")
                      : Text(quizMap[index]["option$useKey"] + "×")
                  );
                },
              childCount: 4,
            )
          ),
        ],
      )
      : Container(),
    );
  }
}