import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future _createDatabase(Database db, int version) async {
    await db
        .execute('CREATE TABLE my_table (id INTEGER PRIMARY KEY, name TEXT)');
  }

  Future<void> insertData(String name) async {
    final db = await database;
    await db.insert('my_table', {'name': name});
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    return await db.query('my_table');
  }


  


}
