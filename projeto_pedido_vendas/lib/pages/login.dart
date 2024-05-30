import 'package:flutter/material.dart';
import '../repository/vendedor_dao.dart'; // Importe o DAO do Vendedor
import '../models/vendedor.dart';
import 'cadastro_vendedor.dart';
import 'pedido_cadastro.dart'; // Importe o modelo do Vendedor

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _showPassword = false; // Estado para controlar a visibilidade da senha

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String senha = _senhaController.text;

      VendedorDAO vendedorDAO = VendedorDAO(); // Instancie o DAO do Vendedor
      Vendedor? vendedor = await vendedorDAO.obterVendedorPorEmail(email);

      print('Email: $email');
      print('Senha: $senha');
      print('Vendedor obtido: ${vendedor?.toJson()}');

      if (vendedor != null && vendedor.senha == senha) {
        _emailController.clear();
        _senhaController.clear();

        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Login realizado com sucesso'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          margin: const EdgeInsets.symmetric(horizontal: 20),
        ));

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const PedidoCadastro()));
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Falha no login.')));
      }
    }
  }

  void _navegarParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroVendedorPage()),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        // Centraliza todos os elementos na tela
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Pedido Agil",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white), // Altera o título
                  ),
                  const SizedBox(
                      height: 40), // Adiciona mais espaço abaixo do título
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: _togglePasswordVisibility, // Alterna a visibilidade da senha
                      ),
                    ),
                    obscureText: !_showPassword, // Altera a visibilidade da senha
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Entrar'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Não tem uma conta?"),
                      GestureDetector(
                        onTap: _navegarParaCadastro,
                        child: const Text(
                          "Registre-se",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
