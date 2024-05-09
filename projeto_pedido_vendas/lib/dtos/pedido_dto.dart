import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/dtos/forma_pagamento_dto.dart';
import 'package:projeto_pedido_vendas/dtos/vendedor_dto.dart';
import 'package:projeto_pedido_vendas/models/forma_pagamento.dart';

class PedidoDTO {
  int? id;
  DateTime
      dataPedido; // Mudança de DateTime para String para fins de serialização
  String observacao;
  FormaPagamentoDTO formaPagamento;
  ClienteDTO cliente;
  VendedorDTO vendedor;

  PedidoDTO({
    this.id,
    required this.dataPedido,
    required this.observacao,
    required this.formaPagamento,
    required this.cliente,
    required this.vendedor,
  });

  factory PedidoDTO.fromJson(Map<String, dynamic> json) {
    return PedidoDTO(
      id: json['id'],
      dataPedido: json['dataPedido'],
      observacao: json['observacao'],
      formaPagamento: FormaPagamentoDTO.fromJson(json['formaPagamento']),
      cliente: ClienteDTO.fromJson(json['cliente']),
      vendedor: VendedorDTO.fromJson(json['vendedor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataPedido': dataPedido,
      'observacao': observacao,
      'formaPagamento': formaPagamento.toJson(),
      'cliente': cliente.toJson(),
      'vendedor': vendedor.toJson(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataPedido': dataPedido.millisecondsSinceEpoch,
      'observacao': observacao,
      'formaPagamentoId': formaPagamento.id,
      'clienteId': cliente.id,
      'vendedorId': vendedor.id,
    };
  }
}
