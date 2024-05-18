import 'dart:convert';

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
}
