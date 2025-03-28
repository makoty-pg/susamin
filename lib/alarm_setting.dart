import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class AlarmSetting extends StatefulWidget {
  const AlarmSetting({super.key});

  @override
  _AlarmSettingState createState() => _AlarmSettingState();
}

class _AlarmSettingState extends State<AlarmSetting> {
  String dateText = '設定日時: 2000年    01月01日  00:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモクロ'),
        backgroundColor: Colors.purple,

      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFd9ded8), // #d9ded8
              Color(0xffdf91f8), // #ebc0fd
            ],
            begin: Alignment.bottomCenter, // 下から上にグラデーション
            end: Alignment.topCenter, // 上までグラデーション
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20), // 上部に余白を追加
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 上に詰める
            crossAxisAlignment: CrossAxisAlignment.center, // 中央寄せ
            children: <Widget>[
              Text(
                dateText,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold, // 太字にする
                  color: Colors.white, // 文字色
                ),
              ),
              const SizedBox(height: 100), // 余白を追加（調整可）
              ElevatedButton.icon(
                onPressed: () {
                  DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(2000, 1, 1),
                    maxTime: DateTime(2025, 12, 31),
                    onConfirm: (date) {
                      setState(() {
                        dateText =
                        '設定日時: ${date.year}年    ${date.month}月${date.day}日  ${date.hour}:${date.minute}';
                      });
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.jp,
                  );
                },
                icon: const Icon(
                  Icons.watch_later, // アラームのアイコン
                  size: 30, // アイコンのサイズ
                  color: Colors.white, // アイコンの色
                ),
                label: const Text(
                  '日付と時刻を変更',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white, // 文字色
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // ボタンの背景色
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30), // 余白を調整
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 角を丸くする
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
