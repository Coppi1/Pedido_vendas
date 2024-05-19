import 'package:projeto_pedido_vendas/models/vendedor.dart';

class Cliente {
  int? id;
  String? nome;
  String? endereco;
  String? cidade;
  String? nmrCpfCnpj;
  Vendedor? vendedor;

  Cliente({
    this.id,
    this.cidade,
    this.endereco,
    this.nome,
    this.nmrCpfCnpj,
    this.vendedor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'cidade': cidade,
      'nmrCpfCnpj': nmrCpfCnpj,
      'vendedor': vendedor?.toMap(),
    };
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      cidade: json['cidade'],
      nmrCpfCnpj: json['nmrCpfCnpj'],
      vendedor:
          json['vendedor'] != null ? Vendedor.fromJson(json['vendedor']) : null,
    );
  }
}
