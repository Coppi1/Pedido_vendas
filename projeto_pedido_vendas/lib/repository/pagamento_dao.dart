import 'package:projeto_pedido_vendas/dtos/pagamento_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

class PagamentoDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  Future<void> insert(PagamentoDTO pagamento) async {
    final db = await _db;
    await db.insert('pagamento_pedido', pagamento.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete(
      'pagamento_pedido',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<PagamentoDTO?> select(int id) async {
    final db = await _db;
    List<Map<String, dynamic>> maps =
        await db.query('pagamento_pedido', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return PagamentoDTO.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateDescontoEVencimento(
      int pagamentoId, double desconto, String dataVencimento) async {
    final db = await _db;
    await db.update(
      'pagamento_pedido',
      {
        'desconto': desconto,
        'dataVencimento': dataVencimento,
      },
      where: 'id = ?',
      whereArgs: [pagamentoId],
    );
  }

  Future<PagamentoDTO?> buscarPagamentoPorId(int pedidoId) async {
    final db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      'pagamento_pedido',
      where: 'pedidoId = ?',
      whereArgs: [pedidoId],
    );
    if (maps.isNotEmpty) {
      return PagamentoDTO.fromJson(maps.first);
    } else {
      return null;
    }
  }
}
