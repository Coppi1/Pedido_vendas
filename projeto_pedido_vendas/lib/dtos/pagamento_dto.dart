import 'package:projeto_pedido_vendas/models/pedido.dart';

class PagamentoDTO {
  int? id;
  int parcelas;
  double valorTotal;
  double desconto;
  String dataVencimento;
  int? pedidoId;

  PagamentoDTO({
    this.id,
    required this.parcelas,
    required this.valorTotal,
    required this.desconto,
    required this.dataVencimento,
    required this.pedidoId,
  });

  factory PagamentoDTO.fromJson(Map<String, dynamic> json) {
    return PagamentoDTO(
      id: json['id'],
      parcelas: json['parcelas'],
      valorTotal: json['valorTotal'],
      desconto: json['desconto'],
      dataVencimento: json['dataVencimento'],
      pedidoId: json['pedidoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parcelas': parcelas,
      'valorTotal': valorTotal,
      'desconto': desconto,
      'dataVencimento': dataVencimento,
      'pedidoId': pedidoId,
    };
  }
}
