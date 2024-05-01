import 'package:projeto_pedido_vendas/models/produto.dart'; // Certifique-se de importar a classe Produto aqui

class ItensDTO {
  List<Map<String, dynamic>>
      produtos; // Lista de Mapas para representar os produtos

  ItensDTO({
    required this.produtos,
  });

  // Método para converter de JSON para DTO
  factory ItensDTO.fromJson(List<dynamic> json) {
    final List<Map<String, dynamic>> produtosList =
        json.cast<Map<String, dynamic>>();

    return ItensDTO(
      produtos: produtosList,
    );
  }

  // Método para converter de DTO para JSON
  List<dynamic> toJson() {
    return produtos;
  }
}