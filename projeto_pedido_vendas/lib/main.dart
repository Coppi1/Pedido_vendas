import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/pages/login.dart';
import 'package:projeto_pedido_vendas/util/initialize_database.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDatabase();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Definindo o tema global do aplicativo
      theme: ThemeData(
        primaryColor: Colors.blue, // Cor de destaque
        fontFamily: 'Roboto', colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green), // Fonte padrão
        // Outras propriedades do tema, se necessário
      ),
      home: const LoginPage(),
      navigatorObservers: [routeObserver], // Observador de rotas
    );
  }
}
