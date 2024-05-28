import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/pages/appBar.dart';

class PagamentoPage extends StatefulWidget {
  final PedidoDTO pedido;

  const PagamentoPage({Key? key, required this.pedido}) : super(key: key);

  @override
  _PagamentoPageState createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MinhaAppBar(),
        drawer: const MenuLateralEsquerdo(),
        endDrawer: MenuLateralDireito(),
        body: const SingleChildScrollView());
  }
}
