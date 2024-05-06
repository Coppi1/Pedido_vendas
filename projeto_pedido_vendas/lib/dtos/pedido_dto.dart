import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/dtos/vendedor_dto.dart';

class PedidoDTO {
  int? id;
  String
      dataPedido; // Mudança de DateTime para String para fins de serialização
  String observacao;
  String formaPagamento;
  ClienteDTO cliente;
  VendedorDTO vendedor;

  PedidoDTO({
    this.id,
    required this.dataPedido,
    required this.observacao,
    required this.formaPagamento,
    required this.cliente,
    required this.vendedor,
  });

  factory PedidoDTO.fromJson(Map<String, dynamic> json) {
    return PedidoDTO(
      id: json['id'],
      dataPedido: json['dataPedido'],
      observacao: json['observacao'],
      formaPagamento: json['formaPagamento'],
      cliente: ClienteDTO.fromJson(json['cliente']),
      vendedor: VendedorDTO.fromJson(json['vendedor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataPedido': dataPedido,
      'observacao': observacao,
      'formaPagamento': formaPagamento,
      'cliente': cliente.toJson(),
      'vendedor': vendedor.toJson(),
    };
  }
}
