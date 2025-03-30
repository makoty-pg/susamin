import 'package:flutter/material.dart';
import 'package:memorization_and_clock/quiz_screen.dart';
import 'model/start_quiz_service.dart';
import 'route.dart';
import 'package:alarm/alarm.dart';
import 'model/alarm_database.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(); // await を使うために main() を async にする
  AlarmDatabase.instance.syncAlarmsWithSystem();

  runApp(const MyApp());

  Alarm.ringStream.stream.listen((alarm) async {
    print("現在のidは ${alarm.id} 回です");
    final questionId = await AlarmDatabase.instance.getQuestionId(alarm);
    List<Map> quizMap = await getQuizMap(questionId!);
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => QuizScreen(quizMap: quizMap, isTest: true, alarmId: alarm.id)),
    );
    print("現在の問題集idは ${questionId ?? '不明'} です");
  });
}
