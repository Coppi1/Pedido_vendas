import 'package:projeto_pedido_vendas/models/pagamento.dart';
import 'package:projeto_pedido_vendas/models/pedido.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';

class PagamentoDTO {
  int? id;
  int parcela;
  double valorTotal;
  double desconto;
  String dataVencimento;
  PedidoDTO? pedido;

  PagamentoDTO({
    this.id,
    required this.parcela,
    required this.valorTotal,
    required this.desconto,
    required this.dataVencimento,
    required this.pedido,
  });

  factory PagamentoDTO.fromJson(Map<String, dynamic> json) {
    return PagamentoDTO(
      id: json['id'],
      parcela: json['parcelas'],
      valorTotal: json['valorTotal'],
      desconto: json['desconto'],
      dataVencimento: json['dataVencimento'],
      pedido: json.containsKey('pedido')
          ? PedidoDTO.fromJson(json['pedido'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parcelas': parcela,
      'valorTotal': valorTotal,
      'desconto': desconto,
      'dataVencimento': dataVencimento,
      'pedido': pedido?.toJson(),
    };
  }

  // factory PagamentoDTO.fromPagamento(Pagamento pagamento) {
  //   return PagamentoDTO(
  //     id: pagamento.id,
  //     parcelas: pagamento.parcelas,
  //     valorTotal: pagamento.valorTotal,
  //     desconto: pagamento.desconto,
  //     dataVencimento: pagamento.dataVencimento.toIso8601String(),
  //     pedido: PedidoDTO.fromPedido(pagamento.pedido),
  //   );
  // }

  // Pagamento toPagamento() {
  //   return Pagamento(
  //     id: id,
  //     parcelas: parcelas,
  //     valorTotal: valorTotal,
  //     desconto: desconto,
  //     dataVencimento: DateTime.parse(dataVencimento),
  //     pedido: pedido!.toPedido(),
  //   );
  // }
}
