class VendedorDTO {
  int? id;
  String? nome;

  VendedorDTO({this.id, this.nome});

  factory VendedorDTO.fromJson(Map<String, dynamic> json) {
    return VendedorDTO(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
