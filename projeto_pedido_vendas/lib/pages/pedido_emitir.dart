import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/dtos/vendedor_dto.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';
import 'package:projeto_pedido_vendas/repository/cliente_dao.dart';
import 'package:projeto_pedido_vendas/repository/itens_pedido.dart';
import 'package:projeto_pedido_vendas/repository/pedido_dao.dart';
import 'package:projeto_pedido_vendas/repository/produto_dao.dart';
import 'package:projeto_pedido_vendas/repository/vendedor_dao.dart';

class PedidoEmitirPage extends StatefulWidget {
  const PedidoEmitirPage({super.key});

  @override
  _PedidoEmitirPageState createState() => _PedidoEmitirPageState();
}

class _PedidoEmitirPageState extends State<PedidoEmitirPage> {
  final ClienteDAO _clienteDAO = ClienteDAO(); // Instância do DAO do cliente
  ClienteDTO? _clienteSelecionado; // Cliente selecionado no dropdown
  List<ClienteDTO> _clientesLista = []; // Lista de clientes

  final VendedorDAO _vendedorDAO = VendedorDAO();
  VendedorDTO?
      _vendedorSelecionado; // para teste apagar pois pegará do usuário logado
  List<VendedorDTO> _vendedoresLista = [];

  final ProdutoDAO _produtoDAO = ProdutoDAO();
  ProdutoDTO? _produtoSelecionado;
  List<ProdutoDTO> _produtosLista = [];

  final ItensDAO _itensDAO = ItensDAO();
  ItensDTO? _itensDTO;
  final List<ItensDTO> _itens_lista = [];

  @override
  void initState() {
    super.initState();

    _loadClientes();
    _loadVendedores();
    _loadProdutos();
  }

  void _loadClientes() async {
    // Supondo que _clienteDAO.selectAll() retorna Future<List<Cliente>>
    List<Cliente> clientes = await _clienteDAO.selectAll();
    // Converte cada Cliente em um ClienteDTO
    List<ClienteDTO> clientesDTO =
        clientes.map((cliente) => ClienteDTO.fromCliente(cliente)).toList();
    // Atualiza o estado da aplicação com a lista de clientes DTO
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emitir Pedido'),
      ),
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
          ],
        ),
      ),
    );
  }
}
