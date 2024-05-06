import 'package:projeto_pedido_vendas/dtos/categoria_produto_dto.dart';

class ProdutoDTO {
  int? id;
  String? marca;
  String? unidade;
  String? tipoProduto;
  String nome;
  double? valor;
  CategoriaProdutoDTO? categoriaProduto;

  ProdutoDTO({
    this.id,
    this.marca,
    this.unidade,
    this.tipoProduto,
    required this.nome,
    this.valor,
    this.categoriaProduto,
  });

  factory ProdutoDTO.fromJson(Map<String, dynamic> json) {
    return ProdutoDTO(
      id: json['id'],
      marca: json['marca'],
      unidade: json['unidade'],
      tipoProduto: json['tipoProduto'],
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
      'tipoProduto': tipoProduto,
      'nome': nome,
      'valor': valor,
      'categoriaProduto':
          categoriaProduto != null ? categoriaProduto!.toJson() : null,
    };
  }
}
