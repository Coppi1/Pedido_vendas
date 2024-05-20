import 'package:projeto_pedido_vendas/dtos/vendedor_dto.dart';
import 'package:projeto_pedido_vendas/models/cliente.dart';

class ClienteDTO {
  int? id;
  String? nome;
  String? endereco;
  String? cidade;
  String? nmrCpfCnpj;
  VendedorDTO? vendedor;

  ClienteDTO({
    this.id,
    this.cidade,
    this.endereco,
    this.nome,
    this.nmrCpfCnpj,
    this.vendedor,
  });

  factory ClienteDTO.fromJson(Map<String, dynamic> json) {
    return ClienteDTO(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      cidade: json['cidade'],
      nmrCpfCnpj: json['nmrCpfCnpj'],
      vendedor: json['vendedor'] != null
          ? VendedorDTO.fromJson(json['vendedor'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'cidade': cidade,
      'nmrCpfCnpj': nmrCpfCnpj,
      'vendedor': vendedor != null ? vendedor!.toJson() : null,
    };
  }

  factory ClienteDTO.fromCliente(Cliente cliente) {
    return ClienteDTO(
      id: cliente.id,
      nome: cliente.nome,
      endereco: cliente.endereco,
      cidade: cliente.cidade,
      nmrCpfCnpj: cliente.nmrCpfCnpj,
      vendedor: cliente.vendedor != null
          ? VendedorDTO.fromVendedor(cliente.vendedor!)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'cidade': cidade,
      'nmrCpfCnpj': nmrCpfCnpj,
      'vendedor': vendedor != null ? vendedor!.toMap() : null,
    };
  }
}
