import 'package:projeto_pedido_vendas/dtos/pagamento_parcela_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

class PagamentoParcelaDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  Future<int> insert(PagamentoParcelaDTO parcela) async {
    final db = await _db;
    int id = await db.insert('pagamento_parcela', parcela.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<PagamentoParcelaDTO>> getAllByPagamento(int pagamentoId) async {
    final db = await _db;
    List<Map<String, dynamic>> maps = await db.query('pagamento_parcela',
        where: 'pagamentoId = ?', whereArgs: [pagamentoId]);
    return List.generate(maps.length, (i) {
      return PagamentoParcelaDTO.fromMap(maps[i]);
    });
  }
}
