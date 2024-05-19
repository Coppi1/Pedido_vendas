import 'package:projeto_pedido_vendas/dtos/forma_pagamento_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'conexao.dart';

class FormaPagamentoDAO {
  Future<Database> get _db async => await Conexao.instance.database;

  // Método para inserir forma de pagamento no banco de dados
  Future<void> insert(FormaPagamentoDTO formaPagamento) async {
    final db = await _db;
    await db.insert(
      'forma_pagamento',
      formaPagamento.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para atualizar forma de pagamento no banco de dados
  Future<void> update(FormaPagamentoDTO formaPagamento) async {
    final db = await _db;
    await db.update(
      'forma_pagamento',
      formaPagamento.toJson(),
      where: 'id = ?',
      whereArgs: [formaPagamento.id],
    );
  }

  // Método para excluir forma de pagamento do banco de dados
  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete(
      'forma_pagamento',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para selecionar todas as formas de pagamento armazenadas no banco de dados
  Future<List<FormaPagamentoDTO>> selectAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('forma_pagamento');

    return List.generate(maps.length, (i) {
      return FormaPagamentoDTO(
        id: maps[i]['id'],
        descricao: maps[i]['descricao'],
      );
    });
  }
}
