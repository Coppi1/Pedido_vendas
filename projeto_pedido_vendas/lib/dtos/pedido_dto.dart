import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_validate_mixing.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/pedido.dart';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';
import 'package:projeto_pedido_vendas/models/produto.dart'; // Importe a classe Itens aqui

class PedidoDTO with PedidoValidate {
  int? id;
  DateTime dataPedido;
  String observacao;
  String formaPagamento;
  bool? sincronizado;
  Itens itens; // Agora armazena diretamente um objeto Itens

  PedidoDTO({
    this.id,
    required this.dataPedido,
    required this.observacao,
    required this.formaPagamento,
    required this.itens, // Agora recebe diretamente um objeto Itens
  });

  // Método para converter de JSON para DTO
  factory PedidoDTO.fromJson(Map<String, dynamic> json) {
    final List<dynamic> produtosJson = json['produtos'];
    final List<Produto> produtosList = produtosJson
        .map((produtoJson) => Produto.fromJson(produtoJson))
        .toList();
    final Itens itens = Itens(produtos: produtosList);

    return PedidoDTO(
      id: json['id'] ?? '',
      dataPedido: DateTime.parse(json['dataPedido']),
      observacao: json['observacao'] ?? '',
      formaPagamento: json['formaPagamento'] ?? '',
      itens: itens, // Atualizado para receber um objeto Itens
    );
  }

  // Método para converter de DTO para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataPedido': dataPedido.toIso8601String(),
      'observacao': observacao,
      'formaPagamento': formaPagamento,
      'sincronizado': sincronizado,
      'produtos': itens.produtos
          .map((produto) => produto.toJson())
          .toList(), // Converta os produtos de Itens para JSON
    };
  }

  @override
  String toString() {
    return 'PedidoDTO(id: $id, dataPedido: $dataPedido, observacao: $observacao, formaPagamento: $formaPagamento, sincronizado: $sincronizado, itens: $itens)';
  }
}
