import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pagamento_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pagamento_parcela_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/repository/itens_pedido_dao.dart';
import 'package:projeto_pedido_vendas/repository/pagamento_dao.dart';
import 'package:projeto_pedido_vendas/repository/pagamento_parcela_dao.dart';

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

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return picked;
  }

  void _recalcularValorTotalComDesconto(String desconto) {
    setState(() {
      _desconto = double.tryParse(desconto) ?? 0;
      _valorTotalComDesconto = _valorTotal * (1 - _desconto / 100);
    });
  }

  void _previewParcelas() {
    setState(() {
      _parcelas.clear();
      int numParcelas = int.tryParse(_parcelasController.text) ?? 0;
      double valorParcela = _valorTotalComDesconto / numParcelas;

      for (int i = 0; i < numParcelas; i++) {
        Map<String, dynamic> parcelaInfo = {
          'numero': i + 1,
          'vencimento': DateFormat('yyyy-MM-dd').format(
            DateFormat('yyyy-MM-dd')
                .parse(_vencimentoController.text)
                .add(Duration(days: 30 * i)),
          ),
          'valor': valorParcela,
        };
        _parcelas.add(parcelaInfo);
      }
    });
  }

  Future<void> _inserirParcelaNoBanco(int parcela, double valor,
      double desconto, String dataVencimento, int pagamentoId) async {
    try {
      // Buscar o pagamento correspondente ao pagamentoId
      PagamentoDTO? pagamentoDTO = await _buscarPagamentoPorId(pagamentoId);

      // Verificar se o pagamento é válido antes de continuar
      if (pagamentoDTO != null) {
        await PagamentoParcelaDAO().insert(PagamentoParcelaDTO(
          parcela: parcela,
          valor: valor,
          desconto: desconto,
          dataVencimento: dataVencimento,
          pagamento: pagamentoDTO,
        ));
        print(
            'Parcela $parcela inserida no banco de dados com valor $valor e vencimento $dataVencimento');
      } else {
        print('Pagamento não encontrado para o ID fornecido: $pagamentoId');
      }
    } catch (e) {
      print('Erro ao inserir parcela no banco de dados: $e');
    }
  }

  // Função para buscar pagamento pelo ID
  Future<PagamentoDTO?> _buscarPagamentoPorId(int pagamentoId) async {
    PagamentoDTO? pagamento =
        await PagamentoDAO().buscarPagamentoPorId(pagamentoId);
    return pagamento;
  }

  void _confirmarPagamento() async {
    try {
      // Primeiro, insere o pagamento
      PagamentoDTO pagamento = PagamentoDTO(
        parcelas: int.parse(_parcelasController.text),
        valorTotal: _valorTotal,
        desconto: _desconto,
        dataVencimento: _vencimentoController.text,
        pedido: widget.pedido,
      );

      await PagamentoDAO().insert(pagamento);

      print('Pagamento confirmado com sucesso!');

      // Agora, insere as parcelas no banco de dados
      int? pagamentoId = pagamento.id; // Evita null safety issue
      if (pagamentoId != null) {
        for (var parcela in _parcelas) {
          await _inserirParcelaNoBanco(
            parcela['numero'],
            parcela['valor'],
            _desconto,
            parcela['vencimento'],
            pagamentoId,
          );
        }
      } else {
        print('ID do pagamento é nulo');
      }
    } catch (e) {
      print('Erro ao confirmar pagamento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<ItensPedidoDTO>>(
            future: _futureItens,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Text('Erro ao carregar itens do pedido');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Nenhum item no pedido');
              } else {
                final itens = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Produtos',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itens.length,
                      itemBuilder: (context, index) {
                        final item = itens[index];
                        return ListTile(
                          title: Text(item.produto?.nome ?? 'Produto'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantidade: ${item.quantidade}'),
                              Text(
                                  'Valor Total: ${_formatarValor(item.valorTotal ?? 0)}'),
                            ],
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
                                  if (item.produto != null) {
                                    _excluirProduto(item.produto!);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      'Resumo do Pedido',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Valor Total: ${_formatarValor(_valorTotal)}'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descontoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Desconto (%)',
                      ),
                      onChanged: (value) {
                        _recalcularValorTotalComDesconto(value);
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                        'Valor Total com Desconto: ${_formatarValor(_valorTotalComDesconto)}'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _parcelasController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Número de Parcelas',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _vencimentoController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Data de Vencimento',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? selectedDate = await _selectDate(context);
                        if (selectedDate != null) {
                          _vencimentoController.text =
                              DateFormat('yyyy-MM-dd').format(selectedDate);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _previewParcelas,
                      child: const Text('Gerar Prévia de Parcelas'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Parcelas',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _parcelas.length,
                      itemBuilder: (context, index) {
                        final parcela = _parcelas[index];
                        return ListTile(
                          title: Text(
                              'Parcela ${parcela['numero']}: ${_formatarValor(parcela['valor'])}'),
                          subtitle:
                              Text('Vencimento: ${parcela['vencimento']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _selectDate(context).then((value) {
                                if (value != null) {
                                  setState(() {
                                    parcela['vencimento'] =
                                        DateFormat('yyyy-MM-dd').format(value);
                                  });
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _confirmarPagamento,
                        child: const Text('Confirmar Pagamento'),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
