import 'package:projeto_pedido_vendas/models/cliente.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';

class ClienteDTO {
  int? id;
  String? nome;
  String? endereco;
  String? cidade;
  String? nmrCpfCnpj;
  Vendedor vendedor;

  // Construtor com parâmetros opcionais, tornando-os nullable ou fornecendo valores padrão
  ClienteDTO({
    this.id,
    required this.nome,
    required this.endereco,
    required this.cidade,
    required this.nmrCpfCnpj,
    required this.vendedor,
  });

  // Método para converter de DTO para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'cidade': cidade,
      'nmrCpfCnpj': nmrCpfCnpj,
      'vendedor': vendedor.id,
    };
  }

  // Método para converter de JSON para DTO
  factory ClienteDTO.fromJson(Map<String, dynamic> json) {
    return ClienteDTO(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      cidade: json['cidade'],
      nmrCpfCnpj: json['nmrCpfCnpj'],
      vendedor: json['vendedor'],
    );
  }

  static ClienteDTO fromCliente(Cliente cliente) {
    if (cliente == null) {
      // Trate o caso em que o cliente é null, por exemplo, lançando uma exceção ou retornando um valor padrão
      throw Exception('Cliente não pode ser null');
    }

    Vendedor vendedor =
        cliente.vendedor ?? Vendedor(id: 0, nome: 'Sem vendedor');

    return ClienteDTO(
      id: cliente.id,
      nome: cliente.nome,
      endereco: cliente.endereco,
      cidade: cliente.cidade,
      nmrCpfCnpj: cliente.nmrCpfCnpj,
      vendedor: vendedor, // Agora, vendedor é garantido para não ser null
    );
  }

  Cliente toCliente() {
    return Cliente(
      id: id,
      nome: nome,
      // outras propriedades...
    );
  }

  @override
  String toString() {
    return 'ClienteDTO(id: $id, nome: $nome, endereco: $endereco, cidade: $cidade, nmrCpfCnpj: $nmrCpfCnpj, vendedor: $vendedor)';
  }
}
