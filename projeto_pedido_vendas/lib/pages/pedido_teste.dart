import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/dtos/vendedor_dto.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';
import 'package:projeto_pedido_vendas/pages/appBar.dart';
import 'package:projeto_pedido_vendas/repository/cliente_dao.dart';
import 'package:projeto_pedido_vendas/repository/itens_pedido.dart';
import 'package:projeto_pedido_vendas/repository/pedido_dao.dart';
import 'package:projeto_pedido_vendas/repository/produto_dao.dart';
import 'package:projeto_pedido_vendas/repository/vendedor_dao.dart';
import 'package:intl/intl.dart';

class PedidoEmitirPageTeste extends StatefulWidget {
  const PedidoEmitirPageTeste({Key? key}) : super(key: key);

  @override
  _PedidoEmitirPageTesteState createState() => _PedidoEmitirPageTesteState();
}

class _PedidoEmitirPageTesteState extends State<PedidoEmitirPageTeste> {
  final ClienteDAO _clienteDAO = ClienteDAO();
  ClienteDTO? _clienteSelecionado;
  List<ClienteDTO> _clientesLista = [];

  final VendedorDAO _vendedorDAO = VendedorDAO();
  VendedorDTO? _vendedorSelecionado;
  List<VendedorDTO> _vendedoresLista = [];

  final ProdutoDAO _produtoDAO = ProdutoDAO();
  ProdutoDTO? _produtoSelecionado;
  List<ProdutoDTO> _produtosLista = [];

  final ItensDAO _itensDAO = ItensDAO();
  ItensDTO? _itensDTO;
  final List<ItensDTO> _itensLista = [];

  final List<ProdutoDTO> _produtosSelecionados = [];
  final List<int> _quantidades = [];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  String _observacoes = '';

  @override
  void initState() {
    super.initState();

    _loadClientes();
    _loadVendedores();
    _loadProdutos();
  }

  void _loadClientes() async {
    List<Cliente> clientes = await _clienteDAO.selectAll();
    List<ClienteDTO> clientesDTO =
        clientes.map((cliente) => ClienteDTO.fromCliente(cliente)).toList();
    setState(() {
      _clientesLista = clientesDTO;
    });
  }

  void _loadVendedores() async {
    List<Vendedor> vendedores = await _vendedorDAO.selectAll();
    List<VendedorDTO> vendedorDTO = vendedores
        .map((vendedor) => VendedorDTO.fromVendedor(vendedor))
        .toList();
    setState(() {
      _vendedoresLista = vendedorDTO;
    });
  }

  void _loadProdutos() async {
    List<Produto> produtos = await _produtoDAO.selectAll();
    List<ProdutoDTO> produtoDTO =
        produtos.map((produto) => ProdutoDTO.fromProduto(produto)).toList();
    setState(() {
      _produtosLista = produtoDTO;
    });
  }

  void _adicionarProdutoAoCarrinho() {
    if (_produtoSelecionado != null) {
      setState(() {
        _produtosSelecionados.add(_produtoSelecionado!);
        _quantidades.add(1); // Quantidade padrão ao adicionar um produto
      });

      _listKey.currentState!.insertItem(_produtosSelecionados.length - 1);
    }
  }

  double _calcularTotal() {
    double total = 0;
    for (int i = 0; i < _produtosSelecionados.length; i++) {
      total += _produtosSelecionados[i].valor * _quantidades[i];
    }
    return total;
  }

  void _alterarQuantidade(int index, int novaQuantidade) {
    setState(() {
      _quantidades[index] = novaQuantidade;
    });
  }

  void _removerProdutoDoCarrinho(int index) {
    setState(() {
      _produtosSelecionados.removeAt(index);
      _quantidades.removeAt(index);
    });

    _listKey.currentState!.removeItem(
        index,
        (context, animation) => FadeTransition(
              opacity: animation,
              child: const SizedBox(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinhaAppBar(),
      drawer: MenuLateralEsquerdo(),
      endDrawer: MenuLateralDireito(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 143, 205, 255), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.7],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DropdownButtonFormField<ClienteDTO>(
                  value: _clienteSelecionado,
                  onChanged: (ClienteDTO? cliente) {
                    setState(() {
                      _clienteSelecionado = cliente;
                    });
                  },
                  items: _clientesLista.map((ClienteDTO cliente) {
                    return DropdownMenuItem<ClienteDTO>(
                      value: cliente,
                      child: Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 8.0),
                          Text(cliente.nome ?? ''),
                        ],
                      ),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Cliente',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<ProdutoDTO>(
                  value: _produtoSelecionado,
                  onChanged: (ProdutoDTO? produto) {
                    setState(() {
                      _produtoSelecionado = produto;
                    });
                  },
                  items: _produtosLista.map((ProdutoDTO produto) {
                    return DropdownMenuItem<ProdutoDTO>(
                      value: produto,
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_bag),
                          const SizedBox(width: 8.0),
                          Text(produto.nome ?? ''),
                        ],
                      ),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Produto',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Observações',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      _observacoes = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _adicionarProdutoAoCarrinho,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_shopping_cart),
                      SizedBox(width: 8.0),
                      Text('Adicionar ao Carrinho'),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                AnimatedList(
                  key: _listKey,
                  shrinkWrap: true,
                  initialItemCount: _produtosSelecionados.length,
                  itemBuilder: (context, index, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(_produtosSelecionados[index].nome ?? ''),
                          subtitle: Row(
                            children: [
                              const Text('Quantidade: '),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  initialValue: _quantidades[index].toString(),
                                  onChanged: (value) {
                                    _alterarQuantidade(
                                        index, int.tryParse(value) ?? 1);
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Text(
                                  'Total: ${_produtosSelecionados[index].valor * _quantidades[index]}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              _removerProdutoDoCarrinho(index);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:'),
                        Text('${_calcularTotal()}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
