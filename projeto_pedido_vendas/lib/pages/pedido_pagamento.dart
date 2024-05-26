import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
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

  @override
  void initState() {
    super.initState();
    _futureItens = _fetchItensPedidoData();

    // Aguarda o futuro ser resolvido e então imprime os detalhes dos itens
    _futureItens.then((itens) {
      itens.forEach((item) {
        // Verifica se produto é null antes de acessar sua propriedade nome
        if (item.produto != null) {
          debugPrint('Nome do Produto: ${item.produto!.nome}');
        } else {
          debugPrint('Produto é null');
        }
      });
    }).catchError((error) {
      debugPrint('Erro ao processar itens: $error');
    });

    debugPrint('Iniciando busca de itens...');
  }

  Future<List<ItensPedidoDTO>> _fetchItensPedidoData() async {
    try {
      if (widget.pedido.id == null) {
        throw Exception('Id do pedido é nulo');
      }

      List<ItensPedidoDTO> itens =
          await ItensPedidoDAO().selectByPedido(widget.pedido.id!);
      _calcularValorTotal(itens);

      // debugPrint('Itens buscados: $itens');

      return itens;
    } catch (e) {
      debugPrint('Erro ao buscar dados de itens_pedido: $e');
      return [];
    }
  }

  void _calcularValorTotal(List<ItensPedidoDTO> itens) {
    setState(() {
      _valorTotal =
          itens.fold(0.0, (sum, item) => sum + (item.valorTotal ?? 0));
    });
  }

  void _clearItens() {
    setState(() {
      _futureItens =
          Future.value([]); // Reinicializa o Future com uma lista vazia
      _valorTotal = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Pagamento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _clearItens();
            Navigator.pop(context);
          },
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
                // lógica para recalcular o valor total com o desconto
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
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhum item encontrado.');
                  } else {
                    final itens = snapshot.data!;
                    return ListView.builder(
                      itemCount: itens.length,
                      itemBuilder: (context, index) {
                        final item = itens[index];
                        return ListTile(
                          title: Text(
                              item.produto?.nome ?? 'Produto desconhecido'),
                          subtitle: Text(
                              'Quantidade: ${item.quantidade ?? 0}, Valor Total: R\$ ${item.valorTotal?.toStringAsFixed(2) ?? '0.00'}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // lógica para editar o produto
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
