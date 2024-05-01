import 'dart:convert';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';

class Pedido {
  String id;
  Itens itens;
  DateTime dataPedido;
  String observacao;
  String formaPagamento;
  bool? sincronizado;

  Pedido({
    required this.id,
    required this.itens,
    required this.dataPedido,
    required this.observacao,
    required this.formaPagamento,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itens': itens.produtos.map((produto) => produto.toJson()).toList(),
      'dataPedido': dataPedido.toIso8601String(),
      'observacao': observacao,
      'formaPagamento': formaPagamento,
      'sincronizado': sincronizado,
    };
  }

  // fromJson
  factory Pedido.fromJson(Map<String, dynamic> json) {
    final List<dynamic> produtosJson = json['itens'];
    final List<Produto> produtosList = produtosJson
        .map((produtoJson) => Produto.fromJson(produtoJson))
        .toList();
    final Itens itens = Itens(produtos: produtosList);

    return Pedido(
      id: json['id'] ?? "",
      itens: itens,
      dataPedido: DateTime.parse(json['dataPedido']),
      observacao: json['observacao'],
      formaPagamento: json['formaPagamento'],
    );
  }

  double getValorPedido() {
    return itens.calcularValorTotalComDesconto(
        0); // Sem desconto por padrão, pode ser ajustado conforme necessário
  }
}
