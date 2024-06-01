import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';

class PagamentoDTO {
  int? id;
  int parcelas;
  double valorTotal;
  double desconto;
  String dataVencimento;
  PedidoDTO? pedido;

  PagamentoDTO({
    this.id,
    required this.parcelas,
    required this.valorTotal,
    required this.desconto,
    required this.dataVencimento,
    required this.pedido,
  });

  factory PagamentoDTO.fromJson(Map<String, dynamic> json) {
    return PagamentoDTO(
      id: json['id'],
      parcelas: json['parcelas'],
      valorTotal: json['valorTotal'],
      desconto: json['desconto'],
      dataVencimento: json['dataVencimento'],
      pedido:
          json['pedido'] != null ? PedidoDTO.fromJson(json['pedido']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parcelas': parcelas,
      'valorTotal': valorTotal,
      'desconto': desconto,
      'dataVencimento': dataVencimento,
      'pedidoId': pedido?.id,
    };
  }
}
