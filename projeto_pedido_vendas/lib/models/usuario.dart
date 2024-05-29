// lib/models/usuario.dart
class Usuario {
  int id;
  String email;
  String senha;

  Usuario({required this.id, required this.email, required this.senha});

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      email: map['email'],
      senha: map['senha'],
    );
  }
}
