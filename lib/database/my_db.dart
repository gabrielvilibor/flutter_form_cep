import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDb {
  Database? _instance;

  static final MyDb _database = MyDb._internal();

  MyDb._internal();

  factory MyDb() {
    return _database;
  }

  Future<Database> getInstance() async {
    if (_instance == null) {
      _instance = await _openMyDb();
    }

    return _instance!;
  }

  Future<Database> _openMyDb() async {
    final pathDatabase = await getDatabasesPath();
    final nameDatabase = 'form_cliente.db';
    final database = await openDatabase(
      join(pathDatabase, nameDatabase),
      version: 1,
      onCreate: (db, version) async {
        print('versão $version');

        await db.execute('''
          CREATE TABLE clientes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT,
            cpf TEXT,
            cep INTEGER,
            endereco TEXT,
            numero TEXT,
            bairro TEXT,
            cidade TEXT,
            uf TEXT,
            pais TEXT,
            foto TEXT
          );
        ''');
      }
    );

    return database;
  }
}