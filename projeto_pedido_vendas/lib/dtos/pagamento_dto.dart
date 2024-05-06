import 'package:projeto_pedido_vendas/models/pedido.dart';

class PagamentoDTO {
  int? id;
  double valorTotal;
  double desconto;
  String
      dataVencimento; // Mudança de DateTime para String para fins de serialização
  int? pedidoId;

  PagamentoDTO({
    this.id,
    required this.valorTotal,
    required this.desconto,
    required this.dataVencimento,
    required this.pedidoId,
  });

  factory PagamentoDTO.fromJson(Map<String, dynamic> json) {
    return PagamentoDTO(
      id: json['id'],
      valorTotal: json['valorTotal'],
      desconto: json['desconto'],
      dataVencimento: json['dataVencimento'],
      pedidoId: json['pedidoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valorTotal': valorTotal,
      'desconto': desconto,
      'dataVencimento': dataVencimento,
      'pedidoId': pedidoId,
    };
  }
}
