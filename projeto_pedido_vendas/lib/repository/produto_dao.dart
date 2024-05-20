import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

class ProdutoDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  Future<void> insert(Produto produto) async {
    final db = await _db;
    await db.insert('produto', produto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(Produto produto) async {
    final db = await _db;
    await db.update(
      'produto',
      produto.toJson(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete(
      'produto',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Produto?> selectById(int id) async {
    final db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      'produto',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Produto.fromJson(maps[0]);
    } else {
      return null;
    }
  }

  Future<List<Produto>> selectAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('produto');
    return List.generate(maps.length, (i) {
      return Produto.fromJson(maps[i]);
    });
  }

  Future<Produto?> obterUltimo() async {
    try {
      final db = await _db;
      List<Map<String, dynamic>> maps =
          await db.rawQuery('SELECT * FROM produto ORDER BY id DESC LIMIT 1');
      if (maps.isNotEmpty) {
        return Produto.fromJson(maps[0]);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro: $e');
      return null;
    }
  }

  Future<List<Produto>> selectByCategoria(int categoriaProdutoId) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'produto',
      where: 'categoriaProdutoId =?',
      whereArgs: [categoriaProdutoId],
    );
    return List.generate(maps.length, (i) {
      return Produto.fromJson(maps[i]);
    });
  }
}
