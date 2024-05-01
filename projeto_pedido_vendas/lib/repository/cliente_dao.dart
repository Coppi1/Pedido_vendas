import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

class ClienteDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  Future<List<Cliente>> selectAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('cliente');
    return List.generate(maps.length, (i) {
      return Cliente.fromJson(maps[i]);
    });
  }

  Future<Cliente?> obterUltimo() async {
    try {
      final db = await _db;
      List<Map<String, dynamic>> maps =
          await db.rawQuery('SELECT * FROM cliente ORDER BY id DESC LIMIT 1');
      if (maps.isNotEmpty) {
        return Cliente.fromJson(maps[0]);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro: $e');
      return null;
    }
  }

  Future<int> insert(ClienteDTO clienteDTO) async {
    final db = await _db;
    return await db.insert(
      'cliente',
      clienteDTO.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
