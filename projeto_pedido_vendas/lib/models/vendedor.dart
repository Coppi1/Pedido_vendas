import 'dart:convert';

import 'package:projeto_pedido_vendas/dtos/vendedor_dto.dart';

class Vendedor {
  int? id;
  String? nome;

  Vendedor({this.id, this.nome});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory Vendedor.fromJson(Map<String, dynamic> json) {
    return Vendedor(
      id: json['id'],
      nome: json['nome'],
    );
  }

  factory Vendedor.fromVendedorDTO(VendedorDTO dto) {
    return Vendedor(
      id: dto.id,
      nome: dto.nome,
    );
  }
}
