import 'package:flutter/material.dart';
import 'route.dart';
import 'package:alarm/alarm.dart';
import 'model/alarm_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(); // await を使うために main() を async にする
  AlarmDatabase.instance.syncAlarmsWithSystem();
  runApp(const MyApp());

}
