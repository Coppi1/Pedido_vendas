import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/models/pedido.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart'; // Supondo que este DTO existe
import 'package:projeto_pedido_vendas/repository/itens_pedido_dao.dart';

class PagamentoPage extends StatefulWidget {
  final PedidoDTO pedido;

  const PagamentoPage({Key? key, required this.pedido}) : super(key: key);

  @override
  _PagamentoPageState createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage> {
  late Future<List<ItensPedidoDTO>> _futureItens;
  final TextEditingController _descontoController = TextEditingController();
  double _valorTotal = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   int? pedidoId = widget.pedido.id;
  //   if (pedidoId != null) {
  //     _futureItens = ItensPedidoDAO().selectByPedido(pedidoId);
  //   } else {
  //     debugPrint("ID do pedido não pode ser nulo.");
  //     return;
  //   }
  //   _calcularValorTotal();
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchAndPrintItensPedidoData(widget.pedido.id);
    });
  }

  Future<void> fetchAndPrintItensPedidoData(int pedidoId) async {
    try {
      // Realiza a consulta para obter os dados de itens_pedido
      List<ItensPedidoDTO> itens =
          await ItensPedidoDAO().selectByPedido(pedidoId);

      // Imprime os dados obtidos
      debugPrint('Dados de itens_pedido: $itens');

      // Atualiza o estado com os dados obtidos
      setState(() {
        _futureItens = Future.value(
            itens); // Usa Future.value para converter a lista já obtida em um Future
      });

      // Calcula o valor total baseado nos itens obtidos
      _calcularValorTotal();
    } catch (e) {
      debugPrint('Erro ao buscar dados de itens_pedido: $e');
    }
  }

  void _calcularValorTotal() async {
    var itens = await _futureItens;
    setState(() {
      _valorTotal = itens.fold(0, (sum, item) => sum + (item.valorTotal ?? 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Pagamento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detalhes do Pedido',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Número do Pedido: ${widget.pedido.id}'),
            Text('Cliente: ${widget.pedido.cliente.nome}'),
            Text('Vendedor: ${widget.pedido.vendedor.nome}'),
            Text(
                'Forma de Pagamento: ${widget.pedido.formaPagamento.descricao}'),
            const SizedBox(height: 20),
            TextField(
              controller: _descontoController,
              decoration: const InputDecoration(
                labelText: 'Desconto (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                //  lógica para recalcular o valor total com o desconto
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<ItensPedidoDTO>>(
                future: _futureItens,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar os itens');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        ItensPedidoDTO item = snapshot.data![index];
                        return ListTile(
                          title: Text('${item.produto?.nome}'),
                          subtitle: Text(
                              'Quantidade: ${item.quantidade}, Valor Total: R\$ ${item.valorTotal?.toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  //  lógica para editar o produto
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // lógica para excluir o produto
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Text('Valor Total: R\$ ${_valorTotal.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // lógica para confirmar o pagamento
              },
              child: const Text('Confirmar Pagamento'),
            ),
          ],
        ),
      ),
    );
  }
}
