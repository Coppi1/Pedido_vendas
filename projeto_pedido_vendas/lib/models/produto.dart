import 'dart:convert';

import 'package:projeto_pedido_vendas/models/categoria_produto.dart';

class Produto {
  int? id;
  String? marca;
  String? unidade;
  String? tipoProduto;
  String nome;
  double? valor;
  CategoriaProduto? categoriaProduto;

  @override
  String toString() {
    return nome;
  }

  Produto(
      {this.id,
      required this.marca,
      required this.unidade,
      required this.tipoProduto,
      required this.nome,
      required this.valor,
      this.categoriaProduto});
}
