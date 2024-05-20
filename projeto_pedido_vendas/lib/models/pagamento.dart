import 'package:projeto_pedido_vendas/models/pedido.dart';

class Pagamento {
  int? id;
  double valorTotal;
  double desconto;
  DateTime dataVencimento;
  Pedido pedido;

  Pagamento(
      {this.id,
      required this.valorTotal,
      required this.desconto,
      required this.dataVencimento,
      required this.pedido});
}
