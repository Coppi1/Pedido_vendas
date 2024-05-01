import 'package:flutter/material.dart';
import 'package:projeto_pedido_vendas/dtos/vendedor_dto.dart';
import 'package:projeto_pedido_vendas/models/vendedor.dart';
import 'package:projeto_pedido_vendas/repository/vendedor_dao.dart';

class MinhaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VendedorDAO _vendedorDAO = VendedorDAO();

  @override
  void initState() {
    // super.initState();

    _loadVendedores();
  }

  void _loadVendedores() async {
    List<Vendedor> vendedores = await _vendedorDAO.selectAll();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.business, // Ícone da empresa
          color: Colors.blue, // Cor azul
        ),
        onPressed: () {
          // Função para abrir o menu lateral direito
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Emissão de pedidos',
            style: TextStyle(
              color: Colors.blue, // Cor azul
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: ClipOval(
              child: Image.asset(
                'assets/images/user.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover, // Para preencher todo o espaço do círculo
              ),
            ),
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }
}

class MenuLateralEsquerdo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Pedido Ágil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Adicione aqui a função para ir para a tela inicial
            },
          ),
          ListTile(
            leading: Icon(Icons.note_add),
            title: Text('Emitir Pedidos'),
            onTap: () {
              // Adicione aqui a função para ir para a tela de emissão de pedidos
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Pedidos'),
            onTap: () {
              // Adicione aqui a função para ir para a tela de pedidos
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Clientes'),
            onTap: () {
              // Adicione aqui a função para ir para a tela de clientes
            },
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Empresa'),
            onTap: () {
              // Adicione aqui a função para ir para a tela da empresa
            },
          ),
        ],
      ),
    );
  }
}

// class MenuLateralDireito extends StatelessWidget {

//   final VendedorDAO _vendedorDAO = VendedorDAO();
//   List<Vendedor> vendedores = [];

//   @override
//   void initState() {
//     // super.initState();

//     _loadVendedores();
//   }

//   void _loadVendedores() async {
//     List<Vendedor> vendedores = await _vendedorDAO.selectAll();
//   }

//   String? usuarioLogado = vendedores[0].nome;

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.grey[300],
//                         child: ClipOval(
//                           child: Image.asset(
//                             'assets/images/user.png',
//                             width: 75,
//                             height: 75,
//                             fit: BoxFit
//                                 .cover, // Para preencher todo o espaço do círculo
//                           ),
//                         ),
//                       ),
//                       onPressed: () {
//                         Scaffold.of(context).openEndDrawer();
//                       },
//                     ),
//                     SizedBox(
//                         width:
//                             15), // Adiciona um espaço de 15 pixels entre o avatar e o texto
//                     Column(
//                       children: [
//                         Text(
//                           'Gerente',
//                           style: TextStyle(
//                             color: Colors.grey[800], // Cor preta mais fraca
//                             fontSize: 16.0, // Tamanho de fonte um pouco menor
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           'Coppi',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.notifications),
//             title: Text('Notificações'),
//             onTap: () {
//               // Adicione aqui a função para as notificações
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.edit),
//             title: Text('Editar Conta'),
//             onTap: () {
//               // Adicione aqui a função para editar a conta
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.help),
//             title: Text('Ajuda e Suporte'),
//             onTap: () {
//               // Adicione aqui a função para ajuda e suporte
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.settings),
//             title: Text('Opções'),
//             onTap: () {
//               // Adicione aqui a função para ir para a tela de opções
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.exit_to_app),
//             title: Text('Sair'),
//             onTap: () {
//               // Adicione aqui a função para sair
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

class MenuLateralDireito extends StatelessWidget {
  final VendedorDAO _vendedorDAO = VendedorDAO();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Vendedor>>(
      future: _loadVendedores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Mostrar um indicador de carregamento enquanto os dados estão sendo carregados
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar os vendedores: ${snapshot.error}');
        } else {
          String usuarioLogado = snapshot.data != null &&
                  snapshot.data!.isNotEmpty
              ? snapshot.data![6].nome ?? 'Nome do Vendedor Padrão'
              : 'Nome do Vendedor Padrão'; // Se houver vendedores, use o nome do primeiro vendedor, caso contrário, use um nome padrão
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          IconButton(
                            icon: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[300],
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/user.png',
                                  width: 75,
                                  height: 75,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          ),
                          SizedBox(
                              width:
                                  15), // Adiciona um espaço de 15 pixels entre o avatar e o texto
                          Column(
                            children: [
                              Text(
                                'Gerente',
                                style: TextStyle(
                                  color:
                                      Colors.grey[800], // Cor preta mais fraca
                                  fontSize:
                                      16.0, // Tamanho de fonte um pouco menor
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                usuarioLogado,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notificações'),
                  onTap: () {
                    // Adicione aqui a função para as notificações
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Editar Conta'),
                  onTap: () {
                    // Adicione aqui a função para editar a conta
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Ajuda e Suporte'),
                  onTap: () {
                    // Adicione aqui a função para ajuda e suporte
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Opções'),
                  onTap: () {
                    // Adicione aqui a função para ir para a tela de opções
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sair'),
                  onTap: () {
                    // Adicione aqui a função para sair
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<List<Vendedor>> _loadVendedores() async {
    try {
      return await _vendedorDAO.selectAll();
    } catch (e) {
      print('Erro ao carregar vendedores: $e');
      return [];
    }
  }
}
