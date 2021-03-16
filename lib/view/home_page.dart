import 'package:flutter/material.dart';
import 'package:flutter_form_cep/model/cliente.dart';
import 'package:flutter_form_cep/view/cliente_form.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    var clientes = [
      {
        "id": 1,
        "nome": "Gabriel",
        "email": "email@email.com",
        "cpf": "123.234.456-90",
        "cep": 13000000,
        "endereco": "rua grow",
        "numero": "s/n",
        "bairro": "flutter",
        "cidade": "dart",
        "uf": "DF",
        "pais": "google"
      },
      {
        "id": 2,
        "nome": "Edson",
        "email": "email@email.com",
        "cpf": "321.432.432-90",
        "cep": 18000000,
        "endereco": "rua dev",
        "numero": "12",
        "bairro": "flutter",
        "cidade": "dart",
        "uf": "DF",
        "pais": "google"
      },
      {
        "id": 3,
        "nome": "Thobias",
        "email": "tho@email.com",
        "cpf": "654.543.222-22",
        "cep": 18300000,
        "endereco": "rua gdev",
        "numero": "132",
        "bairro": "flutter",
        "cidade": "dart",
        "uf": "DF",
        "pais": "google"
      },
      {
        "id": 4,
        "nome": "Fabio",
        "email": "email@fabio.com",
        "cpf": "001.002.003-00",
        "cep": 18900000,
        "endereco": "rua dev sr",
        "numero": "123",
        "bairro": "flutter",
        "cidade": "dart",
        "uf": "DF",
        "pais": "google"
      }
    ].map((e) => Cliente.fromMap(e)).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Listagem do Formulário'),),
      body: Container(
          child: _list(clientes)
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('+'),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ClienteFormPage();
          }));
        },
      ),
    );
  }

  _list(List<Cliente> clientes) {
    return ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (_, index){
          Cliente c = clientes[index];
          return Dismissible(
            key: ValueKey(c.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction){
              ScaffoldMessenger.of(_).showSnackBar(
                SnackBar(content: Text(
                  'Cliente ${c.nome} removido',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return ClienteFormPage(cliente: c);
                }));
              },
              leading: CircleAvatar(
                child: Image.network('https://controlacesta-images.s3.us-east-2.amazonaws.com/semimagem.jpg'),
              ),
              title: Text(c.nome),
              subtitle: Text('${c.endereco}, ${c.numero} - ${c.bairro}'),
              trailing: Text(c.email),
            ),
          );
        });
  }
}