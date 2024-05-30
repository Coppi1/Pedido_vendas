import 'package:projeto_pedido_vendas/models/vendedor.dart';

class VendedorDTO {
  int? id;
  String? nome;
  String? email;
  String? senha;

  VendedorDTO({this.id, this.nome, this.email, this.senha});

  factory VendedorDTO.fromJson(Map<String, dynamic> json) {
    return VendedorDTO(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha
    };
  }

  factory VendedorDTO.fromVendedor(Vendedor vendedor) {
    return VendedorDTO(
      id: vendedor.id,
      nome: vendedor.nome,
      email: vendedor.email,
      senha: vendedor.senha,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
}
