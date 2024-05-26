import 'package:projeto_pedido_vendas/models/pedido.dart';

class Pagamento {
  int? id;
  int parcelas;
  double valorTotal;
  double desconto;
  DateTime dataVencimento;
  Pedido pedido;

  Pagamento(
      {this.id,
      required this.parcelas,
      required this.valorTotal,
      required this.desconto,
      required this.dataVencimento,
      required this.pedido});
}
