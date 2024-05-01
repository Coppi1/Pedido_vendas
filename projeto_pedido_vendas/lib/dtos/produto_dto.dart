class ProdutoDTO {
  int? id;
  String marca;
  String unidade;
  String tipoProduto;
  String nome;
  double valor;

  ProdutoDTO({
    this.id,
    required this.marca,
    required this.unidade,
    required this.tipoProduto,
    required this.nome,
    required this.valor,
  });

  factory ProdutoDTO.fromJson(Map<String, dynamic> json) {
    return ProdutoDTO(
      id: json['id'],
      marca: json['marca'] ?? '',
      unidade: json['unidade'] ?? '',
      tipoProduto: json['tipoProduto'] ?? '',
      nome: json['nome'] ?? '',
      valor: json['valor'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marca': marca,
      'unidade': unidade,
      'tipoProduto': tipoProduto,
      'nome': nome,
      'valor': valor,
    };
  }

  @override
  String toString() {
    return 'ProdutoDTO(id: $id, marca: $marca, unidade: $unidade, tipoProduto: $tipoProduto, nome: $nome, valor: $valor)';
  }
}
