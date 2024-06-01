import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/repository/itens_pedido_dao.dart';

class PagamentoPage extends StatefulWidget {
  final PedidoDTO pedido;
  final List<ItensPedidoDTO> itens;

  const PagamentoPage({Key? key, required this.pedido, required this.itens})
      : super(key: key);

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
  double _valorTotalComDesconto = 0;
  late List<ItensPedidoDTO> _itens = []; // Declaração da variável _itens
  final List<Map<String, dynamic>> _parcelas = [];

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
      _itens = itens; // Atribuição dos itens ao _itens
      _calcularValorTotal(itens);
      return itens;
    } catch (e) {
      debugPrint('Erro ao buscar dados de itens_pedido: $e');
      return [];
    }
  }

  void _calcularValorTotal(List<ItensPedidoDTO> itens) {
    setState(() {
      // Calcular o valor total sem desconto
      _valorTotal = itens.fold(
        0.0,
        (sum, item) => sum + (item.valorTotal ?? 0),
      );
      // Calcular o valor total com desconto
      _valorTotalComDesconto = _valorTotal * (1 - _desconto / 100);
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

  void _editarProduto(ItensPedidoDTO itemPedido) async {
    final int? quantidadeAtual = itemPedido.quantidade;
    final TextEditingController quantidadeController =
        TextEditingController(text: quantidadeAtual?.toString() ?? '');

    final int? quantidadeEditada = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Quantidade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(quantidadeAtual);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final int? novaQuantidade =
                    int.tryParse(quantidadeController.text);
                if (novaQuantidade != null && novaQuantidade > 0) {
                  Navigator.of(context).pop(novaQuantidade);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quantidade inválida')),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (quantidadeEditada != null) {
      setState(() {
        itemPedido.quantidade = quantidadeEditada;
        if (itemPedido.produto != null && itemPedido.produto!.valor != null) {
          itemPedido.valorTotal =
              itemPedido.produto!.valor! * quantidadeEditada;
        }

        _calcularValorTotal(_itens);
      });

      await ItensPedidoDAO()
          .updateQuantidade(itemPedido.id!, quantidadeEditada);
    }
  }

  void _excluirProduto(ProdutoDTO produto) async {
    final bool? confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Produto'),
          content:
              const Text('Você tem certeza que deseja excluir este produto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmacao == true) {
      // Remover o produto da lista de itens
      setState(() {
        _itens.removeWhere((item) => item.produto?.id == produto.id);
        _calcularValorTotal(_itens);
      });

      // Remover o produto do banco de dados
      await ItensPedidoDAO().deleteProduto(produto.id!);
    }
  }

  String _formatarValor(double valor) {
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatador.format(valor);
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _vencimentoController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _recalcularValorTotalComDesconto(String desconto) {
    setState(() {
      _desconto = double.tryParse(desconto) ?? 0;
      _valorTotalComDesconto = _valorTotal * (1 - _desconto / 100);
    });
  }

  void _gerarParcelas(String parcelas, String vencimento) {
    setState(() {
      _parcelas.clear();
      int numParcelas = int.tryParse(parcelas) ?? 0;
      double valorParcela = _valorTotalComDesconto / numParcelas;

      for (int i = 0; i < numParcelas; i++) {
        Map<String, dynamic> parcelaInfo = {
          'numero': i + 1,
          'vencimento': DateFormat('yyyy-MM-dd').format(
            DateFormat('yyyy-MM-dd')
                .parse(vencimento)
                .add(Duration(days: 30 * (i + 1))),
          ),
          'valor': valorParcela,
        };
        _parcelas.add(parcelaInfo);

        // Chama o método para inserir a parcela no banco de dados
        _inserirParcelaNoBanco(i + 1, valorParcela, _desconto,
                parcelaInfo['vencimento'], widget.pedido.id!)
            .then((_) {
          // Você pode querer atualizar a UI ou mostrar uma mensagem de sucesso aqui
        }).catchError((error) {
          // Trate possíveis erros aqui
          print('Erro ao inserir parcela: $error');
        });
      }
    });
  }

  Future<void> _inserirParcelaNoBanco(int parcela, double valorTotal,
      double desconto, String dataVencimento, int pedidoId) async {
    try {
      // await ParcelaPedidoDAO().insert(ParcelaPedidoDTO(
      //   parcela: parcela,
      //   valorTotal: valorTotal,
      //   desconto: desconto,
      //   dataVencimento: dataVencimento,
      //   pedidoId: pedidoId,
      // ));
      print(
          'Parcela $parcela inserida no banco de dados com valor $valorTotal e vencimento $dataVencimento');
    } catch (e) {
      print('Erro ao inserir parcela no banco de dados: $e');
    }
  }

  void _confirmarPagamento() async {
    try {
      // await PagamentoDAO().insert(PagamentoDTO(
      //   parcela: _parcelasController.text,
      //   valorTotal: _valorTotal,
      //   desconto: _desconto,
      //   dataVencimento: _vencimentoController.text,
      //   pedido: widget.pedido,
      // ));
      print('Pagamento confirmado com sucesso!');
      // Você pode adicionar mais lógica aqui, como navegar para outra tela
    } catch (e) {
      print('Erro ao confirmar o pagamento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Pagamento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
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
              const Text(
                'Detalhes do Pedido',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text('Número do Pedido: ${widget.pedido.id}'),
              Text('Cliente: ${widget.pedido.cliente.nome}'),
              Text('Vendedor: ${widget.pedido.vendedor.nome}'),
              Text(
                  'Forma de Pagamento: ${widget.pedido.formaPagamento.descricao}'),
              const SizedBox(height: 20),
              const Text(
                'Carrinho de Produtos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                constraints: const BoxConstraints(minHeight: 200),
                child: FutureBuilder<List<ItensPedidoDTO>>(
                  future: _futureItens,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Nenhum item encontrado.'));
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final item = snapshot.data![index];
                                return ListTile(
                                  title: Text(item.produto?.nome ??
                                      'Produto desconhecido'),
                                  subtitle: Text(
                                    'Quantidade: ${item.quantidade ?? 0}, Valor Total: R\$ ${_formatarValor(item.valorTotal ?? 0)}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          _editarProduto(item);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _excluirProduto(item.produto!);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _descontoController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Desconto (%)'),
                                onChanged: _recalcularValorTotalComDesconto,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Valor Total: R\$ ${_formatarValor(_valorTotal)}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Valor Total com Desconto: R\$ ${_formatarValor(_valorTotalComDesconto)}',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _parcelasController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Número de Parcelas'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _vencimentoController,
                                decoration: const InputDecoration(
                                    labelText: 'Data de Vencimento'),
                                readOnly: true,
                                onTap: () => _selectDate(context),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _gerarParcelas(_parcelasController.text,
                                    _vencimentoController.text);
                              },
                              child: const Text('Gerar Parcelas'),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _parcelas.length,
                              itemBuilder: (context, index) {
                                final parcela = _parcelas[index];
                                return ListTile(
                                  title: Text(
                                      'Parcela ${parcela['numero']} - Vencimento: ${parcela['vencimento']}'),
                                  subtitle: Text(
                                      'Valor: R\$ ${_formatarValor(parcela['valor'])}'),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _confirmarPagamento();
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
