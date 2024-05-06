import 'dart:convert';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';
import 'package:projeto_pedido_vendas/models/pagamento.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';

class Pedido {
  int? id;
  DateTime dataPedido;
  String observacao;
  String formaPagamento;
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
