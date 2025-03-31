import 'package:alarm/model/volume_settings.dart';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'alarm_setting.dart';
import 'model/alarm_database.dart';

class ClockHomePage extends StatefulWidget {
  const ClockHomePage({super.key, required this.title});

  final String title;

  @override
  State<ClockHomePage> createState() => _ClockHomePageState();
}

class _ClockHomePageState extends State<ClockHomePage> {
  late Future<List<AlarmSettings>> _alarms;

  @override
  void initState() {
    super.initState();
    _fetchAlarms();


  }

  void _fetchAlarms() {
    AlarmDatabase.instance.syncAlarmsWithSystem();
    setState(() {
      _alarms = AlarmDatabase.instance.getAllAlarms();
    });
  }

  void _deleteAlarm(int id) async {
    await AlarmDatabase.instance.deleteAlarm(id);
    _fetchAlarms();
  }

  void _addTestAlarm() async {
    final now = DateTime.now().add(const Duration(seconds: 30));
    final alarm = AlarmSettings(
      id: 1, // 一意のIDを生成
      dateTime: now,
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
        title: 'テストアラーム',
        body: '1分後に鳴ります',
        stopButton: '停止',
        icon: 'notification_icon',
      ),
    );
    await AlarmDatabase.instance.insertAlarm(alarm,1);//テスト用で問題id1を選択
    _fetchAlarms();
    await Alarm.set(alarmSettings: alarm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'メモクロ',
            style: TextStyle(
              fontSize: 28, // 文字を大きくする
              fontWeight: FontWeight.bold, // 太字
              color: Colors.white, // 白色
              letterSpacing: 2.0, // 文字間を広げる
            ),
          ),
        ),
        backgroundColor: Colors.purple, // 背景色
        centerTitle: true, // タイトルを中央揃え
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [              Color(0xFFebc0fd), // ピンク系
              Color(0xFFd9ded8), ], // ピンク系グラデーション
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<AlarmSettings>>(
          future: _alarms,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'エラー: ${snapshot.error}',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'アラームがありません',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              );
            }

            final alarms = snapshot.data!;

            return ListView.separated(
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarms[index];
                return ListTile(
                  title: Text(
                    '${alarm.dateTime.hour}:${alarm.dateTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  subtitle: Text(
                    '${alarm.dateTime.month}/${alarm.dateTime.day}',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteAlarm(alarm.id),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(color: Colors.white54),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AlarmSetting()),
          );
          _fetchAlarms(); // 戻ってきた後に更新
        },
        backgroundColor: Colors.purple,
      ),
    );
  }
}