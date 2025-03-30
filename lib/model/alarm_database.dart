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

  Future<int> deleteAlarm(int id) async {
    final db = await instance.database;
    return await db.delete('alarms', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE alarms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    month INTEGER NOT NULL,
    day INTEGER NOT NULL,
    question_id INTEGER NOT NULL DEFAULT 0,
    assetAudioPath TEXT NOT NULL DEFAULT 'assets/alarm.mp3',
    loopAudio INTEGER NOT NULL DEFAULT 1,
    vibrate INTEGER NOT NULL DEFAULT 1,
    warningNotificationOnKill INTEGER NOT NULL DEFAULT 0,
    androidFullScreenIntent INTEGER NOT NULL DEFAULT 1,
    volume REAL NOT NULL DEFAULT 0.8,
    volumeEnforced INTEGER NOT NULL DEFAULT 1,
    title TEXT NOT NULL DEFAULT 'Alarm',
    body TEXT NOT NULL DEFAULT 'Alarm is ringing',
    icon TEXT NOT NULL DEFAULT 'notification_icon'
  )
''');
  }


  Future<int> insertAlarm(AlarmSettings alarm, int questionId) async {
    final db = await instance.database;
    return await db.insert('alarms', {
      'hour': alarm.dateTime.hour,
      'minute': alarm.dateTime.minute,
      'month': alarm.dateTime.month,
      'day': alarm.dateTime.day,
      'question_id': questionId,
      'assetAudioPath': alarm.assetAudioPath,
      'loopAudio': alarm.loopAudio ? 1 : 0,
      'vibrate': alarm.vibrate ? 1 : 0,
      'warningNotificationOnKill': alarm.warningNotificationOnKill ? 1 : 0,
      'androidFullScreenIntent': alarm.androidFullScreenIntent ? 1 : 0,
      'volume': alarm.volumeSettings.volume,
      'volumeEnforced': alarm.volumeSettings.volumeEnforced ? 1 : 0,
      'title': alarm.notificationSettings.title,
      'body': alarm.notificationSettings.body,
      'icon': alarm.notificationSettings.icon,
    });
  }


  Future<List<AlarmSettings>> getAllAlarms() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query('alarms');

    return result.map((e) => AlarmSettings(
      id: e['id'],
      dateTime: DateTime(DateTime.now().year, e['month'], e['day'], e['hour'], e['minute']),
      assetAudioPath: e['assetAudioPath'] ?? 'assets/alarm.mp3',
      loopAudio: e['loopAudio'] == 1,
      vibrate: e['vibrate'] == 1,
      warningNotificationOnKill: e['warningNotificationOnKill'] == 1,
      androidFullScreenIntent: e['androidFullScreenIntent'] == 1,
      volumeSettings: VolumeSettings.fixed(
        volume: e['volume'] ?? 0.8,
        volumeEnforced: e['volumeEnforced'] == 1,
      ),
      notificationSettings: NotificationSettings(
        title: e['title'] ?? 'Alarm',
        body: e['body'] ?? 'Alarm is ringing',
        icon: e['icon'] ?? 'notification_icon',
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
          notificationSettings: NotificationSettings(
            title: alarm.notificationSettings.title,
            body: alarm.notificationSettings.body,
            stopButton: alarm.notificationSettings.stopButton,
            icon: alarm.notificationSettings.icon,
          ),
        ),
      );
    }
  }

  Future<int?> getQuestionId(AlarmSettings alarm) async {//AlarmSettingsを渡すとquestion_idを返す
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query(
      'alarms',
      columns: ['question_id'],
      where: 'hour = ? AND minute = ? AND month = ? AND day = ?',
      whereArgs: [alarm.dateTime.hour, alarm.dateTime.minute, alarm.dateTime.month, alarm.dateTime.day],
    );

    if (result.isNotEmpty) {
      return result.first['question_id'] as int;
    }
    return null; // 見つからなかった場合は null を返す
  }

}
