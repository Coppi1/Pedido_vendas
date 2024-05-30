import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_pedido_vendas/dtos/categoria_produto_dto.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/models/categoria_produto.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/pages/appBar.dart';
import 'package:projeto_pedido_vendas/pages/pedido_pagamento.dart';
import 'package:projeto_pedido_vendas/repository/categoria_produto_dao.dart';
import 'package:projeto_pedido_vendas/repository/itens_pedido_dao.dart';
import 'package:projeto_pedido_vendas/repository/produto_dao.dart';

class PedidoProdutosPage extends StatefulWidget {
  final PedidoDTO pedido;

  const PedidoProdutosPage({Key? key, required this.pedido}) : super(key: key);

  @override
  _PedidoProdutosPageState createState() => _PedidoProdutosPageState();
}

class _PedidoProdutosPageState extends State<PedidoProdutosPage>
    with RouteAware {
  final List<ItensPedidoDTO> _itensPedido = [];
  List<CategoriaProduto> _categorias = [];
  CategoriaProdutoDTO? _categoriaSelecionada;
  List<ProdutoDTO> _produtos = [];
  final List<ItensPedidoDTO> _itensSelecionados = [];
  int _quantidades = 1;
  final ItensPedidoDAO _itensPedidoDAO = ItensPedidoDAO();
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didPopNext() {
    // Método chamado quando a navegação retorna para essa página
    _resetState();
  }

  void _resetState() {
    setState(() {
      _itensPedido.clear();
      _itensSelecionados.clear();
      _quantidades = 1;
      _categoriaSelecionada = null;
      _produtos.clear();
    });
    _carregarCategorias();
  }

  void _carregarCategorias() async {
    CategoriaProdutoDAO categoriaProdutoDAO = CategoriaProdutoDAO();
    List<CategoriaProduto> categorias = await categoriaProdutoDAO.selectAll();
    setState(() {
      _categorias = categorias;
    });

    if (_categorias.isNotEmpty) {
      _carregarProdutosParaCategoria(_categorias[0].id ?? -1);
    }
  }

  void _carregarProdutosParaCategoria(int categoriaId) async {
    ProdutoDAO produtoDAO = ProdutoDAO();
    List<Produto> produtos = await produtoDAO.selectByCategoria(categoriaId);
    setState(() {
      _produtos =
          produtos.map((produto) => ProdutoDTO.fromProduto(produto)).toList();
    });
  }

  void _carregarProdutos() async {
    ProdutoDAO produtoDAO = ProdutoDAO();
    List<Produto> produtos = await produtoDAO.selectAll();
    setState(() {
      _produtos =
          produtos.map((produto) => ProdutoDTO.fromProduto(produto)).toList();
    });
  }

  void _adicionarProdutoAoCarrinho(ProdutoDTO produto, int quantidade) {
    if (produto.id == null) {
      debugPrint("Erro: Produto sem ID");
      return;
    }

    final ItensPedidoDTO item = ItensPedidoDTO(
      pedido: widget.pedido,
      produto: produto,
      quantidade: quantidade,
      valorTotal: (produto.valor ?? 0) * quantidade,
    );
    setState(() {
      _itensPedido.add(item);
      _itensSelecionados.add(item);
    });
  }

  void _alterarQuantidade(int index, int quantidade) {
    setState(() {
      _quantidades = quantidade;
      _itensSelecionados[index].quantidade = quantidade;
      _itensSelecionados[index].valorTotal =
          (_itensSelecionados[index].produto?.valor ?? 0) * quantidade;
    });
  }

  double _calcularTotal() {
    return _itensSelecionados.fold(
        0, (total, item) => total + (item.valorTotal ?? 0));
  }

  String _formatarValor(double valor) {
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatador.format(valor);
  }

  void _fecharPedido(BuildContext context) async {
    if (_itensSelecionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Por favor, adicione pelo menos um produto ao carrinho.'),
        ),
      );
      return;
    }

    debugPrint('_fecharPedido chamado');

    for (int i = 0; i < _itensSelecionados.length; i++) {
      try {
        await _itensPedidoDAO.insert(_itensSelecionados[i]);
      } catch (e) {
        debugPrint('Erro ao inserir item: $e');
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PagamentoPage(pedido: widget.pedido)),
    );
  }

  void _onSearchChanged() {
    String searchQuery = _searchController.text.toLowerCase();
    List<ProdutoDTO> filteredProdutos = _produtos.where((produto) {
      return produto.nome!.toLowerCase().contains(searchQuery);
    }).toList();

    setState(() {
      _produtos = filteredProdutos;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void removerIten(int index, int pedidoId, int produtoId) async {
    ItensPedidoDAO itensPedidoDAO = ItensPedidoDAO();
    await itensPedidoDAO.delete(pedidoId, produtoId);
    setState(() {
      _itensSelecionados.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MinhaAppBar(titulo: 'Carrinho de Produtos'),
      drawer: const MenuLateralEsquerdo(),
      endDrawer: MenuLateralDireito(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pedido #${widget.pedido.id}'),
              const SizedBox(height: 10),
              Text(
                'Cliente: ${widget.pedido.cliente.nome}',
              ),
              Text(
                'Vendedor: ${widget.pedido.vendedor.nome}',
              ),
              Text(
                'Forma de Pagamento: ${widget.pedido.formaPagamento.descricao}',
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<CategoriaProdutoDTO>(
                hint: const Text('Selecione uma categoria'),
                value: _categoriaSelecionada,
                onChanged: (CategoriaProdutoDTO? novaCategoria) {
                  setState(() {
                    _categoriaSelecionada = novaCategoria;
                    _produtos.clear();
                    if (novaCategoria != null) {
                      _carregarProdutosParaCategoria(novaCategoria.id ?? -1);
                    } else {
                      _carregarProdutos();
                    }
                  });
                },
                items: _categorias.map((categoria) {
                  final categoriaDTO = CategoriaProdutoDTO(
                    id: categoria.id,
                    descricao: categoria.descricao,
                  );
                  return DropdownMenuItem<CategoriaProdutoDTO>(
                    value: categoriaDTO,
                    child: Text(categoriaDTO.descricao ?? ''),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ProdutoDTO>(
                hint: const Text('Selecione um produto'),
                value: _produtos.isEmpty ? null : _produtos.first,
                onChanged: (ProdutoDTO? produto) {
                  if (produto != null) {
                    _adicionarProdutoAoCarrinho(produto, _quantidades);
                  }
                },
                items: _produtos.map((ProdutoDTO produto) {
                  return DropdownMenuItem<ProdutoDTO>(
                    value: produto,
                    child: Text(produto.nome ?? ''),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Produto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Adicionar ao Carrinho'),
                onPressed: () =>
                    _adicionarProdutoAoCarrinho(_produtos.first, _quantidades),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 143, 205, 255),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SizedBox(
                      height: 350,
                      child: ListView.builder(
                        itemCount: _itensSelecionados.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4.0,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ListTile(
                              title: Text(
                                _itensSelecionados[index].produto?.nome ?? '',
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quantidade: ${_itensSelecionados[index].quantidade}',
                                  ),
                                  Text(
                                    'Valor Total: ${_formatarValor(_itensSelecionados[index].valorTotal ?? 0)}',
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if ((_itensSelecionados[index]
                                                      .quantidade ??
                                                  0) >
                                              1) {
                                            _alterarQuantidade(
                                              index,
                                              (_itensSelecionados[index]
                                                          .quantidade ??
                                                      1) -
                                                  1,
                                            );
                                          } else {
                                            removerIten(
                                              index,
                                              widget.pedido.id ?? 0,
                                              _itensSelecionados[index]
                                                      .produto
                                                      ?.id ??
                                                  0,
                                            );
                                          }
                                        },
                                      ),
                                      Text(
                                          '${_itensSelecionados[index].quantidade}'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          _alterarQuantidade(
                                            index,
                                            (_itensSelecionados[index]
                                                        .quantidade ??
                                                    0) +
                                                1,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Text(
                    'Valor Total do Pedido: ${_formatarValor(_calcularTotal())}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.attach_money),
                    label: const Text('Finalizar Pedido'),
                    onPressed: () => _fecharPedido(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
