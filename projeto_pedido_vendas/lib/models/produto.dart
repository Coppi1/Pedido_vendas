import 'dart:convert';

import 'package:projeto_pedido_vendas/models/categoria_produto.dart';

class Produto {
  int? id;
  String? marca;
  String? unidade;
  String? tipoProduto;
  String nome;
  double? valor;
  CategoriaProduto? categoriaProduto;

  @override
  String toString() {
    return nome;
  }

  Produto(
      {this.id,
      required this.marca,
      required this.unidade,
      required this.tipoProduto,
      required this.nome,
      required this.valor,
      this.categoriaProduto});

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      marca: json['marca'],
      unidade: json['unidade'],
      tipoProduto: json['tipoProduto'],
      nome: json['nome'],
      valor: json['valor'],
      categoriaProduto: json['categoriaProduto'] != null
          ? CategoriaProduto.fromJson(json['categoriaProduto'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marca': marca,
      'unidade': unidade,
      'tipoProduto': tipoProduto,
      'nome': nome,
      'valor': valor,
      'categoriaProduto':
          categoriaProduto != null ? categoriaProduto!.toJson() : null,
    };
  }
}
