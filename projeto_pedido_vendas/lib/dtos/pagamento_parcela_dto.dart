import 'package:projeto_pedido_vendas/dtos/pagamento_dto.dart';

class PagamentoParcelaDTO {
  int? id;
  int? parcela;
  double? valor;
  double? desconto;
  String? dataVencimento;
  PagamentoDTO? pagamento;

  PagamentoParcelaDTO({
    this.id,
    this.parcela,
    this.valor,
    this.desconto,
    this.dataVencimento,
    this.pagamento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parcela': parcela,
      'valor': valor,
      'desconto': desconto,
      'dataVencimento': dataVencimento,
      'pagamento': pagamento?.toJson(), // Referência ao pagamento
    };
  }

  factory PagamentoParcelaDTO.fromMap(Map<String, dynamic> map) {
    return PagamentoParcelaDTO(
      id: map['id'],
      parcela: map['parcela'],
      valor: map['valor'],
      desconto: map['desconto'],
      dataVencimento: map['dataVencimento'],
      pagamento:
          PagamentoDTO.fromJson(map['pagamento']), // Referência ao pagamento
    );
  }
}
