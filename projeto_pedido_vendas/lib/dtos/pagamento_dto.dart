import 'package:projeto_pedido_vendas/models/pagamento.dart';

class PagamentoDTO {
  int? id;
  double valorTotal;
  double desconto;

  PagamentoDTO({this.id, required this.valorTotal, required this.desconto});

  factory PagamentoDTO.fromJson(Map<String, dynamic> json) {
    return PagamentoDTO(
      id: json['id'],
      valorTotal: json['valorTotal'],
      desconto: json['desconto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valorTotal': valorTotal,
      'desconto': desconto,
    };
  }

  Pagamento toPagamento() {
    return Pagamento(
      id: id,
      valorTotal: valorTotal,
      desconto: desconto,
    );
  }
}
