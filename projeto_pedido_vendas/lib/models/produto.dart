import 'dart:convert';

class Produto {
  int id;
  String marca;
  String unidade;
  String tipoProduto;
  String nome;
  double valor;

  @override
  String toString() {
    return nome;
  }

  Produto({
    required this.id,
    required this.marca,
    required this.unidade,
    required this.tipoProduto,
    required this.nome,
    required this.valor,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
        id: json['id'],
        marca: json['marca'],
        unidade: json['unidade'],
        tipoProduto: json['tipoProduto'],
        nome: json['nome'],
        valor: double.tryParse(json['valor'].toString()) ?? 0.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marca': marca,
      'unidade': unidade,
      'tipoProduto': tipoProduto,
      'nome': nome,
      'valor': valor,
    };
  }
}
