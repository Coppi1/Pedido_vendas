import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/forma_pagamento.dart';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';

class ItensPedidoDTO {
  int? id;
  PedidoDTO pedido;
  ProdutoDTO produto;
  int? quantidade;
  double? valorTotal;

  ItensPedidoDTO({
    this.id,
    required this.pedido,
    required this.produto,
    this.quantidade,
    this.valorTotal,
  });

  factory ItensPedidoDTO.fromJson(Map<String, dynamic> json) {
    return ItensPedidoDTO(
      id: json['id'],
      pedido: PedidoDTO.fromJson(json['pedido']),
      produto: ProdutoDTO.fromJson(json['produto']),
      quantidade: json['quantidade'],
      valorTotal: json['valorTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedidoId': pedido?.toJson(),
      'produto': produto?.toJson(),
      'quantidade': quantidade,
      'valorTotal': valorTotal,
    };
  }
}
