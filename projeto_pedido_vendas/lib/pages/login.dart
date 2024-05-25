// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../repository/usuario_dao.dart';
import '../dtos/usuario_dto.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      UsuarioDTO usuarioDTO = UsuarioDTO(email: _emailController.text, senha: _senhaController.text);
      UsuarioRepository usuarioRepository = UsuarioRepository();
      Usuario? usuario = await usuarioRepository.obterUsuarioPorEmail(usuarioDTO.email);

      if (usuario!= null && usuario.senha == usuarioDTO.senha) {
        // Login bem-sucedido
        print("Login realizado com sucesso!");
      } else {
        // Falha no login
        print("Falha no login.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu email.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira sua senha.';
                }
                return null;
              },
            ),
            ElevatedButton(onPressed: _login, child: const Text('Entrar'))
          ],
        ),
      ),
    );
  }
}
