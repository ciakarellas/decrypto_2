
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'decrypto.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE game_sets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        language TEXT NOT NULL,
        difficulty TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE words(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word_text TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE hints(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word_id INTEGER NOT NULL,
        hint_text TEXT NOT NULL,
        FOREIGN KEY (word_id) REFERENCES words(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE game_set_words(
        game_set_id INTEGER NOT NULL,
        word_id INTEGER NOT NULL,
        PRIMARY KEY (game_set_id, word_id),
        FOREIGN KEY (game_set_id) REFERENCES game_sets(id),
        FOREIGN KEY (word_id) REFERENCES words(id)
      )
    ''');
  }
}
