// lib/repository/usuario_repository.dart
import '../models/usuario.dart';
import 'conexao.dart';

class UsuarioRepository {
  Future<Usuario?> obterUsuarioPorEmail(String email) async {
    final db = await Conexao.instance.database;
    final maps = await db.query('usuarios', where: 'email =?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
