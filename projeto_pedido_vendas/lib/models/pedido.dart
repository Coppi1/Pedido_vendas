import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/forma_pagamento.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';

class Pedido {
  int? id;
  DateTime dataPedido;
  String observacao;
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
}
