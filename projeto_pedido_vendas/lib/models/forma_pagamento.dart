class FormaPagamento {
  int? id;
  String? descricao;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }

  FormaPagamento({this.id, required this.descricao});
}
