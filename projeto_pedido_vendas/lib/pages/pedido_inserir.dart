import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/dtos/forma_pagamento_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/vendedor_dto.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/forma_pagamento.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';
import 'package:projeto_pedido_vendas/pages/appBar.dart';
import 'package:projeto_pedido_vendas/pages/pedido_produtos.dart';
import 'package:projeto_pedido_vendas/repository/cliente_dao.dart';
import 'package:projeto_pedido_vendas/repository/forma_pagamento_dao.dart';
import 'package:projeto_pedido_vendas/repository/pedido_dao.dart';
import 'package:projeto_pedido_vendas/repository/vendedor_dao.dart';

class PedidoCadastro extends StatefulWidget {
  const PedidoCadastro({super.key});

  @override
  State<PedidoCadastro> createState() => _PedidoCadastroState();
}

class _PedidoCadastroState extends State<PedidoCadastro> {
  final ClienteDAO _clienteDAO = ClienteDAO();
  ClienteDTO? _clienteSelecionado;
  List<ClienteDTO> _clientesLista = [];

  final VendedorDAO _vendedorDAO = VendedorDAO();
  VendedorDTO? _vendedorSelecionado;
  List<VendedorDTO> _vendedoresLista = [];

  final FormaPagamentoDAO _formaPagamentoDAO = FormaPagamentoDAO();
  FormaPagamentoDTO? _formaPagamentoSelecionado;
  List<FormaPagamentoDTO> _formasPagamentoLista = [];

  final PedidoDAO _pedidoDAO = PedidoDAO();

  @override
  void initState() {
    super.initState();
    _loadClientes();
    _loadVendedores();
    _loadFormasPagamento();
  }

  void _loadVendedores() async {
    List<Vendedor> vendedores = await _vendedorDAO.selectAll();
    List<VendedorDTO> vendedorDTO = vendedores
        .map((vendedor) => VendedorDTO.fromVendedor(vendedor))
        .toList();
    setState(() {
      _vendedoresLista = vendedorDTO;
      // Definindo o vendedor selecionado como o vendedor do índice 1, (supondo que seja o vendedor logado)
      if (_vendedoresLista.length > 1) {
        _vendedorSelecionado = _vendedoresLista[1];
      }
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

  void _loadFormasPagamento() async {
    List<FormaPagamentoDTO> formasPagamento =
        await _formaPagamentoDAO.selectAll();
    setState(() {
      _formasPagamentoLista = formasPagamento;
    });
  }

  void _emitirPedido(BuildContext context) async {
    if (_clienteSelecionado != null &&
        _vendedorSelecionado != null &&
        _formaPagamentoSelecionado != null) {
      try {
        PedidoDTO pedido = PedidoDTO(
          dataPedido: DateTime.now(),
          observacao: "",
          formaPagamento: _formaPagamentoSelecionado!,
          cliente: _clienteSelecionado!,
          vendedor: _vendedorSelecionado!,
        );

        int idGerado = await _pedidoDAO.insert(pedido);

        pedido.id = idGerado;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PedidoProdutosPage(pedido: pedido),
          ),
        );
      } catch (e) {
        debugPrint('Erro ao emitir o pedido: $e');
      }
    } else {
      debugPrint('Um dos campos necessários está nulo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinhaAppBar(titulo: 'Emitir Novo Pedido'),
      drawer: const MenuLateralEsquerdo(),
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
                const SizedBox(height: 20.0),
                DropdownButtonFormField<FormaPagamentoDTO>(
                  value: _formaPagamentoSelecionado,
                  onChanged: (FormaPagamentoDTO? formaPagamento) {
                    setState(() {
                      _formaPagamentoSelecionado = formaPagamento;
                    });
                  },
                  items: _formasPagamentoLista
                      .map((FormaPagamentoDTO formaPagamento) {
                    return DropdownMenuItem<FormaPagamentoDTO>(
                      value: formaPagamento,
                      child: Text(formaPagamento.descricao ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Forma de Pagamento',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Observações do Pedido',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Insira suas observações aqui...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                  ),
                ),
                const SizedBox(height: 50.0),
                OutlinedButton(
                  onPressed: () => _emitirPedido(context),
                  child: const Text('Prosseguir ao Carrinho'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
