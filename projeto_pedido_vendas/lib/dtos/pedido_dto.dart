import 'dart:convert';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';
import 'package:projeto_pedido_vendas/models/pagamento.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';

class PedidoDTO {
  int? id;
  DateTime dataPedido;
  String observacao;
  String formaPagamento;
  bool? sincronizado;
  Itens itens;
  double valorTotal;
  Cliente cliente;
  Vendedor vendedor;
  Pagamento pagamento; // Adicione o campo pagamento

  PedidoDTO({
    this.id,
    required this.dataPedido,
    required this.observacao,
    required this.formaPagamento,
    required this.itens,
    this.valorTotal = 0,
    required this.cliente,
    required this.vendedor,
    required this.pagamento, // Inicialize o campo pagamento
  });

  factory PedidoDTO.fromJson(Map<String, dynamic> json) {
    final List<dynamic> produtosJson = json['produtos'];
    final List<Produto> produtosList = produtosJson
        .map((produtoJson) => Produto.fromJson(produtoJson))
        .toList();
    final Itens itens = Itens(produtos: produtosList);

    return PedidoDTO(
      id: json['id'] ?? '',
      dataPedido: DateTime.parse(json['dataPedido']),
      observacao: json['observacao'] ?? '',
      formaPagamento: json['formaPagamento'] ?? '',
      itens: itens,
      cliente: Cliente.fromJson(json['cliente']),
      vendedor: Vendedor.fromJson(json['vendedor']),
      pagamento: Pagamento.fromJson(
          json['pagamento']), // Convertendo o pagamento do JSON
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataPedido': dataPedido.toIso8601String(),
      'observacao': observacao,
      'formaPagamento': formaPagamento,
      'sincronizado': sincronizado,
      'produtos': itens.produtos.map((produto) => produto.toJson()).toList(),
      'cliente': cliente.toJson(),
      'vendedor': vendedor.toJson(),
      'pagamento': pagamento.toJson(), // Convertendo o pagamento para JSON
    };
  }

  @override
  String toString() {
    return 'PedidoDTO(id: $id, dataPedido: $dataPedido, observacao: $observacao, formaPagamento: $formaPagamento, sincronizado: $sincronizado, itens: $itens)';
  }
}
