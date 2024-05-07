import 'package:projeto_pedido_vendas/models/categoria_produto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CategoriaProdutoDAO {
  static final _tableName = 'categoria_produto';

  static Future<Database> _openDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY,
            descricao TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insert(CategoriaProduto categoriaProduto) async {
    final db = await _openDB();
    await db.insert(
      _tableName,
      categoriaProduto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<CategoriaProduto>> selectAll() async {
    final db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return CategoriaProduto(
        id: maps[i]['id'],
        descricao: maps[i]['descricao'],
      );
    });
  }

  static Future<CategoriaProduto?> selectById(int id) async {
    final db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return CategoriaProduto(
      id: maps[0]['id'],
      descricao: maps[0]['descricao'],
    );
  }
}
