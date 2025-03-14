import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuizDatabaseHelper {
  static final QuizDatabaseHelper _instance = QuizDatabaseHelper._internal();
  
  factory QuizDatabaseHelper() {
    return _instance;
  }
  
  QuizDatabaseHelper._internal();
  
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }
  
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), "quiz_database.db");
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE quiz_list (
            id INTEGER PRIMARY KEY,
            title TEXT,
          )
        ''');
        await db .execute('''
          CREATE TABLE quiz (
            id INTEGER PRIMARY KEY,
            quizListId INTEGER NOT NULL,
            question TEXT,
            option1 TEXT,
            option2 TEXT,
            option3 TEXT,
            option4 TEXT,
            answer TEXT,
            FOREIGN KEY (quizListId) REFERENCES quiz_list (id)
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getListData() async {
    final Database? db = await database;
    return await db!.query('quiz_list');
  }

  Future<void> insertList(Map<String, dynamic> data) async {
    final Database? db = await database;
    await db!.insert('quiz_list', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteData(int id) async {
    final Database? db = await database;
    await db!.transaction((txn) async {
      await db.delete('quiz', where: 'id = ?', whereArgs: [id]);
      await db.delete('quiz_list', where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<List<Map<String, dynamic>>> getQuizData(int quizListId) async {
    final Database? db = await database;
    return await db!.query('quiz', where: 'quizListId = ?', whereArgs: [quizListId],);
  }

  Future<void> insertQuiz(Map<String, dynamic> data) async {
    final Database? db = await database;
    await db!.insert('quiz', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateQuiz(int id, Map<String, dynamic> data) async {
    final Database? db = await database;
    return await db!.update('quiz', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteQuiz(int id) async {
    final Database? db = await database;
    await db!.delete('quiz', where: 'id = ?', whereArgs: [id]);
  }
}