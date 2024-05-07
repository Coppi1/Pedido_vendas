import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/dtos/forma_pagamento_dto.dart';
import 'package:projeto_pedido_vendas/dtos/vendedor_dto.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/forma_pagamento.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';
import 'package:projeto_pedido_vendas/pages/appBar.dart';
import 'package:projeto_pedido_vendas/repository/cliente_dao.dart';
import 'package:projeto_pedido_vendas/repository/forma_pagamento.dart';
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

  @override
  void initState() {
    super.initState();
    _loadClientes();
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

  void _loadFormasPagamento() async {
    List<FormaPagamento> formasPagamento = await _formaPagamentoDAO.selectAll();
    List<FormaPagamentoDTO> formasPagamentoDTO = formasPagamento
        .map((formaPagamento) =>
            FormaPagamentoDTO.fromFormaPagamento(formaPagamento))
        .toList();
    setState(() {
      _formasPagamentoLista = formasPagamentoDTO;
    });
  }

     void _emitirPedido(BuildContext context) async {
     if (_clienteSelecionado != null &&
         _vendedorSelecionado != null) {
       
       DateTime dataPedido = DateTime.now(); // Definindo a data de hoje
       
       VendedorDTO vendedor =
           _vendedoresLista[0];  // Pegando o primeiro vendedor da lista

     
      //  Criando o DTO de pedido
       PedidoDTO pedido = PedidoDTO(
         id: 1,
         dataPedido: dataPedido,
         observacao: "",  Observação inicial vazia
         formaPagamento:
             _formaPagamentoSelecionada ?? "",  Forma de pagamento selecionada
         itens: itens,
         valorTotal: _calcularTotal(),
         cliente: _clienteSelecionado!
             .toCliente(),  Convertendo o cliente selecionado para o modelo Cliente
         vendedor: _vendedorSelecionado!
             .toVendedor(),  Convertendo o vendedor selecionado para o modelo Vendedor
         pagamento: pagamento.toPagamento(),  Passando o DTO de pagamento
       );

       // Salvar o pedido no banco de dados ou fazer qualquer outra operação necessária
       await _pedidoDAO.insert(pedido);

      //  Adicionar um log para verificar se o método está sendo chamado corretamente
       print('Pedido emitido: $pedido');

      //  Navegar para a tela de pagamento, passando o pedido como argumento
       Navigator.of(context).push(
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
                const SizedBox(height: 16.0),
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
