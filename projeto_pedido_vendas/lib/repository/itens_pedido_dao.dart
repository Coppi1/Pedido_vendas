import 'dart:convert';

import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

class ItensPedidoDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  Future<void> insert(ItensPedidoDTO itens) async {
    final db = await _db;
    await db.insert('itens', {'produtos': json.encode(itens.toJson())},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(ItensPedidoDTO itens) async {
    final db = await _db;
    await db.update(
      'itens',
      {'produtos': json.encode(itens.toJson())},
    );
  }

  Future<void> delete() async {
    final db = await _db;
    await db.delete('itens');
  }

  Future<ItensPedidoDTO?> select() async {
    final db = await _db;
    List<Map<String, dynamic>> maps = await db.query('itens');
    if (maps.isNotEmpty) {
      return ItensPedidoDTO.fromJson(json.decode(maps[0]['produtos']));
    } else {
      return null;
    }
  }
}
