import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'calculator.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expression TEXT,
        result TEXT
      )
    ''');
  }

  Future<void> insertCalculation(String expression, String result) async {
    final db = await database;
    await db.insert('history', {'expression': expression, 'result': result});
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'id DESC');
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history');
  }
}
