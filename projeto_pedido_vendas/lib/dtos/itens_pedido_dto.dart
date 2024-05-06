class ItensDTO {
  int? id;
  int? pedidoId;
  int? produtoId;
  int? quantidade;
  double? valorTotal;

  ItensDTO({
    this.id,
    this.pedidoId,
    this.produtoId,
    this.quantidade,
    this.valorTotal,
  });

  factory ItensDTO.fromJson(Map<String, dynamic> json) {
    return ItensDTO(
      id: json['id'],
      pedidoId: json['pedidoId'],
      produtoId: json['produtoId'],
      quantidade: json['quantidade'],
      valorTotal: json['valorTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedidoId': pedidoId,
      'produtoId': produtoId,
      'quantidade': quantidade,
      'valorTotal': valorTotal,
    };
  }
}
