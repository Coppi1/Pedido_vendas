import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/models/pedido.dart';
import 'package:projeto_pedido_vendas/pages/pedido_cadastro.dart';
import 'package:projeto_pedido_vendas/pages/pedido_pagamento.dart';
import 'package:projeto_pedido_vendas/util/initialize_database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDatabase();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PedidoCadastro(),
    );
  }
}
