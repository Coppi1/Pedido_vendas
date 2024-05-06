import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pagamento_dto.dart'; // Importe o DTO de pagamento
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/dtos/vendedor_dto.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';
import 'package:projeto_pedido_vendas/pages/appBar.dart';
import 'package:projeto_pedido_vendas/pages/pedido_pagamento.dart'; // Importe a tela de pagamento
import 'package:projeto_pedido_vendas/repository/cliente_dao.dart';
import 'package:projeto_pedido_vendas/repository/itens_pedido.dart';
import 'package:projeto_pedido_vendas/repository/pedido_dao.dart';
import 'package:projeto_pedido_vendas/repository/produto_dao.dart';
import 'package:projeto_pedido_vendas/repository/vendedor_dao.dart';

class PedidoEmitirPageTeste2 extends StatefulWidget {
  const PedidoEmitirPageTeste2({Key? key}) : super(key: key);

  @override
  _PedidoEmitirPageTeste2State createState() => _PedidoEmitirPageTeste2State();
}

class _PedidoEmitirPageTeste2State extends State<PedidoEmitirPageTeste2> {
  final ClienteDAO _clienteDAO = ClienteDAO();
  ClienteDTO? _clienteSelecionado;
  List<ClienteDTO> _clientesLista = [];

  final VendedorDAO _vendedorDAO = VendedorDAO();
  final ProdutoDAO _produtoDAO = ProdutoDAO();
  final PedidoDAO _pedidoDAO = PedidoDAO();

  VendedorDTO? _vendedorSelecionado;
  List<VendedorDTO> _vendedoresLista = [];

  ProdutoDTO? _produtoSelecionado;
  List<ProdutoDTO> _produtosLista = [];

  final ItensDAO _itensDAO = ItensDAO();
  ItensDTO? _itensDTO;
  final List<ItensDTO> _itensLista = [];

  final List<ProdutoDTO> _produtosSelecionados = [];
  final List<int> _quantidades = [];

  final List<String> formasPagamento = [
    'Dinheiro',
    'Cartão de Crédito',
    'Cartão de Débito',
    'Pix'
  ];
  String? _formaPagamentoSelecionada;

  @override
  void initState() {
    super.initState();
    _loadClientes();
    _loadProdutos();
    _loadVendedores();
    _vendedorSelecionado =
        _vendedoresLista.length > 1 ? _vendedoresLista[1] : null;
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

  void _loadClientes() async {
    List<Cliente> clientes = await _clienteDAO.selectAll();
    List<ClienteDTO> clientesDTO =
        clientes.map((cliente) => ClienteDTO.fromCliente(cliente)).toList();
    setState(() {
      _clientesLista = clientesDTO;
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
        _quantidades.add(1);
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

  void _emitirPedido() async {
    if (_clienteSelecionado != null &&
        _produtosSelecionados.isNotEmpty &&
        _vendedorSelecionado != null) {
      DateTime dataPedido = DateTime.now(); // Definindo a data de hoje
      VendedorDTO vendedor =
          _vendedoresLista[0]; // Pegando o primeiro vendedor da lista

      // Criando o DTO de pagamento com valor total igual ao total do pedido e desconto inicial zero
      PagamentoDTO pagamento =
          PagamentoDTO(valorTotal: _calcularTotal(), desconto: 0);

      // Criando o DTO de itens pedido
      ItensDTO itens = ItensDTO(
          produtos:
              _produtosSelecionados.map((produto) => produto.toMap()).toList());

      // Criando o DTO de pedido
      PedidoDTO pedido = PedidoDTO(
        dataPedido: dataPedido,
        observacao: "", // Observação inicial vazia
        formaPagamento:
            _formaPagamentoSelecionada ?? "", // Forma de pagamento selecionada
        itens: itens.toItens(),
        valorTotal: _calcularTotal(),
        cliente: _clienteSelecionado!
            .toCliente(), // Convertendo o cliente selecionado para o modelo Cliente
        vendedor: _vendedorSelecionado!
            .toVendedor(), // Convertendo o vendedor selecionado para o modelo Vendedor
        pagamento: pagamento.toPagamento(), // Passando o DTO de pagamento
      );

      // Salvar o pedido no banco de dados ou fazer qualquer outra operação necessária
      await _pedidoDAO.insert(pedido);

      // Navegar para a tela de pagamento, passando o pedido como argumento
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PagamentoPage(pedido: pedido),
        ),
      );
    }
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
                      child: Text(cliente.nome ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Cliente',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _formaPagamentoSelecionada,
                  onChanged: (String? formaPagamento) {
                    setState(() {
                      _formaPagamentoSelecionada = formaPagamento;
                    });
                  },
                  items: formasPagamento.map((String formaPagamento) {
                    return DropdownMenuItem<String>(
                      value: formaPagamento,
                      child: Text(formaPagamento),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Forma de Pagamento',
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
                      child: Text(produto.nome ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Produto',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                OutlinedButton(
                  onPressed: _adicionarProdutoAoCarrinho,
                  child: const Text('Adicionar ao Carrinho'),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _produtosSelecionados.length,
                  itemBuilder: (context, index) {
                    return Card(
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
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 70,
                            ),
                            Text(
                              'Total: R\$ ${(_produtosSelecionados[index].valor * _quantidades[index]).toStringAsFixed(2)}',
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 13.0,
                ),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(2.0),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total: R\$ ${_calcularTotal().toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ),
                const SizedBox(height: 50.0),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Observações do Pedido',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Insira suas observações aqui...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  ),
                ),
                const SizedBox(height: 50.0),
                OutlinedButton(
                  onPressed:
                      _emitirPedido, // Alterado para chamar a função de emitir pedido
                  child: const Text('Emitir Pedido'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
