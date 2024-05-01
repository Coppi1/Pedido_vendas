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
  }

  // Inserir dados iniciais
  await db.insert('cliente', {
    'nome': 'João Silva',
    'endereco': 'Rua das Flores, 123',
    'cidade': 'São Paulo',
    'nmrCpfCnpj': '123.456.789-00',
    'vendedorId': 1, // Supondo que você tenha um vendedor com ID 1
  });

  // Repita o processo de inserção para outros clientes conforme necessário
}
