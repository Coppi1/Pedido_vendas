import 'package:projeto_pedido_vendas/models/produto.dart';

class Itens {
  List<Produto> produtos;

  Itens({required this.produtos});

  double calcularValorTotalComDesconto(double descontoPercentual) {
    double valorTotal = 0;
    for (var produto in produtos) {
      valorTotal += produto.valor;
    }
    // Aplica o desconto ao valor total
    valorTotal -= (valorTotal * (descontoPercentual / 100));
    return valorTotal;
  }
}
