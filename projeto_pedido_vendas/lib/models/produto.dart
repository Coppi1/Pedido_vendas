
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/models/categoria_produto.dart';

class Produto {
  int? id;
  String? marca;
  String? unidade;
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
      required this.nome,
      required this.valor,
      this.categoriaProduto});

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      marca: json['marca'],
      unidade: json['unidade'],
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
      'nome': nome,
      'valor': valor,
      'categoriaProduto':
          categoriaProduto?.toJson(),
    };
  }

  factory Produto.fromDto(ProdutoDTO dto) {
    return Produto(
      id: dto.id,
      marca: dto.marca,
      unidade: dto.unidade,
      nome: dto.nome ?? '',
      valor: dto.valor,
      categoriaProduto: dto.categoriaProduto != null
          ? CategoriaProduto.fromJson(dto.categoriaProduto!.toJson())
          : null,
    );
  }
}
