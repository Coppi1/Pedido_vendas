import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';

class ItensPedidoDTO {
  int? id;
  PedidoDTO? pedido;
  ProdutoDTO? produto;
  int? quantidade;
  double? valorTotal;

  ItensPedidoDTO({
    this.id,
    this.pedido,
    this.produto,
    this.quantidade,
    this.valorTotal,
  });

  factory ItensPedidoDTO.fromJson(Map<String, dynamic> json) {
    return ItensPedidoDTO(
      id: json['id'],
      pedido: json.containsKey('pedido')
          ? PedidoDTO.fromJson(json['pedido'])
          : null,
      produto: json.containsKey('produto')
          ? ProdutoDTO.fromJson({
              'id': json['id'],
              'nome': json['nome'],
            })
          : null,
      quantidade: json['quantidade'],
      valorTotal: json['valorTotal'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedido': pedido?.toJson(),
      'produto': produto?.toJson(),
      'quantidade': quantidade,
      'valorTotal': valorTotal,
    };
  }
}
