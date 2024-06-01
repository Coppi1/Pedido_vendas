import 'package:projeto_pedido_vendas/models/pagamento.dart';
import 'package:projeto_pedido_vendas/models/pedido.dart';

class PagamentoParcela {
  int? id;
  int? parcela;
  double? valor;
  double? desconto;
  String? dataVencimento;
  Pagamento? pagamento;

  PagamentoParcela({
    this.id,
    this.parcela,
    this.valor,
    this.desconto,
    this.dataVencimento,
    this.pagamento,
  });
}
