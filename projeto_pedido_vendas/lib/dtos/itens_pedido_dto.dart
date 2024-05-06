import 'package:projeto_pedido_vendas/dtos/produto_dto.dart';
import 'package:projeto_pedido_vendas/models/itens_pedido.dart';
import 'package:projeto_pedido_vendas/models/produto.dart'; // Certifique-se de importar a classe Produto aqui

class ItensDTO {
  List<ProdutoDTO> produtos;

  ItensDTO({required this.produtos});

  // Método para converter de ProdutoDTO para ItensDTO
  factory ItensDTO.fromProdutos(List<ProdutoDTO> produtos) {
    return ItensDTO(
      produtos: produtos,
    );
  }

  List<ItensDTO> converterProdutosParaItens(List<ProdutoDTO> produtos) {
    return [ItensDTO.fromProdutos(produtos)];
  }

  factory ItensDTO.fromJson(List<dynamic> json) {
    final List<Map<String, dynamic>> produtosList =
        json.cast<Map<String, dynamic>>();
    final List<ProdutoDTO> produtos = produtosList
        .map((produtoJson) => ProdutoDTO.fromJson(produtoJson))
        .toList();

    return ItensDTO(
      produtos: produtos,
    );
  }

  // Itens toItens() {
  //   List<Produto> listaProdutos = produtos
  //       .map((produtoDto) => Produto.fromJson(produtoDto.toJson()))
  //       .toList();
  //   return Itens(produtos: listaProdutos);
  // }

  List<dynamic> toJson() {
    return produtos.map((produto) => produto.toJson()).toList();
  }
}
