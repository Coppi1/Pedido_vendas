import 'package:flutter/material.dart';
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
  final List<CategoriaProduto> _categorias = [];
  CategoriaProdutoDTO? _categoriaSelecionada;
  final List<ProdutoDTO> _produtos = [];
  final List<ItensPedidoDTO> _itensSelecionados = [];
  final int _quantidades = 1;
  final ItensPedidoDAO _itensPedidoDAO = ItensPedidoDAO();
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

    _carregarCategorias();
    _searchController.addListener(onSearchChanged);
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
          (_itensSelecionados[index].produto.valor ?? 0) * quantidade;
    });
  }

  double _calcularTotal() {
    return _itensSelecionados.fold(
        0, (total, item) => total + (item.valorTotal ?? 0));
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
      // debugPrint('Produto: ${_itensSelecionados[i].produto?.nome}');
      // debugPrint('Quantidade: ${_itensSelecionados[i].quantidade}');
      // debugPrint('Valor Total: ${_itensSelecionados[i].valorTotal}');
      // debugPrint('Valor Total: ${_itensSelecionados[i].pedido?.id}');

      try {
        // Tenta inserir o item no banco de dados
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
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: _itensSelecionados.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                                _itensSelecionados[index].produto?.nome ??
                                    'Nome do Produto'),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Adicionado para espaço entre os widgets
                              children: [
                                Row(
                                  children: [
                                    const Text('Quantidade: '),
                                    SizedBox(
                                      width: 50,
                                      child: TextFormField(
                                        initialValue: _quantidades.toString(),
                                        onChanged: (value) {
                                          _alterarQuantidade(
                                              index, int.tryParse(value) ?? 1);
                                        },
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                    'Total: R\$ ${_itensSelecionados[index].valorTotal!.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              ),
              const SizedBox(height: 30),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      Text('Total: R\$ ${_calcularTotal().toStringAsFixed(2)}'),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () => _fecharPedido(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Fechar Pedido'),
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
                            if (_quantidades > 1) {
                              setState(() {
                                _quantidades--;
                              });
                            }
                          },
                        ),
                        Text('$_quantidades'),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.plus),
                          onPressed: () {
                            setState(() {
                              _quantidades++;
                            });
                          },
                        ),
                      ],
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

  Widget _buildCartItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _itensSelecionados.length,
      itemBuilder: (context, index) {
        final item = _itensSelecionados[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.box),
            title: Text(item.produto.nome ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantidade: ${item.quantidade}'),
                Text(
                    'Valor Total: R\$ ${item.valorTotal?.toStringAsFixed(2) ?? '0.00'}'),
              ],
            ),
            trailing: IconButton(
              icon: const FaIcon(FontAwesomeIcons.trash),
              onPressed: () {
                setState(() {
                  _itensSelecionados.removeAt(index);
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalRow() {
    double total = _calcularTotal();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
            'R\$ ${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
