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
      // Definindo o vendedor selecionado como o vendedor do índice 1, se houver pelo menos dois vendedores
      if (_vendedoresLista.length > 1) {
        _vendedorSelecionado = _vendedoresLista[1];
      }
      debugPrint(
          'Vendedor selecionado: $_vendedorSelecionado $_vendedoresLista');
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
    debugPrint('_emitirPedido chamado');
    debugPrint('Cliente selecionado: $_clienteSelecionado');
    debugPrint('Vendedor selecionado: $_vendedorSelecionado');
    debugPrint('Forma de pagamento selecionada: $_formaPagamentoSelecionado');
    if (_clienteSelecionado != null &&
        _vendedorSelecionado != null &&
        _formaPagamentoSelecionado != null) {
      try {
        // Criando o DTO de pedido
        PedidoDTO pedido = PedidoDTO(
          dataPedido: DateTime.now(),
          observacao: "",
          formaPagamento: _formaPagamentoSelecionado!,
          cliente: _clienteSelecionado!,
          vendedor: _vendedorSelecionado!,
        );

        // Salvar o pedido no banco de dados
        await _pedidoDAO.insert(pedido);

        // Exibir um alerta com os dados do pedido
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Pedido Emitido"),
              content: Text(
                  "Pedido emitido com sucesso:\n\nData: ${pedido.dataPedido}\nCliente: ${pedido.cliente.nome}\nVendedor: ${pedido.vendedor.nome}\nForma de Pagamento: ${pedido.formaPagamento.descricao}"),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o diálogo
                  },
                ),
              ],
            );
          },
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PedidoProdutosPage(pedido: pedido),
          ),
        );
      } catch (e) {
        // Trate o erro aqui, por exemplo, mostrando uma mensagem de erro ao usuário
        debugPrint('Erro ao emitir o pedido: $e');
        // Você pode querer mostrar um diálogo de erro aqui também
      }
    } else {
      debugPrint('Um dos campos necessários está nulo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinhaAppBar(),
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
                  child: const Text('Iniciar Pedido'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
