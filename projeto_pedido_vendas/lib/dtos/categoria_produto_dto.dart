class CategoriaProdutoDTO {
  int? id;
  String? descricao;

  CategoriaProdutoDTO({this.id, this.descricao});

  factory CategoriaProdutoDTO.fromJson(Map<String, dynamic> json) {
    return CategoriaProdutoDTO(
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
