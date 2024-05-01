import 'package:projeto_pedido_vendas/models/vendedor.dart';

class Cliente {
  int? id;
  String? nome;
  String? endereco;
  String? cidade;
  String? nmrCpfCnpj;
  Vendedor? vendedor; // Modifique o tipo aqui

  Cliente({
    this.id,
    this.cidade,
    this.endereco,
    this.nome,
    this.nmrCpfCnpj,
    this.vendedor,
  });

  Map<String, dynamic> fromJson() {
    return {
      'id': id,
      'cidade': cidade,
      'vendedor': vendedor?.fromJson(),
      'nome': nome,
      'endereco': endereco,
      'nmrCpfCnpj': nmrCpfCnpj,
    };
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      cidade: json['cidade'],
      vendedor:
          json['vendedor'] != null ? Vendedor.fromJson(json['vendedor']) : null,
      nome: json['nome'],
      endereco: json['endereco'],
      nmrCpfCnpj: json['nmrCpfCnpj'],
    );
  }
}
