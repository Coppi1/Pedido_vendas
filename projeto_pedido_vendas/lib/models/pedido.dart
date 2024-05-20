import 'dart:convert';
import 'package:projeto_pedido_vendas/dtos/forma_pagamento_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/forma_pagamento.dart';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';
import 'package:projeto_pedido_vendas/models/pagamento.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';

class Pedido {
  int? id;
  DateTime? dataPedido;
  String? observacao;
  FormaPagamento formaPagamento;
  Cliente cliente;
  Vendedor vendedor;

  Pedido({
    required this.id,
    required this.dataPedido,
    required this.observacao,
    required this.formaPagamento,
    required this.cliente,
    required this.vendedor,
  });

  factory Pedido.fromPedidoDTO(PedidoDTO dto) {
    if (dto.formaPagamento == null ||
        dto.cliente == null ||
        dto.vendedor == null) {
      throw ArgumentError(
          'Os campos formaPagamento, cliente e vendedor não podem ser nulos');
    }

    return Pedido(
      id: dto.id,
      dataPedido: dto.dataPedido,
      observacao: dto.observacao,
      formaPagamento: FormaPagamento.fromFormaPagamentoDTO(dto.formaPagamento),
      cliente: Cliente.fromClienteDTO(dto.cliente),
      vendedor: Vendedor.fromVendedorDTO(dto.vendedor),
    );
  }

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      dataPedido: DateTime.parse(json['dataPedido']),
      observacao: json['observacao'],
      formaPagamento: FormaPagamento.fromJson(json['formaPagamento']),
      cliente: Cliente.fromJson(json['cliente']),
      vendedor: Vendedor.fromJson(json['vendedor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataPedido': dataPedido?.toIso8601String(),
      'observacao': observacao,
      'formaPagamento': formaPagamento.toMap(),
      'cliente': cliente.toMap(),
      'vendedor': vendedor.toJson(),
    };
  }
}
