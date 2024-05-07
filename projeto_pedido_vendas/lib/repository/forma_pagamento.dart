import 'package:path/path.dart';
import 'package:projeto_pedido_vendas/models/forma_pagamento.dart';
import 'package:sqflite/sqflite.dart';

class FormaPagamentoDAO {
  static final _tableName = 'forma_pagamento';

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

  static Future<void> insert(FormaPagamento formaPagamento) async {
    final db = await _openDB();
    await db.insert(
      _tableName,
      formaPagamento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<FormaPagamento>> selectAll() async {
    final db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return FormaPagamento(
        id: maps[i]['id'],
        descricao: maps[i]['descricao'],
      );
    });
  }

  static Future<FormaPagamento?> selectById(int id) async {
    final db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return FormaPagamento(
      id: maps[0]['id'],
      descricao: maps[0]['descricao'],
    );
  }
}
