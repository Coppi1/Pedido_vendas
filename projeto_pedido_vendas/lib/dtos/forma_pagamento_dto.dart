class FormaPagamentoDTO {
  int? id;
  String? descricao;

  FormaPagamentoDTO({this.id, this.descricao});

  factory FormaPagamentoDTO.fromJson(Map<String, dynamic> json) {
    return FormaPagamentoDTO(
      id: json['id'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }
}
