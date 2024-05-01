import 'dart:convert';

import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';

class ItensDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  // Método para inserir itens no banco de dados
  Future<void> insert(ItensDTO itens) async {
    final db = await _db;
    await db.insert('itens', {'produtos': json.encode(itens.toJson())},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Método para atualizar itens no banco de dados
  Future<void> update(ItensDTO itens) async {
    final db = await _db;
    await db.update(
      'itens',
      {'produtos': json.encode(itens.toJson())},
    );
  }

  // Método para excluir itens do banco de dados
  Future<void> delete() async {
    final db = await _db;
    await db.delete('itens');
  }

  // Método para selecionar os itens armazenados no banco de dados
  Future<ItensDTO?> select() async {
    final db = await _db;
    List<Map<String, dynamic>> maps = await db.query('itens');
    if (maps.isNotEmpty) {
      return ItensDTO.fromJson(json.decode(maps[0]['produtos']));
    } else {
      return null;
    }
  }
}
