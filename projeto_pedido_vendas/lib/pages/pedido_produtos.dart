import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/categoria_produto_dto.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/models/categoria_produto.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';
import 'package:projeto_pedido_vendas/pages/appBar.dart';
import 'package:projeto_pedido_vendas/repository/categoria_produto_dao.dart';
import 'package:projeto_pedido_vendas/repository/produto_dao.dart';

class PedidoProdutosPage extends StatefulWidget {
  final PedidoDTO pedido;

  const PedidoProdutosPage({Key? key, required this.pedido}) : super(key: key);

  @override
  _PedidoProdutosPageState createState() => _PedidoProdutosPageState();
}

class _PedidoProdutosPageState extends State<PedidoProdutosPage> {
  List<ItensDTO> _itensPedido = [];
  List<CategoriaProduto> _categorias = [];
  CategoriaProdutoDTO? _categoriaSelecionada;
  List<ProdutoDTO> _produtos = [];
  List<ItensDTO> _itensSelecionados = [];
  int _quantidades = 1; // Quantidade padrão para cada produto

  @override
  void initState() {
    super.initState();
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
    final ItensDTO item = ItensDTO(
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

  void _fecharPedido(BuildContext context) {
    // Implemente a lógica para fechar o pedido
    Navigator.pop(context); // Fechar a tela após fechar o pedido
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinhaAppBar(),
      drawer: const MenuLateralEsquerdo(),
      endDrawer: MenuLateralDireito(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pedido #${widget.pedido.id}'),
              SizedBox(height: 10),
              Text(
                'Cliente: ${widget.pedido.cliente?.nome}',
              ),
              Text(
                'Vendedor: ${widget.pedido.vendedor?.nome}',
              ),
              Text(
                'Forma de Pagamento: ${widget.pedido.formaPagamento?.descricao}',
              ),
              SizedBox(height: 20),
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
                icon: Icon(Icons.shopping_cart),
                label: Text('Adicionar ao Carrinho'),
                onPressed: () =>
                    _adicionarProdutoAoCarrinho(_produtos.first, _quantidades),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 143, 205, 255),
                  onPrimary: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200, // Adjust the height according to your needs
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
                                SizedBox(width: 70),
                                Text(
                                    'Total: R\$ ${_itensSelecionados[index].valorTotal!.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13.0),
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      Text('Total: R\$ ${_calcularTotal().toStringAsFixed(2)}'),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  child: Text('Fechar Pedido'),
                  onPressed: () => _fecharPedido(context),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
