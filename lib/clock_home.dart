import 'package:alarm/model/volume_settings.dart';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
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
    setState(() {
      _alarms = AlarmDatabase.instance.getAllAlarms();
    });
  }

  void _deleteAlarm(int id) async {
    await AlarmDatabase.instance.deleteAlarm(id);
    _fetchAlarms();
  }

  void _addTestAlarm() async {
    final now = DateTime.now().add(const Duration(minutes: 1));
    final alarm = AlarmSettings(
      id: now.millisecondsSinceEpoch % 100000, // 一意のIDを生成
      dateTime: now,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
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
    await AlarmDatabase.instance.insertAlarm(alarm);
    await Alarm.set(alarmSettings: alarm);
    _fetchAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<List<AlarmSettings>>(
        future: _alarms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('エラー: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('アラームがありません'));
          }

          final alarms = snapshot.data!;

          return ListView.separated(
            itemCount: alarms.length,
            itemBuilder: (context, index) {
              final alarm = alarms[index];
              return ListTile(
                title: Text('${alarm.dateTime.hour}:${alarm.dateTime.minute}'),
                subtitle: Text('${alarm.dateTime.month}/${alarm.dateTime.day}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteAlarm(alarm.id),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _addTestAlarm,
      ),
    );
  }
}
