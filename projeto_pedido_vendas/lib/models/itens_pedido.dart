import 'package:projeto_pedido_vendas/models/pedido.dart';
import 'package:projeto_pedido_vendas/models/produto.dart';

class Itens {
  int? id;
  Pedido? pedido;
  Produto? produto;
  int? quantidade;
  double? valorTotal;

  Itens(
      {required this.produto,
      required this.pedido,
      required this.quantidade,
      required this.valorTotal,
      this.id});
}
