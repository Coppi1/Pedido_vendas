import 'package:projeto_pedido_vendas/dtos/categoria_produto_dto.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';

class ProdutoDTO {
  int? id;
  String? marca;
  String? unidade;

  String? nome;
  double? valor;
  CategoriaProdutoDTO? categoriaProduto;

  ProdutoDTO({
    this.id,
    this.marca,
    this.unidade,
    this.nome,
    this.valor,
    this.categoriaProduto,
  });

  factory ProdutoDTO.fromJson(Map<String, dynamic> json) {
    return ProdutoDTO(
      id: json['id'],
      marca: json['marca'],
      unidade: json['unidade'],
      nome: json['nome'],
      valor: json['valor'],
      categoriaProduto: json['categoriaProduto'] != null
          ? CategoriaProdutoDTO.fromJson(json['categoriaProduto'])
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
          categoriaProduto != null ? categoriaProduto!.toJson() : null,
    };
  }

  factory ProdutoDTO.fromProduto(Produto produto) {
    return ProdutoDTO(
      id: produto.id,
      marca: produto.marca,
      unidade: produto.unidade,
      nome: produto.nome,
      valor: produto.valor,
      categoriaProduto: produto.categoriaProduto != null
          ? CategoriaProdutoDTO.fromCategoriaProduto(produto.categoriaProduto!)
          : null,
    );
  }
}
