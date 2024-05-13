import 'package:projeto_pedido_vendas/models/categoria_produto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

class CategoriaProdutoDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  Future<void> insert(CategoriaProduto categoriaProduto) async {
    final db = await _db;
    await db.insert(
      'categoria_produto',
      categoriaProduto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CategoriaProduto>> selectAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('categoria_produto');
    return List.generate(maps.length, (i) {
      return CategoriaProduto(
        id: maps[i]['id'],
        descricao: maps[i]['descricao'],
      );
    });
  }
}
