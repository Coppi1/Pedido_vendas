import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';
import 'package:projeto_pedido_vendas/repository/cliente_dao.dart';
import 'package:projeto_pedido_vendas/repository/pedido_dao.dart';

class PedidoEmitirPage extends StatefulWidget {
  @override
  _PedidoEmitirPageState createState() => _PedidoEmitirPageState();
}

class _PedidoEmitirPageState extends State<PedidoEmitirPage> {
  final ClienteDAO _clienteDAO = ClienteDAO(); // Instância do DAO do cliente
  ClienteDTO? _clienteSelecionado; // Cliente selecionado no dropdown
  List<ClienteDTO> _clientes = []; // Lista de clientes

  @override
  void initState() {
    super.initState();

    _loadClientes();
  }

  void _loadClientes() async {
    List<Cliente> clientes = await _clienteDAO.selectAll();
    List<ClienteDTO> clientesDTO =
        clientes.map((cliente) => ClienteDTO.fromCliente(cliente)).toList();

    // Remover duplicatas
    clientesDTO = clientesDTO.toSet().toList();

    setState(() {
      _clientes = clientesDTO;
    });
  }

  // Criar um novo cliente
  ClienteDTO novoCliente = ClienteDTO(
    nome: 'Teste',
    endereco: 'Rua das Flores, 123',
    cidade: 'São Paulo',
    nmrCpfCnpj: '123.456.789-00',
    vendedor: Vendedor(
        id: 1,
        nome: 'Vendedor 1'), // Supondo que você tenha um vendedor com ID 1
  );

  @override
  Widget build(BuildContext context) {
    if (_clientes.isEmpty) {
      return Center(child: Text('Nenhum cliente disponível.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Emitir Pedido'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButtonFormField<ClienteDTO>(
              key:
                  UniqueKey(), // Adiciona uma chave única ao DropdownButtonFormField
              value: _clienteSelecionado,
              onChanged: (ClienteDTO? cliente) {
                setState(() {
                  _clienteSelecionado = cliente;
                });
              },
              items: _clientes.map((ClienteDTO cliente) {
                return DropdownMenuItem<ClienteDTO>(
                  key:
                      UniqueKey(), // Adiciona uma chave única a cada DropdownMenuItem
                  value: cliente,
                  child: Text(cliente.nome ?? ''),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Cliente',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
