// import 'package:flutter/material.dart';
// import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';

// class PagamentoPage extends StatefulWidget {
//   final PedidoDTO pedido;

//   const PagamentoPage({Key? key, required this.pedido}) : super(key: key);

//   @override
//   _PagamentoPageState createState() => _PagamentoPageState();
// }

// class _PagamentoPageState extends State<PagamentoPage> {
//   double _desconto = 0.0;
//   double _valorTotalComDesconto = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _calcularValorTotalComDesconto();
//   }

//   void _calcularValorTotalComDesconto() {
//     double total = widget.pedido.valorTotal;
//     double desconto = _desconto;

//     setState(() {
//       _valorTotalComDesconto = total - desconto;
//     });
//   }

//   void _finalizarPedido() async {
//     // Atualize o valor total do pedido com o valor total com desconto
//     widget.pedido.valorTotal = _valorTotalComDesconto;

//     // Aqui você pode inserir o pedido no banco de dados
//     // Por exemplo, se você tiver um DAO para pedidos, você chamaria algo como:
//     // await PedidoDAO().insert(widget.pedido);

//     // Após inserir o pedido, você pode navegar para outra tela
//     // Por exemplo, para uma tela de confirmação:
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) =>
//             ConfirmacaoPage(), // Substitua ConfirmacaoPage pela sua tela de confirmação
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pagamento'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       'Cliente: ${widget.pedido.cliente.nome}',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'Vendedor: ${widget.pedido.vendedor.nome}',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'Forma de Pagamento: ${widget.pedido.formaPagamento}',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'Total: R\$ ${widget.pedido.valorTotal.toStringAsFixed(2)}',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Desconto',
//               ),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 setState(() {
//                   _desconto = double.tryParse(value) ?? 0.0;
//                   _calcularValorTotalComDesconto();
//                 });
//               },
//             ),
//             SizedBox(height: 16.0),
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       'Valor Total com Desconto:',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'R\$ ${_valorTotalComDesconto.toStringAsFixed(2)}',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Implementar a lógica para finalizar o pedido e navegar para a próxima tela
//               },
//               child: Text('Finalizar Pedido'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ConfirmacaoPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Confirmação'),
//       ),
//       body: Center(
//         child: Text('Pedido confirmado com sucesso'),
//       ),
//     );
//   }
// }
