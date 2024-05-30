import 'dart:convert';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

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
      'itens_pedido',
      {
        'pedidoId': itens.pedido?.id,
        'produtoId': itens.produto?.id,
        'quantidade': itens.quantidade,
        'valorTotal': itens.valorTotal,
      },
      where: 'pedidoId = ? AND produtoId = ?',
      whereArgs: [itens.pedido?.id, itens.produto?.id],
    );
  }

  Future<void> delete(int pedidoId, int produtoId) async {
    final db = await _db;
    await db.delete(
      'itens_pedido',
      where: 'pedidoId = ? AND produtoId = ?',
      whereArgs: [pedidoId, produtoId],
    );
  }

  Future<ItensPedidoDTO?> select(int pedidoId, int produtoId) async {
    final db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      'itens_pedido',
      where: 'pedidoId = ? AND produtoId = ?',
      whereArgs: [pedidoId, produtoId],
    );
    if (maps.isNotEmpty) {
      return ItensPedidoDTO.fromJson(maps[0]);
    } else {
      return null;
    }
  }

  Future<List<ItensPedidoDTO>> selectByPedido(int pedidoId) async {
    final db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      'itens_pedido',
      columns: ['id', 'pedidoId', 'produtoId', 'quantidade', 'valorTotal'],
      where: 'pedidoId = ?',
      whereArgs: [pedidoId],
    );

    List<ItensPedidoDTO> itens = [];
    for (var map in maps) {
      int produtoId = map['produtoId'];
      Map<String, dynamic> produtoMap = await db.query(
        'produto',
        where: 'id = ?',
        whereArgs: [produtoId],
      ).then((value) => value.first);

      ItensPedidoDTO item = ItensPedidoDTO.fromJson(map);
      item.produto = ProdutoDTO.fromJson(produtoMap);
      itens.add(item);
    }

    return itens;
  }

  Future<void> deleteByPedido(int pedidoId) async {
    final db = await _db;
    await db.delete(
      'itens_pedido',
      where: 'pedidoId = ?',
      whereArgs: [pedidoId],
    );
  }

  Future<void> updateProduto(ProdutoDTO produto) async {
    final db = await _db;
    await db.update(
      'produto',
      {
        'marca': produto.marca,
        'unidade': produto.unidade,
        'nome': produto.nome,
        'valor': produto.valor,
        'categoriaProduto': jsonEncode(produto.categoriaProduto?.toJson()),
      },
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  Future<void> deleteProduto(int produtoId) async {
    final db = await _db;
    await db.delete(
      'produto',
      where: 'id = ?',
      whereArgs: [produtoId],
    );
  }
}
