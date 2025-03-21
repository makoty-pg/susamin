import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class AlarmSetting extends StatefulWidget {
  const AlarmSetting({super.key});

  @override
  _AlarmSettingState createState() => _AlarmSettingState();
}

class _AlarmSettingState extends State<AlarmSetting> {
  String dateText = '設定日時: 2000年01月01日 00:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモクロ'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20), // 上部に余白を追加
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 上に詰める
          crossAxisAlignment: CrossAxisAlignment.center, // 中央寄せ
          children: <Widget>[
            Text(
              dateText,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10), // 余白
            TextButton(
              onPressed: () {
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(2000, 1, 1),
                  maxTime: DateTime(2025, 12, 31),
                  onConfirm: (date) {
                    setState(() {
                      dateText =
                      '設定日時: ${date.year}年${date.month}月${date.day}日 ${date.hour}:${date.minute}';
                    });
                  },
                  currentTime: DateTime.now(),
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
          ],
        ),
      ),
    );
  }
}
