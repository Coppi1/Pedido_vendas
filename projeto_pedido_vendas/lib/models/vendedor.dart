import 'dart:convert';

import 'package:projeto_pedido_vendas/dtos/vendedor_dto.dart';

class Vendedor {
  int? id;
  String? nome;
  String? email;
  String? senha;

  Vendedor({this.id, this.nome, this.email, this.senha});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory Vendedor.fromJson(Map<String, dynamic> json) {
    return Vendedor(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha']
    );
  }

  factory Vendedor.fromVendedorDTO(VendedorDTO dto) {
    return Vendedor(
      id: dto.id,
      nome: dto.nome,
      email: dto.email,
      senha: dto.senha
    );
  }
}
