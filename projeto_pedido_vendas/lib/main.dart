import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/models/pedido.dart';
import 'package:projeto_pedido_vendas/pages/pedido_emitir.dart';
import 'package:projeto_pedido_vendas/pages/pedido_emitir_teste.dart';
import 'package:projeto_pedido_vendas/pages/pedido_pagamento.dart';
import 'package:projeto_pedido_vendas/pages/pedido_teste.dart';
import 'package:projeto_pedido_vendas/util/initialize_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(MainApp());
}

final List<PedidoDTO> _pedidos = [
  // Seus objetos PedidoDTO aqui
];

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PedidoEmitirPageTeste2(),
    );
  }
}
