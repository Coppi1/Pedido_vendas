import 'package:projeto_pedido_vendas/dtos/cliente_dto.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';

class Cliente {
  int? id;
  String? nome;
  String? endereco;
  String? cidade;
  String? nmrCpfCnpj;
  Vendedor? vendedor;

  Cliente({
    this.id,
    this.cidade,
    this.endereco,
    this.nome,
    this.nmrCpfCnpj,
    this.vendedor,
  });

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

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      cidade: json['cidade'],
      nmrCpfCnpj: json['nmrCpfCnpj'],
      vendedor:
          json['vendedor'] != null ? Vendedor.fromJson(json['vendedor']) : null,
    );
  }

  factory Cliente.fromClienteDTO(ClienteDTO dto) {
    return Cliente(
      id: dto.id,
      nome: dto.nome,
      endereco: dto.endereco,
      cidade: dto.cidade,
      nmrCpfCnpj: dto.nmrCpfCnpj,
      vendedor:
          dto.vendedor != null ? Vendedor.fromVendedorDTO(dto.vendedor!) : null,
    );
  }
}
