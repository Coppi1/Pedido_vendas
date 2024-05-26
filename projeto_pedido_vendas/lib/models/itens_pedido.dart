import 'package:projeto_pedido_vendas/dtos/itens_pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/models/pedido.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';

class ItensPedido {
  int? id;
  Pedido pedido;
  Produto produto;
  int? quantidade;
  double? valorTotal;

  ItensPedido(
      {required this.produto,
      required this.pedido,
      required this.quantidade,
      required this.valorTotal,
      this.id});

  factory ItensPedido.fromItensPedidoDTO(ItensPedidoDTO dto) {
    return ItensPedido(
      produto: Produto.fromDto(dto.produto!),
      pedido: Pedido.fromPedidoDTO(dto.pedido!),
      quantidade: dto.quantidade,
      valorTotal: dto.valorTotal,
    );
  }

  factory ItensPedido.fromJson(Map<String, dynamic> json) {
    return ItensPedido(
      id: json['id'],
      produto: Produto.fromJson(json['produto']),
      pedido: Pedido.fromJson(json['pedido']),
      quantidade: json['quantidade'],
      valorTotal: json['valorTotal'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produto': produto.toJson(),
      'pedido': pedido.toJson(),
      'quantidade': quantidade,
      'valorTotal': valorTotal,
    };
  }
}
