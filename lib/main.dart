import 'package:flutter/material.dart';
import 'route.dart';
import 'package:alarm/alarm.dart';
import 'model/alarm_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(); // await を使うために main() を async にする
  AlarmDatabase.instance.syncAlarmsWithSystem();
  Alarm.ringStream.stream.listen((alarm) async {
    print("現在のidは ${alarm.id} 回です");

    final questionId = await AlarmDatabase.instance.getQuestionId(alarm);
    print("現在の問題集idは ${questionId ?? '不明'} です");
  });

  runApp(const MyApp());

}
