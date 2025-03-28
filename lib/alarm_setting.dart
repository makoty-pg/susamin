import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:memorization_and_clock/model/load_quiz_data.dart';
import 'package:memorization_and_clock/model/quiz_manager.dart';
import 'model/alarm_database.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/volume_settings.dart';

class AlarmSetting extends StatefulWidget {
  const AlarmSetting({super.key});

  @override
  _AlarmSettingState createState() => _AlarmSettingState();
}

class _AlarmSettingState extends State<AlarmSetting> {
  DateTime selectedDateTime = DateTime.now().add(const Duration(days: 1)).copyWith(hour: 6, minute: 0);
  String dateText = '';
  String? dropdownValue;
  List<QuizList> quizList = [];

  @override
  void initState() {
    super.initState();
    dateText = '設定日時: ${selectedDateTime.year}年${selectedDateTime.month}月${selectedDateTime.day}日 ${selectedDateTime.hour}:${selectedDateTime.minute}';
    loadQuizData();
  }

  Future<void> loadQuizData() async {
    LoadQuizData loadQuizData = LoadQuizData();
    List<QuizList> loadedQuizList = await loadQuizData.loadQuizList();
    setState(() {
      quizList = loadedQuizList;
      if (quizList.isNotEmpty) {
        dropdownValue = quizList[0].title;
      }
    });
  }

  Future<void> _addAlarm() async {
    if (dropdownValue == null) return;

    int? quizId = quizList.firstWhere((quiz) => quiz.title == dropdownValue).id;
    final alarm = AlarmSettings(
      id: DateTime.now().millisecondsSinceEpoch, // 一意のID
      dateTime: selectedDateTime,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: false,
      vibrate: true,
      warningNotificationOnKill: false,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fixed(
        volume: 0.8,
        volumeEnforced: true,
      ),
      notificationSettings: const NotificationSettings(
        title: 'アラーム',
        body: '設定した時間になりました',
        stopButton: '停止',
        icon: 'notification_icon',
      ),
    );

    await AlarmDatabase.instance.insertAlarm(alarm, quizId!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモクロ'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              dateText,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime.now().add(const Duration(days: 7)),
                  onConfirm: (date) {
                    setState(() {
                      selectedDateTime = date;
                      dateText =
                      '設定日時: ${date.year}年${date.month}月${date.day}日 ${date.hour}:${date.minute}';
                    });
                  },
                  currentTime: selectedDateTime,
                  locale: LocaleType.jp,
                );
              },
              child: const Text(
                '日付と時刻を変更',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  '問題の選択:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: quizList.map<DropdownMenuItem<String>>((QuizList quiz) {
                    return DropdownMenuItem<String>(
                      value: quiz.title,
                      child: Text(quiz.title),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAlarm,
        label: const Text('追加'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
