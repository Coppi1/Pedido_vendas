import 'package:projeto_pedido_vendas/models/vendedor.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

class VendedorDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  Future<Vendedor?> selectById(int id) async {
    final db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      'vendedor',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Vendedor.fromJson(maps[0]);
    } else {
      return null;
    }
  }

  Future<List<Vendedor>> selectAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('vendedor');
    return List.generate(maps.length, (i) {
      return Vendedor.fromJson(maps[i]);
    });
  }

  Future<int> insert(Vendedor vendedor) async {
    final db = await _db;
    print('Inserindo vendedor: ${vendedor.toJson()}');
    int id = await db.insert(
      'vendedor',
      vendedor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Vendedor inserido com ID: $id');
    return id;
  }

  // Método obterVendedorPorEmail para buscar um vendedor pelo email
  Future<Vendedor?> obterVendedorPorEmail(String email) async {
    final db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      'vendedor',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return Vendedor.fromJson(maps.first);
    } else {
      return null;
    }
  }
}
