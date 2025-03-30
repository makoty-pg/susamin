import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:memorization_and_clock/quiz_screen.dart';

import 'model/alarm_database.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.result, required this.quizMap, required this.isTest, required this.alarmId});
  final int result;
  final List<Map> quizMap;
  final bool isTest;
  final int alarmId;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String comment;

  Future<void> goToScreen(BuildContext context, int rate) async {
    if (widget.isTest) {
      if (rate >= 80.0) {
        await Alarm.stopAll();
        await AlarmDatabase.instance.deleteAlarm(widget.alarmId);
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              quizMap: widget.quizMap,
              isTest: widget.isTest, alarmId: widget.alarmId,
            ),
          ),
        );

      }
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    int rate = widget.result.round() * 100 ~/ widget.quizMap.length;
    String buttonText;

    if (widget.isTest && rate < 80.0) {
      buttonText = "もう一度";
    } else if (widget.isTest && rate >= 80.0){
      buttonText = "アラーム停止";
    } else {
      buttonText = "トップへ戻る";
    }

    if (rate >= 80.0) {
      comment = "合格！";
    }else{
      comment = "不合格";
    }

    return Scaffold(
      body: Center(
        child: Column(
          //Columnの中に入れたものは縦に並べられる．Rowだと横に並べられる
          mainAxisAlignment: MainAxisAlignment.center, //Coloumの中身を真ん中に配置
          children: <Widget>[
            Text(comment),
            Text('正答数${widget.result}'),
            Text('正答率$rate%'),
            ElevatedButton(
                onPressed: () async {
                  await goToScreen(context, rate);
                },
                child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}
