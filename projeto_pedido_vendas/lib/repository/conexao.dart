import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Conexao {
  static const _dbname = "pedido.db";
  static const _sqlScriptPedido =
      'CREATE TABLE pedido(id INTEGER PRIMARY KEY AUTOINCREMENT, dataPedido TEXT, observacao TEXT, formaPagamento TEXT, sincronizado INTEGER)';
  static const _sqlScriptProduto =
      'CREATE TABLE produto(id INTEGER PRIMARY KEY AUTOINCREMENT, marca TEXT, unidade TEXT, tipoProduto TEXT, nome TEXT, valor REAL)';
  static const _sqlScriptCliente =
      'CREATE TABLE cliente(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, endereco TEXT, cidade TEXT, nmrCpfCnpj TEXT, vendedorId INTEGER)';
  static const _sqlScriptVendedor =
      'CREATE TABLE vendedor(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT)';

  static const tablePedido = 'pedido';
  static const tableProduto = 'produto';
  static const tableCliente = 'cliente';
  static const tableVendedor = 'vendedor';

  //singleton
  Conexao._privateConstructor();
  static final Conexao instance = Conexao._privateConstructor();

  // tem somente uma referência ao banco de dados - com safenull
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await initDB();
  }

  Future<Database> initDB() async {
    // instancia o db na primeira vez que for acessado
    Future<void> createTables(Database db) async {
      await db.execute(_sqlScriptPedido);
      await db.execute(_sqlScriptProduto);
      await db.execute(_sqlScriptCliente);
      await db.execute(_sqlScriptVendedor);
    }

    return openDatabase(
      join(await getDatabasesPath(), _dbname),
      onCreate: (db, version) {
        return createTables(db);
      },
      version: 1,
    );
  }

  Future<bool> tableExists(String tableName) async {
    final db = await Conexao.instance.database;
    final result = await db
        .query('sqlite_master', where: 'name = ?', whereArgs: [tableName]);
    return result.isNotEmpty;
  }
}
