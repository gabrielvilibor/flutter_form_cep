import 'package:flutter/material.dart';
import 'package:flutter_form_cep/database/my_db.dart';
import 'package:flutter_form_cep/model/cliente.dart';
import 'package:flutter_form_cep/repositories/db/cliente.repository.dart';
import 'package:flutter_form_cep/view/cliente_form.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final cliRepo = ClienteRepository(MyDb());
  Future<List<Cliente>>? listClientes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetch();
  }

  _fetch() async {
    setState(() {
      listClientes = cliRepo.get();
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Listagem do Formulário'),),
      body: Container(
          child: _body()
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sair"),
              onTap: () {
                print('Sair');
              },
            ),
          ],
        ),
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

  _body(){
    return FutureBuilder(
        future: listClientes,
        builder: (_, AsyncSnapshot<List<Cliente>> snapshot){

          final clientes = snapshot.data ?? [];

          return RefreshIndicator(onRefresh: () => _fetch(), 
            child: _list(clientes));

        });
  }

  _list(List<Cliente> clientes) {
    return ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (_, index){
          Cliente c = clientes[index];
          return Dismissible(
            key: ValueKey(c.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Excluindo o cliente...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            onDismissed: (direction){
              cliRepo.delete(c);
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
              leading: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(c.foto ?? 'https://controlacesta-images.s3.us-east-2.amazonaws.com/semimagem.jpg'),
                ),
              ),
              title: Text(c.nome!),
              subtitle: Text('${c.endereco}, ${c.numero} - ${c.bairro}'),
              trailing: Text(c.email!),
            ),
          );
        });
  }
}