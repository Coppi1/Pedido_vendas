import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

class PedidoDAO {
  // final Database _db;
  Future<Database> get _db async => await Conexao.instance.database;

  // Método para inserir um pedido no banco de dados
  Future<void> insert(PedidoDTO pedido) async {
    final db = await _db;
    await db.insert('pedido', pedido.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Método para atualizar um pedido no banco de dados
  Future<void> update(PedidoDTO pedidoDTO) async {
    final db = await _db;
    await db.update(
      'pedido',
      pedidoDTO.toMap(),
      where: 'id = ?',
      whereArgs: [pedidoDTO.id],
    );
  }

  // Método para excluir um pedido do banco de dados
  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(
      'pedido',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para selecionar um pedido pelo ID
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

  // Método para selecionar todos os pedidos
  Future<List<PedidoDTO>> selectAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('pedido');
    return List.generate(maps.length, (i) {
      return PedidoDTO.fromJson(maps[i]);
    });
  }

  // Método para obter o último pedido inserido
  Future<PedidoDTO?> obterUltimo() async {
    try {
      final db = await _db;

      // Query the database to get the last inserted record based on the primary key
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
