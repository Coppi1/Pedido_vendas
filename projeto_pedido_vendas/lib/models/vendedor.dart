import 'dart:convert';

class Vendedor {
  int? id;
  String? nome;

  Vendedor({this.id, this.nome});

  factory Vendedor.fromJson(Map<String, dynamic> json) {
    return Vendedor(
      id: json["id"],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> fromJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
