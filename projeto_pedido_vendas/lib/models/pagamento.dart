class Pagamento {
  int? id;
  double valorTotal;
  double desconto;

  factory Pagamento.fromJson(Map<String, dynamic> json) {
    return Pagamento(
      id: json['id'],
      valorTotal: json['valorTotal'],
      desconto: json['desconto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valorTotal': valorTotal,
      'desconto': desconto,
    };
  }

  Pagamento({this.id, required this.valorTotal, required this.desconto});
}
