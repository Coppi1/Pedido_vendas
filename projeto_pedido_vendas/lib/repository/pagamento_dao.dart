import 'package:projeto_pedido_vendas/dtos/pagamento_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

class PagamentoDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  Future<void> insert(PagamentoDTO pagamento) async {
    final db = await _db;
    await db.insert(
      'pagamento',
      pagamento.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(PagamentoDTO pagamento) async {
    final db = await _db;
    await db.update(
      'pagamento',
      pagamento.toJson(),
      where: 'id = ?',
      whereArgs: [pagamento.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete(
      'pagamento',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<PagamentoDTO?> select(int id) async {
    final db = await _db;
    List<Map<String, dynamic>> maps =
        await db.query('pagamento', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return PagamentoDTO.fromJson(maps.first);
    } else {
      return null;
    }
  }
}
