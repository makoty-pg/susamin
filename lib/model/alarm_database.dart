import 'package:alarm/model/volume_settings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:alarm/alarm.dart';

class AlarmDatabase {
  static final AlarmDatabase instance = AlarmDatabase._init();
  static Database? _database;

  AlarmDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('alarms.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }



  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE alarms (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      hour INTEGER NOT NULL,
      minute INTEGER NOT NULL,
      month INTEGER NOT NULL,
      day INTEGER NOT NULL,
      assetAudioPath TEXT NOT NULL DEFAULT 'assets/alarm.mp3',
      loopAudio INTEGER NOT NULL DEFAULT 1,
      vibrate INTEGER NOT NULL DEFAULT 1,
      warningNotificationOnKill INTEGER NOT NULL DEFAULT 0,
      androidFullScreenIntent INTEGER NOT NULL DEFAULT 1,
      volume REAL NOT NULL DEFAULT 0.8,
      volumeEnforced INTEGER NOT NULL DEFAULT 1
    )
  ''');
  }


  Future<int> insertAlarm(AlarmSettings alarm) async {//データベースにalarmを登録
    final db = await instance.database;
    return await db.insert('alarms', {
      'hour': alarm.dateTime.hour,
      'minute': alarm.dateTime.minute,
      'month': alarm.dateTime.month,
      'day': alarm.dateTime.day,
      'assetAudioPath': alarm.assetAudioPath,
      'loopAudio': alarm.loopAudio ? 1 : 0,
      'vibrate': alarm.vibrate ? 1 : 0,
      'warningNotificationOnKill': alarm.warningNotificationOnKill ? 1 : 0,
      'androidFullScreenIntent': alarm.androidFullScreenIntent ? 1 : 0,
      'volume': alarm.volumeSettings.volume,
      'volumeEnforced': alarm.volumeSettings.volumeEnforced ? 1 : 0,
    });
  }

  Future<int> deleteAlarm(int id) async {//データベースからalarmを削除
    final db = await instance.database;
    return await db.delete('alarms', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<AlarmSettings>> getAllAlarms() async {//データベースに登録されているalarmを全て取得
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query('alarms');

    return result.map((e) => AlarmSettings(
      id: e['id'],
      dateTime: DateTime(DateTime.now().year, e['month'], e['day'], e['hour'], e['minute']),
      assetAudioPath: e['assetAudioPath'],
      loopAudio: e['loopAudio'] == 1,
      vibrate: e['vibrate'] == 1,
      warningNotificationOnKill: e['warningNotificationOnKill'] == 1,
      androidFullScreenIntent: e['androidFullScreenIntent'] == 1,
      volumeSettings: VolumeSettings.fixed(
        volume: e['volume'],
        volumeEnforced: e['volumeEnforced'] == 1,
      ),
      notificationSettings: const NotificationSettings(
        title: 'This is the title',
        body: 'This is the body',
        stopButton: 'Stop the alarm',
        icon: 'notification_icon',
      ),
    )).toList();
  }

  Future<void> syncAlarmsWithSystem() async {
    // すべてのアラームを削除
    await Alarm.stopAll();

    // データベースからアラームを取得
    final alarms = await getAllAlarms();

    // 取得したアラームを再登録
    for (var alarm in alarms) {
      await Alarm.set(
        alarmSettings: AlarmSettings(
          id: alarm.id,
          dateTime: alarm.dateTime,
          assetAudioPath: alarm.assetAudioPath,
          loopAudio: alarm.loopAudio,
          vibrate: alarm.vibrate,
          warningNotificationOnKill: alarm.warningNotificationOnKill,
          androidFullScreenIntent: alarm.androidFullScreenIntent,
          volumeSettings: alarm.volumeSettings,
          notificationSettings: alarm.notificationSettings,
        ),
      );
    }
  }

}
