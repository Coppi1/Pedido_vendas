import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/dtos/pedido_validate_mixing.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/pedido.dart';

class PedidoDTO with PedidoValidate {
  int? id;
  DateTime dataPedido;
  String observacao;
  String formaPagamento;
  bool? sincronizado;
  Map<dynamic, dynamic>? produtos;

  PedidoDTO({
    this.id,
    required this.dataPedido,
    required this.observacao,
    required this.formaPagamento,
    this.produtos,
  });

  // Método para converter de JSON para DTO
  factory PedidoDTO.fromJson(Map<String, dynamic> json) {
    return PedidoDTO(
      id: json['id'] ?? '',
      dataPedido: DateTime.parse(json['dataPedido']),
      observacao: json['observacao'] ?? '',
      formaPagamento: json['formaPagamento'] ?? '',
      produtos: (json['produtos'] as Map<dynamic, dynamic>?)
          ?.map<dynamic, int>((key, value) => MapEntry(key, value as int)),
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
      'produtos': produtos ?? {}, // Fornece um mapa vazio como valor padrão
    };
  }

  @override
  String toString() {
    return 'PedidoDTO(id: $id, dataPedido: $dataPedido, observacao: $observacao, formaPagamento: $formaPagamento, sincronizado: $sincronizado, produtos: $produtos)';
  }
}
