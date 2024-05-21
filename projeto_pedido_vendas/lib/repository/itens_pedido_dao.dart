import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';

class ItensPedidoDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  Future<void> insert(ItensPedidoDTO itens) async {
    final db = await _db;
    Map<String, dynamic> mapItens = {
      'pedidoId': itens.pedido?.id,
      'produtoId': itens.produto?.id,
      'quantidade': itens.quantidade,
      'valorTotal': itens.valorTotal,
    };
    await db.insert('itens_pedido', mapItens,
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

  // Future<List<ItensPedidoDTO>> selectByPedido(int pedidoId) async {
  //   final db = await _db;
  //   List<Map<String, dynamic>> maps = await db.query(
  //     'itens_pedido',
  //     where: 'pedidoId =?',
  //     whereArgs: [pedidoId],
  //   );

  //   return maps.map((map) {
  //     String produtosJson =
  //         map['produtos'] ?? '{}'; // '{}' como valor padrão se for null
  //     return ItensPedidoDTO.fromJson(json.decode(produtosJson));
  //   }).toList();
  // }

  Future<List<ItensPedidoDTO>> selectByPedido(int? pedidoId) async {
    if (pedidoId == null) {
      debugPrint('Id de produto não pode ser nulo');
      return [];
    }
    final db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      'itens_pedido',
      where: 'pedidoId =?',
      whereArgs: [pedidoId],
    );

    return maps.map((map) {
      String produtosJson = map['produtos'] ?? '{}';
      return ItensPedidoDTO.fromJson(json.decode(produtosJson));
    }).toList();
  }
}
