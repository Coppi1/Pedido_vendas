import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';

class PedidoProdutosPage extends StatelessWidget {
  final PedidoDTO pedido;

  const PedidoProdutosPage({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pedido #${pedido.id}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text('Cliente: ${pedido.cliente.nome}',
                style: const TextStyle(fontSize: 18)),
            Text('Vendedor: ${pedido.vendedor.nome}',
                style: const TextStyle(fontSize: 18)),
            Text('Forma de Pagamento: ${pedido.formaPagamento.descricao}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implementar a lógica para adicionar produtos ao pedido
              },
              child: const Text('Adicionar Produtos'),
            ),
            // Aqui você pode listar os itens do pedido, se houver
          ],
        ),
      ),
    );
  }
}
