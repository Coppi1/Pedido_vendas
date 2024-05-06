import 'package:projeto_pedido_vendas/models/vendedor.dart';

class VendedorDTO {
  int? id;
  String? nome;

  VendedorDTO({
    this.id,
    this.nome,
  });

  // Método para converter de VendedorDTO para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  Vendedor toVendedor() {
    return Vendedor(
      id: id,
      nome: nome,
      // outras propriedades...
    );
  }

  // Método para converter de JSON para VendedorDTO
  factory VendedorDTO.fromJson(Map<String, dynamic> json) {
    return VendedorDTO(
      id: json['id'],
      nome: json['nome'],
    );
  }

  // Método para converter de Vendedor para VendedorDTO
  static VendedorDTO fromVendedor(Vendedor vendedor) {
    return VendedorDTO(
      id: vendedor.id,
      nome: vendedor.nome,
    );
  }

  @override
  String toString() {
    return 'VendedorDTO(id: $id, nome: $nome)';
  }
}
