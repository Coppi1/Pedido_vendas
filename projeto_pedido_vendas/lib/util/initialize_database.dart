import 'package:projeto_pedido_vendas/repository/conexao.dart';

Future<void> initializeDatabase() async {
  // Obter uma instância do banco de dados
  final db = await Conexao.instance.database;

  List<String> tableNames = [
    'cliente',
    'vendedor',
    'produto',
    'forma_pagamento',
    'pedido',
    'categoria_produto',
    'itens_pedido',
    'pagamento_pedido'
  ];

  for (String tableName in tableNames) {
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }

  await db.execute('''
    CREATE TABLE pedido (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      dataPedido DATETIME,
      observacao TEXT,
      formaPagamentoId INTEGER,
      clienteId INTEGER,
      vendedorId INTEGER,
      FOREIGN KEY (formaPagamentoId) REFERENCES forma_pagamento (id),
      FOREIGN KEY (clienteId) REFERENCES cliente (id),
      FOREIGN KEY (vendedorId) REFERENCES vendedor (id)
    )
  ''');

  await db.execute('''
    CREATE TABLE categoria_produto (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      descricao TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE cliente (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      endereco TEXT,
      cidade TEXT,
      nmrCpfCnpj TEXT,
      vendedorId INTEGER,
      FOREIGN KEY (vendedorId) REFERENCES vendedor (id)
    )
  ''');

  await db.execute('''
    CREATE TABLE vendedor (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      email TEXT,
      senha TEXT
    )
''');

  await db.execute('''
    CREATE TABLE produto (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      marca TEXT,
      unidade TEXT,
      categoriaProdutoId INTEGER,
      nome TEXT,
      valor REAL,
      FOREIGN KEY (categoriaProdutoId) REFERENCES categoria_produto (id)
    )
  ''');

  await db.execute('''
    CREATE TABLE forma_pagamento (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      descricao TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE itens_pedido (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pedidoId INTEGER,
      produtoId INTEGER,
      quantidade INTEGER,
      valorTotal REAL,
      FOREIGN KEY (pedidoId) REFERENCES pedido (id),
      FOREIGN KEY (produtoId) REFERENCES produto (id)
    )
  ''');

  await db.execute('''
    CREATE TABLE pagamento_pedido (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      parcela INTEGER,
      valorTotal REAL,
      desconto REAL,
      dataVencimento TEXT,
      pedidoId INTEGER,
      FOREIGN KEY (pedidoId) REFERENCES pedido (id)
    )
  ''');

  await db.insert('vendedor', {
    'nome': 'João Vendedor',
    'email': 'joao@example.com',
    'senha': 'senha123',
  });

  await db.insert('vendedor', {
    'nome': 'Vendedor XYZ',
    'email': 'vendedor@teste.com',
    'senha': '123',
  });

  await db.insert('cliente', {
    'nome': 'Chupacabra',
    'endereco': 'Rua das Flores, 123',
    'cidade': 'São Paulo',
    'nmrCpfCnpj': '123.456.789-00',
    'vendedorId': 1,
  });

  await db.insert('cliente', {
    'nome': 'Zé da Couve',
    'endereco': 'Rua das Flores, 123',
    'cidade': 'São Paulo',
    'nmrCpfCnpj': '123.456.789-00',
    'vendedorId': 1,
  });

  await db.insert('forma_pagamento', {
    'descricao': 'Dinheiro',
  });

  await db.insert('forma_pagamento', {
    'descricao': 'Cartão de Crédito',
  });

  await db.insert('forma_pagamento', {
    'descricao': 'Cartão de Débito',
  });

  await db.insert('forma_pagamento', {
    'descricao': 'Boleto Bancário',
  });

  await db.insert('categoria_produto', {
    'descricao': 'Limpeza',
  });

  await db.insert('categoria_produto', {
    'descricao': 'Perfumaria',
  });

  await db.insert('categoria_produto', {
    'descricao': 'Hidraulica',
  });

  await db.insert('categoria_produto', {
    'descricao': 'Elétrica',
  });

  await db.insert('produto', {
    'marca': 'Ajax',
    'unidade': 'Litro',
    'categoriaProdutoId': 1,
    'nome': 'Desinfetante Multiuso',
    'valor': 5.99,
  });

  await db.insert('produto', {
    'marca': 'Natura',
    'unidade': 'Mililitro',
    'categoriaProdutoId': 2,
    'nome': 'Eau de Toilette Feminino',
    'valor': 89.90,
  });

  await db.insert('produto', {
    'marca': 'Tigre',
    'unidade': 'Metro',
    'categoriaProdutoId': 3,
    'nome': 'Tubo PVC',
    'valor': 15.00,
  });

  await db.insert('produto', {
    'marca': 'Philips',
    'unidade': 'Unidade',
    'categoriaProdutoId': 4,
    'nome': 'Lâmpada LED',
    'valor': 12.50,
  });
}
