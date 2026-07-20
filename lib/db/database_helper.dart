import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// One shared database connection for the whole app (singleton).
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ohayo_tasks.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          done INTEGER NOT NULL DEFAULT 0,
          dueDate TEXT,
          priority TEXT NOT NULL DEFAULT 'normal'
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          try {
            await db.execute("ALTER TABLE tasks ADD COLUMN priority TEXT NOT NULL DEFAULT 'normal'");
          } catch (e) {
            // Column already exists from a previous run — safe to ignore.
          }
        }
      },
    );
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return db.query('tasks', orderBy: 'id DESC');
  }

  Future<int> updateTask(int id, Map<String, dynamic> task) async {
    final db = await database;
    return db.update('tasks', task, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}