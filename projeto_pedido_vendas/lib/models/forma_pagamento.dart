import 'package:projeto_pedido_vendas/dtos/forma_pagamento_dto.dart';

class FormaPagamento {
  int? id;
  String? descricao;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }

  FormaPagamento({this.id, required this.descricao});

  factory FormaPagamento.fromFormaPagamentoDTO(FormaPagamentoDTO dto) {
    return FormaPagamento(
      id: dto.id,
      descricao: dto.descricao,
    );
  }

  factory FormaPagamento.fromJson(Map<String, dynamic> json) {
    return FormaPagamento(
      id: json['id'],
      descricao: json['descricao'],
    );
  }
}
