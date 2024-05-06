import 'dart:convert';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';
import 'package:projeto_pedido_vendas/models/pagamento.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';

class PedidoDTO {
  int id;
  DateTime dataPedido;
  String observacao;
  String formaPagamento;
  List<ItensDTO> itens;
  double valorTotal;
  Cliente cliente;
  Vendedor vendedor;
  Pagamento pagamento;

  PedidoDTO({
    required this.id,
    required this.dataPedido,
    required this.observacao,
    required this.formaPagamento,
    required this.itens,
    required this.valorTotal,
    required this.cliente,
    required this.vendedor,
    required this.pagamento,
  });

  factory PedidoDTO.fromJson(Map<String, dynamic> json) {
    final List<dynamic> produtosJson = json['produtos'];
    final List<ProdutoDTO> produtosList = produtosJson
        .map((produtoJson) => ProdutoDTO.fromJson(produtoJson))
        .toList();
    final ItensDTO itens = ItensDTO.fromProdutos(produtosList);

    return PedidoDTO(
      id: json['id'] ?? '',
      dataPedido: DateTime.parse(json['dataPedido']),
      observacao: json['observacao'] ?? '',
      formaPagamento: json['formaPagamento'] ?? '',
      itens: itens,
      cliente: Cliente.fromJson(json['cliente']),
      vendedor: Vendedor.fromJson(json['vendedor']),
      pagamento: Pagamento.fromJson(json['pagamento']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataPedido': dataPedido.toIso8601String(),
      'observacao': observacao,
      'formaPagamento': formaPagamento,
      'produtos': itens.produtos.map((produto) => produto.toJson()).toList(),
      'cliente': cliente.toJson(),
      'vendedor': vendedor.toJson(),
      'pagamento': pagamento.toJson(),
    };
  }

  @override
  String toString() {
    return 'PedidoDTO(id: $id, dataPedido: $dataPedido, observacao: $observacao, formaPagamento: $formaPagamento, itens: $itens)';
  }
}
