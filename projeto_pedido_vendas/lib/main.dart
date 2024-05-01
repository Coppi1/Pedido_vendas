import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/pages/pedido_emitir.dart';
import 'package:projeto_pedido_vendas/pages/pedido_teste.dart';
import 'package:projeto_pedido_vendas/util/initialize_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PedidoEmitirPageTeste(),
    );
  }
}
