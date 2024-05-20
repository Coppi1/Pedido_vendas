import 'package:projeto_pedido_vendas/repository/conexao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> initializeDatabase() async {
  // Obter uma instância do banco de dados
  final db = await Conexao.instance.database;

  // await db.execute('ALTER TABLE pedido ADD COLUMN formaPagamentoId INTEGER');

  // Adicionando a coluna clienteId à tabela pedido
  // await db.execute('ALTER TABLE pedido ADD COLUMN vendedorId INTEGER');

  List<String> tableNames = [
    'cliente',
    'vendedor',
    'produto',
    'forma_pagamento',
    'pedido',
    'categoria_produto'
  ];

  // Excluir todas as tabelas existentes
  for (String tableName in tableNames) {
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }

  // Verificar se a tabela cliente já existe
  bool clienteTableExists = await Conexao.instance.tableExists('cliente');

  // Verificar se a tabela vendedor já existe
  bool vendedorTableExists = await Conexao.instance.tableExists('vendedor');

  // Verificar se a tabela produto já existe
  bool produtoTableExists = await Conexao.instance.tableExists('produto');

  // Verificar se a tabela forma_pagamento já existe
  bool formaPagamentoTableExists =
      await Conexao.instance.tableExists('forma_pagamento');

  // Verificar se a tabela pedido já existe
  bool pedidoTableExists = await Conexao.instance.tableExists('pedido');

  bool categoriaProdutoExists =
      await Conexao.instance.tableExists('categoria_produto');

  bool itensPedidoExists = await Conexao.instance.tableExists('itens_pedido');

  // Criar a tabela pedido se ela não existir
  if (!pedidoTableExists) {
    await db.execute('''
    CREATE TABLE pedido (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      dataPedido INTEGER,
      observacao TEXT,
      formaPagamentoId INTEGER,
      clienteId INTEGER,
      vendedorId INTEGER
    )
 ''');
  }

  if (!categoriaProdutoExists) {
    await db.execute('''
    CREATE TABLE categoria_produto (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      descricao TEXT
    )
 ''');
  }

  if (!clienteTableExists) {
    await db.execute('''
      CREATE TABLE cliente (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        endereco TEXT,
        cidade TEXT,
        nmrCpfCnpj TEXT,
        vendedorId INTEGER
      )
    ''');
  }

  if (!vendedorTableExists) {
    await db.execute('''
      CREATE TABLE vendedor (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT
      )
    ''');
  }

  if (!produtoTableExists) {
    await db.execute('''
      CREATE TABLE produto (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        marca TEXT,
        unidade TEXT,
        categoriaProdutoId INTEGER,
        nome TEXT,
        valor REAL
      )
    ''');
  }

  if (!formaPagamentoTableExists) {
    await db.execute('''
      CREATE TABLE forma_pagamento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT
      )
    ''');
  }

  if (!itensPedidoExists) {
    await db.execute('''
      CREATE TABLE itens_pedido (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT
      )
    ''');
  }

  await db.insert('vendedor', {
    'nome': 'João Vendedor',
  });

  await db.insert('vendedor', {
    'nome': 'Vendedo xyz',
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
    'marca': 'Marca1',
    'unidade': 'Unidade1',
    'categoriaProdutoId': 1,
    'nome': 'Produto1',
    'valor': 10.50,
  });

  await db.insert('produto', {
    'marca': 'Marca2',
    'unidade': 'Unidade2',
    'categoriaProdutoId': 2,
    'nome': 'Produto2',
    'valor': 20.75,
  });
}
