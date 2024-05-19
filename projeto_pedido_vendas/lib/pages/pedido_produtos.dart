import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/categoria_produto_dto.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/models/categoria_produto.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/repository/categoria_produto_dao.dart';
import 'package:projeto_pedido_vendas/repository/produto_dao.dart';

class PedidoProdutosPage extends StatefulWidget {
  final PedidoDTO pedido;

  const PedidoProdutosPage({Key? key, required this.pedido}) : super(key: key);

  @override
  _PedidoProdutosPageState createState() => _PedidoProdutosPageState();
}

class _PedidoProdutosPageState extends State<PedidoProdutosPage> {
  final List<ItensDTO> _itensPedido = [];
  List<CategoriaProduto> _categorias = [];
  CategoriaProdutoDTO? _categoriaSelecionada;
  List<ProdutoDTO> _produtos = [];
  final List<ItensDTO> _itensSelecionados = [];
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
      appBar: AppBar(
        title: const Text('Carrinho de Produtos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pedido #${widget.pedido.id}',
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text('Cliente: ${widget.pedido.cliente?.nome}',
                style: const TextStyle(fontSize: 18)),
            Text('Vendedor: ${widget.pedido.vendedor?.nome}',
                style: const TextStyle(fontSize: 18)),
            Text(
                'Forma de Pagamento: ${widget.pedido.formaPagamento?.descricao}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () =>
                  _adicionarProdutoAoCarrinho(_produtos.first, _quantidades),
              child: const Text('Adicionar ao Carrinho'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _itensSelecionados.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(_itensSelecionados[index].produto?.nome ??
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
                          const SizedBox(
                            width: 70,
                          ),
                          Text(
                            'Total: R\$ ${_itensSelecionados[index].valorTotal!.toStringAsFixed(2)}',
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 13.0),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.all(2.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: R\$ ${_calcularTotal().toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            OutlinedButton(
              onPressed: () => _fecharPedido(context),
              child: const Text('Fechar Pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
