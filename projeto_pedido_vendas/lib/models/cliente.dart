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
}
