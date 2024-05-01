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
  List<ItensDTO> _itensLista = [];

  List<ProdutoDTO> _produtosSelecionados = [];
  List<int> _quantidades = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinhaAppBar(),
      drawer: MenuLateralEsquerdo(), // Adiciona o menu lateral direito
      endDrawer: MenuLateralDireito(), // Adiciona o menu lateral esquerdo
      body: SingleChildScrollView(
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
                  child: Text(cliente.nome ?? ''),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Cliente',
              ),
            ),
            DropdownButtonFormField<VendedorDTO>(
              value: _vendedorSelecionado,
              onChanged: (VendedorDTO? vendedor) {
                setState(() {
                  _vendedorSelecionado = vendedor;
                });
              },
              items: _vendedoresLista.map((VendedorDTO vendedor) {
                return DropdownMenuItem<VendedorDTO>(
                  value: vendedor,
                  child: Text(vendedor.nome ?? ''),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Vendedor',
              ),
            ),
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
                  child: Text(produto.nome ?? ''),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Produto',
              ),
            ),
            ElevatedButton(
              onPressed: _adicionarProdutoAoCarrinho,
              child: Text('Adicionar ao Carrinho'),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _produtosSelecionados.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Text(_produtosSelecionados[index].nome ?? ''),
                    SizedBox(width: 10),
                    Text('Quantidade: '),
                    SizedBox(
                      width: 50,
                      child: TextFormField(
                        initialValue: _quantidades[index].toString(),
                        onChanged: (value) {
                          _alterarQuantidade(index, int.tryParse(value) ?? 1);
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                        'Total: ${_produtosSelecionados[index].valor * _quantidades[index]}'),
                  ],
                );
              },
            ),
            Text('Total: ${_calcularTotal()}'),
          ],
        ),
      ),
    );
  }
}
