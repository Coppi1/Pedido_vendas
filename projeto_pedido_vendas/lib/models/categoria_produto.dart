class CategoriaProduto {
  int? id;
  String? descricao;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }

  CategoriaProduto({this.id, required this.descricao});

  factory CategoriaProduto.fromJson(Map<String, dynamic> json) {
    return CategoriaProduto(
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
