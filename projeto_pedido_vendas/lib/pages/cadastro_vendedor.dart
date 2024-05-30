import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:projeto_pedido_vendas/repository/vendedor_dao.dart';
import '../models/vendedor.dart';

class CadastroVendedorPage extends StatefulWidget {
  const CadastroVendedorPage({Key? key}) : super(key: key);

  @override
  _CadastroVendedorPageState createState() => _CadastroVendedorPageState();
}

class _CadastroVendedorPageState extends State<CadastroVendedorPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _showPassword = false; // Estado para controlar a visibilidade da senha

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _cadastrarVendedor() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      String email = _formKey.currentState?.fields['email']?.value ?? '';
      String senha = _formKey.currentState?.fields['senha']?.value ?? '';
      String nome = _formKey.currentState?.fields['nome']?.value ?? '';

      Vendedor vendedor = Vendedor(email: email, senha: senha, nome: nome);
      VendedorDAO vendedorDAO = VendedorDAO();
      int id = await vendedorDAO.insert(vendedor);

      if (id > 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Vendedor cadastrado com sucesso.'),
          duration: Duration(seconds: 1),
        ));
        Navigator.pop(context); // Voltar à página de login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Erro ao cadastrar vendedor.'),
          duration: Duration(seconds: 1),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Vendedor'),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'nome',
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Nome é obrigatório'),
                ]),
              ),
              const SizedBox(height: 20),
              FormBuilderTextField(
                name: 'email',
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Email é obrigatório'),
                  FormBuilderValidators.email(errorText: 'Email inválido'),
                ]),
              ),
              const SizedBox(height: 20),
              FormBuilderTextField(
                name: 'senha',
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: !_showPassword,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Senha é obrigatória'),
                ]),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cadastrarVendedor,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 5,
                ),
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
