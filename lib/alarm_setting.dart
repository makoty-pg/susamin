import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:memorization_and_clock/model/load_quiz_data.dart';
import 'package:memorization_and_clock/model/quiz_manager.dart';


class AlarmSetting extends StatefulWidget {
  const AlarmSetting({super.key});

  @override
  _AlarmSettingState createState() => _AlarmSettingState();
}

class _AlarmSettingState extends State<AlarmSetting> {
  DateTime defaultDateTime = DateTime.now().add(const Duration(days: 1)).copyWith(hour: 6, minute: 0);
  String dateText = '';
  String? dropdownValue;
  List<QuizList> quizList = [];

  @override
  void initState() {
    super.initState();
    dateText = '設定日時: ${defaultDateTime.year}年${defaultDateTime.month}月${defaultDateTime.day}日 ${defaultDateTime.hour}:${defaultDateTime.minute}';
    loadQuizData();
  }

  Future<void> loadQuizData() async {////////////////////この辺の処理あってるかみてほし
    LoadQuizData loadQuizData = LoadQuizData();
    List<QuizList> loadedQuizList = await loadQuizData.loadQuizList();
    setState(() {
      quizList = loadedQuizList;
      if (quizList.isNotEmpty) {
        dropdownValue = quizList[0].title;
      }
    });
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
                      dateText =
                      '設定日時: ${date.year}年${date.month}月${date.day}日 ${date.hour}:${date.minute}';
                    });
                  },
                  currentTime: defaultDateTime,
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
        onPressed: () {
          // アラーム登録の処理をここに書く
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('アラームが登録されました！')),
          );
        },
        label: const Text('追加'),
        backgroundColor: Colors.purple,
      ),
    );
  }


}

