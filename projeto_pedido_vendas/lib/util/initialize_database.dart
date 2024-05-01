import 'package:projeto_pedido_vendas/repository/conexao.dart';

Future<void> initializeDatabase() async {
  // Obter uma instância do banco de dados
  final db = await Conexao.instance.database;

  // Verificar se a tabela já existe
  bool tableExists = await Conexao.instance.tableExists('cliente');

  // Se a tabela não existir, criá-la
  if (!tableExists) {
    await db.execute('''
      CREATE TABLE cliente (
        id INTEGER PRIMARY KEY,
        nome TEXT,
        endereco TEXT,
        cidade TEXT,
        nmrCpfCnpj TEXT,
        vendedorId INTEGER
      )
    ''');

    // Criação da tabela de vendedor
    await db.execute('''
    CREATE TABLE vendedor (
      id INTEGER PRIMARY KEY,
      nome TEXT
    )
  ''');

    // Criação da tabela de produto
    await db.execute('''
    CREATE TABLE produto (
      id INTEGER PRIMARY KEY,
      marca TEXT,
      unidade TEXT,
      tipoProduto TEXT,
      nome TEXT,
      valor REAL
    )
  ''');
  }

  await db.insert('cliente', {
    'nome': 'Chupacabra',
    'endereco': 'Rua das Flores, 123',
    'cidade': 'São Paulo',
    'nmrCpfCnpj': '123.456.789-00',
    'vendedorId': 1, // Supondo que você tenha um vendedor com ID 1
  });

  await db.insert('vendedor', {
    'nome': 'João Vendedor',
  });

  await db.insert('vendedor', {
    'nome': 'Maria Vendedora',
  });

  await db.insert('produto', {
    'marca': 'Marca1',
    'unidade': 'Unidade1',
    'tipoProduto': 'Tipo1',
    'nome': 'Produto1',
    'valor': 10.50,
  });

  await db.insert('produto', {
    'marca': 'Marca2',
    'unidade': 'Unidade2',
    'tipoProduto': 'Tipo2',
    'nome': 'Produto2',
    'valor': 20.75,
  });

  await db.insert('cliente', {
    'nome': 'Zé da Couve',
    'endereco': 'Rua das Flores, 123',
    'cidade': 'São Paulo',
    'nmrCpfCnpj': '123.456.789-00',
    'vendedorId': 1, // Supondo que você tenha um vendedor com ID 1
  });
}
