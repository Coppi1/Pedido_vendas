import 'dart:convert';
import 'dart:html';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';
import 'package:projeto_pedido_vendas/models/pagamento.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';

class Pedido {
  String id;
  Itens itens;
  DateTime dataPedido;
  String observacao;
  String formaPagamento;
  bool? sincronizado;
  double valorTotal;
  Cliente cliente;
  Vendedor vendedor;
  Pagamento pagamento;

  Pedido({
    required this.id,
    required this.itens,
    required this.dataPedido,
    required this.observacao,
    required this.formaPagamento,
    this.sincronizado,
    this.valorTotal = 0,
    required this.cliente,
    required this.vendedor,
    required this.pagamento,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itens': itens.produtos.map((produto) => produto.toJson()).toList(),
      'dataPedido': dataPedido.toIso8601String(),
      'observacao': observacao,
      'formaPagamento': formaPagamento,
      'sincronizado': sincronizado,
      'valorTotal': valorTotal,
      'cliente': cliente.toJson(), // Incluindo o cliente no JSON
      'vendedor': vendedor.toJson(), // Incluindo o vendedor no JSON
      'pagamento': pagamento.toJson(),
    };
  }

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
      cliente:
          Cliente.fromJson(json['cliente']), // Convertendo o cliente do JSON
      vendedor:
          Vendedor.fromJson(json['vendedor']), // Convertendo o vendedor do JSON
      pagamento: Pagamento.fromJson(json['pagamento']),
    );
  }

  double getValorPedido() {
    return itens.calcularValorTotalComDesconto(0);
  }
}
