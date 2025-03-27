import 'package:alarm/alarm.dart';
import 'dart:io';

import 'package:alarm/model/volume_settings.dart';

class AlarmManager {
  static final List<AlarmSettings> _alarms = [];

  static Future<int> getNextAlarmId() async {//時刻順にソートし、次のidを返す
    if (_alarms.isEmpty) return 1;
    _alarms.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return _alarms.last.id + 1;
  }

  static Future<void> setAlarm(DateTime dateTime) async {//アラームを設定する
    int id = await getNextAlarmId();
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fixed(
        volume: 0.8,
        volumeEnforced: true,
      ),
      notificationSettings: const NotificationSettings(
        title: 'This is the title',
        body: 'This is the body',
        stopButton: 'Stop the alarm',
        icon: 'notification_icon',
      ),
    );
    _alarms.add(alarmSettings);
    await Alarm.set(alarmSettings: alarmSettings);
  }

  static Future<void> cancelAlarm(int id) async {//指定したidのアラームを削除する
    _alarms.removeWhere((alarm) => alarm.id == id);
    await Alarm.stop(id);
  }

  static List<AlarmSettings> getAllAlarms() {//全ての登録されたアラームをリスト形式で取得する
    _alarms.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return List.unmodifiable(_alarms);
  }
}
