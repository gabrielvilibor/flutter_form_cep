import 'package:flutter_form_cep/database/my_db.dart';
import 'package:flutter_form_cep/model/cliente.dart';

class ClienteRepository{

  MyDb _myDb;

  ClienteRepository(this._myDb);

  Future<bool> save(Cliente c) async {
    try {
      final instance = await _myDb.getInstance();

      final id = await instance.insert('clientes', c.toMap());
      print('cliente id: $id');

      return id > 0;
    } catch (e) {
      print(e);
      throw 'Erro ao inserir o cliente';
    }
  } // fim save

  Future<List<Cliente>> get() async {
    try {
      final instance = await _myDb.getInstance();

      final result = await instance.query('clientes');

      final clientes = result.map((user) => Cliente.fromMap(user)).toList();

      return clientes;
    } catch (e) {
      print(e);
      throw 'Erro ao recuperar os clientes';
    }
  } // fim list all

  Future<bool> update(Cliente c) async {
    try {
      final instance = await _myDb.getInstance();

      final id = await instance.update('clientes', c.toMap(), where: 'id = ?', whereArgs: [c.id]);
      print('cliente atualizado id: $id');

      return id > 0;
    } catch (e) {
      print(e);
      throw 'Erro ao atualizar o cliente';
    }
  } // fim save

  Future<bool> delete(Cliente cliente) async {
    try {
      final instance = await _myDb.getInstance();

      final result = await instance.delete(
        'clientes',
        where: 'id = ?',
        whereArgs: [cliente.id],
      );

      return result > 0;
    } catch (e) {
      print(e);
      throw 'Erro ao excluir o cliente';
    }
  }
}