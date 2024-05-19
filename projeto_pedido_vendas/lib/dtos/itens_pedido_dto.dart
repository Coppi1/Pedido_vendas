import 'package:projeto_pedido_vendas/dtos/pedido_dto.dart';
import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';

class ItensDTO {
  int? id;
  PedidoDTO? pedido;
  ProdutoDTO? produto; // Usando ProdutoDTO para manter a consistência com o DTO
  int? quantidade;
  double? valorTotal;

  ItensDTO({
    this.id,
    this.pedido,
    this.produto,
    this.quantidade,
    this.valorTotal,
  });

  factory ItensDTO.fromJson(Map<String, dynamic> json) {
    return ItensDTO(
      id: json['id'],
      pedido: PedidoDTO.fromJson(json['pedido']),
      produto:
          ProdutoDTO.fromJson(json['produto']), // Deserializando o ProdutoDTO
      quantidade: json['quantidade'],
      valorTotal: json['valorTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedidoId': pedido?.toJson(),
      'produto': produto?.toJson(), // Serializando o ProdutoDTO
      'quantidade': quantidade,
      'valorTotal': valorTotal,
    };
  }

  factory ItensDTO.fromItens(Itens itens) {
    // Verifica se itens.produto é nulo e decide como lidar com isso
    ProdutoDTO? produto = itens.produto != null
        ? ProdutoDTO.fromItens(itens.produto!)
        : ProdutoDTO();

    PedidoDTO? pedido =
        itens.pedido != null ? PedidoDTO.fromItens(itens.pedido!) : PedidoDTO();

    return ItensDTO(
      id: itens.id,
      pedido: pedido,
      produto: produto, // Usa o ProdutoDTO criado ou padrão
      quantidade: itens.quantidade,
      valorTotal: itens.valorTotal,
    );
  }
}
