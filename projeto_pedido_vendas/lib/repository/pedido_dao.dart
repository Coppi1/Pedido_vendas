import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

class PedidoDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  Future<int> insert(PedidoDTO pedido) async {
    final db = await _db;

    int id = await db.insert('pedido', pedido.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<void> update(PedidoDTO pedidoDTO) async {
    final db = await _db;
    await db.update(
      'pedido',
      pedidoDTO.toMap(),
      where: 'id = ?',
      whereArgs: [pedidoDTO.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(
      'pedido',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<PedidoDTO?> selectById(String id) async {
    final db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      'pedido',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return PedidoDTO.fromJson(maps[0]);
    } else {
      return null;
    }
  }

  Future<List<PedidoDTO>> selectAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('pedido');
    return List.generate(maps.length, (i) {
      return PedidoDTO.fromJson(maps[i]);
    });
  }

  Future<PedidoDTO?> obterUltimo() async {
    try {
      final db = await _db;

      List<Map<String, dynamic>> maps =
          await db.rawQuery('SELECT * FROM pedido ORDER BY id DESC LIMIT 1');

      if (maps.isNotEmpty) {
        return PedidoDTO.fromJson(maps[0]);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro: $e');
      return null;
    }
  }
}
