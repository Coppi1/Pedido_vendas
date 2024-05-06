import 'package:projeto_pedido_vendas/models/categoria_produto.dart';

class CategoriaProdutoDTO {
  int? id;
  String? descricao;

  CategoriaProdutoDTO({this.id, this.descricao});

  factory CategoriaProdutoDTO.fromJson(Map<String, dynamic> json) {
    return CategoriaProdutoDTO(
      id: json['id'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }

  factory CategoriaProdutoDTO.fromCategoriaProduto(
      CategoriaProduto categoriaProduto) {
    return CategoriaProdutoDTO(
      id: categoriaProduto.id,
      descricao: categoriaProduto.descricao,
    );
  }
}
