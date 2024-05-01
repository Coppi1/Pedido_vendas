import 'package:projeto_pedido_vendas/models/produto.dart';

class Pedido {
  String id;
  Map<dynamic, int> produtos;
  DateTime dataPedido;
  String observacao;
  String formaPagamento;
  bool? sincronizado;

  Pedido({
    required this.id,
    required this.produtos,
    required this.dataPedido,
    required this.observacao,
    required this.formaPagamento,
  });

  Map<String, dynamic> toJson() {
    List<Produto> produtosList = [];
    produtos.forEach((key, value) {
      for (var i = 0; i < value; i++) {
        produtosList.add(key);
      }
    });
    return {
      'id': id,
      'produtos': produtosList.map((e) => e.toJson()).toList(),
      'dataPedido': dataPedido.toIso8601String(),
      'observacao': observacao,
      'formaPagamento': formaPagamento,
      'sincronizado': sincronizado,
    };
  }

  // fromJson
  factory Pedido.fromJson(Map<String, dynamic> json) {
    final List<Produto> produtosList = (json['produtos'] as List<dynamic>)
        .map((produtoJson) => Produto.fromJson(produtoJson))
        .toList();

    final Map<int, int> produtos =
        {}; // Usar int como chave para o ID do produto
    for (var produto in produtosList) {
      final produtoId = produto.id;
      produtos.update(produtoId, (value) => (value) + 1, ifAbsent: () => 1);
    }
    final Map<Produto, int> produtosQuantidades = {};
    produtos.forEach((produtoId, quantidade) {
      final produto = produtosList.firstWhere((p) => p.id == produtoId);
      produtosQuantidades[produto] = quantidade;
    });

    return Pedido(
      id: json['id'] ?? "",
      produtos: produtosQuantidades,
      dataPedido: DateTime.parse(json['dataPedido']),
      observacao: json['observacao'],
      formaPagamento: json['formaPagamento'],
      //saidaStatus: SaidaStatus.fromJson(json['saidaStatus']),
    );
  }

  double getValorPedido() {
    double valorPedido = 0.0;
    produtos.forEach((key, value) {
      double valorproduto = (key.valor != null) ? key.valor! : key.valor;
      valorPedido += valorproduto * value;
    });
    return valorPedido;
  }
}
