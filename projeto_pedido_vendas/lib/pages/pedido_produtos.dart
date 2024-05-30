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
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  int _quantidadeSelecionada = 1;
  final ItensPedidoDAO _itensPedidoDAO = ItensPedidoDAO();
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<int, int> _quantidadesSelecionadas = {};

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
      _quantidadeSelecionada = 1;
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
      _quantidadesSelecionadas[produto.id!] =
          quantidade; // Atualize a quantidade selecionada para o produto
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
        builder: (context) =>
            PagamentoPage(pedido: widget.pedido, itens: _itensSelecionados),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinhaAppBar(titulo: 'Carrinho de Produtos'),
      drawer: const MenuLateralEsquerdo(),
      endDrawer: MenuLateralDireito(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pedido #${widget.pedido.id}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
              ),
              const SizedBox(height: 10),
              _buildInfoRow('Cliente:', widget.pedido.cliente.nome ?? 'N/A',
                  FontAwesomeIcons.user),
              _buildInfoRow('Vendedor:', widget.pedido.vendedor.nome ?? 'N/A',
                  FontAwesomeIcons.userTie),
              _buildInfoRow(
                  'Forma de Pagamento:',
                  widget.pedido.formaPagamento.descricao ?? 'N/A',
                  FontAwesomeIcons.moneyBill),
              const Divider(),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdownField<CategoriaProdutoDTO>(
                        hint: 'Selecione uma categoria',
                        value: _categoriaSelecionada,
                        onChanged: (CategoriaProdutoDTO? novaCategoria) {
                          setState(() {
                            _categoriaSelecionada = novaCategoria;
                            _produtos.clear();
                            if (novaCategoria != null) {
                              _carregarProdutosParaCategoria(
                                  novaCategoria.id ?? -1);
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
                            child: Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.boxes),
                                const SizedBox(width: 10),
                                Text(categoriaDTO.descricao ?? ''),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          labelText: 'Buscar produto',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProductGrid(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text(
                'Itens do Carrinho',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              _buildCartItems(),
              const Divider(),
              _buildTotalRow(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                    onPressed: () => _fecharPedido(context),
                    icon: const Icon(Icons.check),
                    label: const Text('Fechar Pedido'),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 16,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String hint,
    required T? value,
    required Function(T?) onChanged,
    required List<DropdownMenuItem<T>> items,
  }) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      value: value,
      onChanged: onChanged,
      items: items,
    );
  }

  Widget _buildProductGrid() {
    if (_categoriaSelecionada == null) {
      return const SizedBox();
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 4,
      ),
      itemCount: _produtos.length,
      itemBuilder: (context, index) {
        final produto = _produtos[index];
        // Verificar se o produto corresponde ao termo de busca
        if (_searchController.text.isNotEmpty &&
            !produto.nome!
                .toLowerCase()
                .contains(_searchController.text.toLowerCase())) {
          return const SizedBox();
        }
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produto.nome ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('R\$ ${produto.valor?.toStringAsFixed(2) ?? '0.00'}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.minus),
                          onPressed: () {
                            final id = produto.id;
                            if (id != null &&
                                _quantidadesSelecionadas.containsKey(id) &&
                                _quantidadesSelecionadas[id]! > 1) {
                              setState(() {
                                _quantidadesSelecionadas[id] =
                                    _quantidadesSelecionadas[id]! - 1;
                              });
                            }
                          },
                        ),
                        Text(
                          _quantidadesSelecionadas[produto.id!]?.toString() ??
                              '0', // Corrigindo para verificar se a chave existe antes de acessar
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.plus),
                          onPressed: () {
                            final id = produto.id;
                            if (id != null) {
                              setState(() {
                                _quantidadesSelecionadas[id] =
                                    (_quantidadesSelecionadas[id] ?? 0) + 1;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _adicionarProdutoAoCarrinho(
                              produto, _quantidadeSelecionada);
                          _resetQuantity();
                        },
                        child: const Text('Adicionar ao Carrinho'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _resetQuantity() {
    setState(() {
      _quantidadeSelecionada = 1;
    });
  }

  Widget _buildCartItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _itensPedido.length,
      itemBuilder: (context, index) {
        final item = _itensPedido[index];
        return ListTile(
          title: Text(item.produto?.nome ?? 'N/A'),
          subtitle: Text('Quantidade: ${item.quantidade}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_formatarValor(item.valorTotal ?? 0)),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _removerItemDoCarrinho(index);
                },
              ),
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Remover Item do Carrinho'),
                  content: const Text('Deseja remover este item do carrinho?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        _removerItemDoCarrinho(index);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Remover'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _removerItemDoCarrinho(int index) {
    setState(() {
      _itensPedido.removeAt(index);
    });
  }

  Widget _buildTotalRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            _formatarValor(_calcularTotal()),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }
}
