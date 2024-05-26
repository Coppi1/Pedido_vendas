import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/repository/itens_pedido_dao.dart';
import 'package:intl/intl.dart';

class PagamentoPage extends StatefulWidget {
  final PedidoDTO pedido;

  const PagamentoPage({Key? key, required this.pedido}) : super(key: key);

  @override
  _PagamentoPageState createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage> {
  late Future<List<ItensPedidoDTO>> _futureItens;
  final TextEditingController _descontoController = TextEditingController();
  final TextEditingController _parcelasController = TextEditingController();
  final TextEditingController _vencimentoController = TextEditingController();
  double _valorTotal = 0;
  double _desconto = 0;
  List<Map<String, dynamic>> _parcelas = [];

  @override
  void initState() {
    super.initState();
    _futureItens = _fetchItensPedidoData();
    _vencimentoController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());

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
      _valorTotal = itens.fold(
        0.0,
        (sum, item) => sum + ((item.valorTotal ?? 0) * (1 - _desconto / 100)),
      );
    });
  }

  void _clearItens() {
    setState(() {
      _futureItens =
          Future.value([]); // Reinicializa o Future com uma lista vazia
      _valorTotal = 0;
    });
  }

  void _removerItensDoBanco() async {
    try {
      if (widget.pedido.id != null) {
        await ItensPedidoDAO().deleteByPedido(widget.pedido.id!);
      }
    } catch (e) {
      debugPrint('Erro ao remover itens do banco: $e');
    }
  }

  void _editarProduto(ProdutoDTO produto) {
    // lógica para editar o produto
  }

  void _excluirProduto(ProdutoDTO produto) {
    // lógica para excluir o produto
  }

  void _recalcularValorTotalComDesconto(String desconto) {
    setState(() {
      _desconto = double.tryParse(desconto) ?? 0;
      _calcularValorTotal(_futureItens as List<ItensPedidoDTO>);
    });
  }

  void _gerarParcelas(String parcelas, String vencimento) {
    setState(() {
      _parcelas.clear();
      int numParcelas = int.tryParse(parcelas) ?? 0;
      double valorParcela = _valorTotal / numParcelas;

      for (int i = 0; i < numParcelas; i++) {
        _parcelas.add({
          'numero': i + 1,
          'vencimento': DateFormat('yyyy-MM-dd').format(
            DateFormat('yyyy-MM-dd')
                .parse(vencimento)
                .add(Duration(days: 30 * (i + 1))),
          ),
          'valor': valorParcela,
        });
      }
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
            _removerItensDoBanco();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              const Text('Carrinho de Produtos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                constraints: BoxConstraints(maxHeight: 200),
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
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: itens.length,
                        itemBuilder: (context, index) {
                          final item = itens[index];
                          return ListTile(
                            title: Text(
                                item.produto?.nome ?? 'Produto desconhecido'),
                            subtitle: Text(
                              'Quantidade: ${item.quantidade ?? 0}, Valor Total: R\$ ${item.valorTotal?.toStringAsFixed(2) ?? '0.00'}',
                            ),
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
              TextField(
                controller: _descontoController,
                decoration: const InputDecoration(
                  labelText: 'Desconto (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (desconto) {
                  _recalcularValorTotalComDesconto(desconto);
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _parcelasController,
                      decoration: const InputDecoration(
                        labelText: 'Número de Parcelas',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _vencimentoController,
                      decoration: const InputDecoration(
                        labelText: 'Data de Vencimento',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      _gerarParcelas(
                        _parcelasController.text,
                        _vencimentoController.text,
                      );
                    },
                    child: const Text('Aplicar'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Valor Total (Sem Desconto): R\$ ${(_valorTotal / (1 - _desconto / 100)).toStringAsFixed(2)}',
              ),
              Text(
                'Valor Total (Com Desconto): R\$ ${_valorTotal.toStringAsFixed(2)}',
              ),
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
      ),
    );
  }
}
