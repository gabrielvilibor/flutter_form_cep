import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_cep/controller/buscacep_mobx.dart';
import 'package:flutter_form_cep/database/my_db.dart';
import 'package:flutter_form_cep/model/buscacep.dart';
import 'package:flutter_form_cep/model/cliente.dart';
import 'package:flutter_form_cep/repositories/db/cliente.repository.dart';
import 'package:flutter_form_cep/repositories/input_text.dart';
import 'package:flutter_form_cep/view/home_page.dart';
import 'package:image_picker/image_picker.dart';

class ClienteFormPage extends StatefulWidget {

  Cliente? cliente;

  ClienteFormPage({this.cliente});

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<ClienteFormPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode myFocusNode = FocusNode();

  final tNome = TextEditingController();
  final tEmail = TextEditingController();
  final tCPF = TextEditingController();
  final tCEP = TextEditingController();
  final tEndereco = TextEditingController();
  final tNum = TextEditingController();
  final tBairro = TextEditingController();
  final tCidade = TextEditingController();
  final tUF = TextEditingController();
  final tPais = TextEditingController();

  Cliente? get c => widget.cliente;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(c != null){
      tNome.text = c!.nome.toString();
      tEmail.text = c!.email.toString();
      tCPF.text = c!.cpf.toString();
      tCEP.text = c!.cep.toString();
      tEndereco.text = c!.endereco.toString();
      tNum.text = c!.numero.toString();
      tBairro.text = c!.bairro.toString();
      tCidade.text = c!.cidade.toString();
      tUF.text = c!.uf.toString();
      tPais.text = c!.pais.toString();
    }
  }

  final cliRepo = ClienteRepository(new MyDb());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de cadastro', style: TextStyle(color: Colors.white)),
      ),
      body: _body(c),
    );
  }

  _body(Cliente? c) {
    return SingleChildScrollView(
      child: Form(
        key: this._formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: _onClickFoto,
                child: CircleAvatar(
                  key: UniqueKey(),
                  radius: 60,
                  backgroundImage:
                  NetworkImage('https://controlacesta-images.s3.us-east-2.amazonaws.com/semimagem.jpg'),
                ),
              ),
            ),
            Text(
              "Clique na imagem para tirar uma foto",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: InputText("Nome Completo", tNome, validator: _validate),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: InputText("E-mail", tEmail, validator: _validate, keyboardType: TextInputType.emailAddress),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: InputText("CPF", tCPF, validator: _validate, keyboardType: TextInputType.number),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(flex: 1, child: InputText("CEP", tCEP, validator: _validate, keyboardType: TextInputType.number)),
                  Expanded(flex: 1, child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.search),
                          tooltip: 'Buscar Cep',
                          onPressed: () async{
                            BuscaCep bc = await _buscaCep();
                            if(bc != null){
                            setState(() {
                              tEndereco.text = bc.logradouro!;
                              tCEP.text = bc.cep!;
                              tBairro.text = bc.bairro!;
                              tCidade.text = bc.localidade!;
                              tUF.text = bc.uf!;
                              tPais.text = 'Brasil';

                              myFocusNode.requestFocus();
                            });}else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(
                                  'CEP não encontrado',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ), Text('Buscar Cep', style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Row(
              children: [
                Expanded(flex: 2, child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputText("Endereço", tEndereco, validator: _validate),
                )),
                Expanded(flex: 1, child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputText("Nº", tNum, validator: _validate, myFocusNode: myFocusNode),
                ))
              ],
            ),
            Row(
              children: [
                Expanded(flex: 1, child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputText("Bairro", tBairro, validator: _validate),
                )),
                Expanded(flex: 1, child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputText("Cidade", tCidade, validator: _validate),
                ))
              ],
            ),
            Row(
              children: [
                Expanded(flex: 1, child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputText("UF", tUF, validator: _validate),
                )),
                Expanded(flex: 1, child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputText("País", tPais, validator: _validate),
                ))
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 64, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Button(_onClickSalvar, c == null ? 'Cadastrar' : 'Editar'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String? _validate(String? value) {
    if (value!.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  _onClickSalvar() {
    if (!_formKey.currentState!.validate()) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          'Existe um erro em seu formulário',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }

    Cliente newCli = new Cliente();

    newCli.nome = tNome.text;
    newCli.cpf = tCPF.text;
    newCli.cep = int.tryParse(tCEP.text) ?? 0;
    newCli.email = tEmail.text;
    newCli.endereco = tEndereco.text;
    newCli.numero = tNum.text;
    newCli.bairro = tBairro.text;
    newCli.cidade = tCidade.text;
    newCli.uf = tUF.text;
    newCli.pais = tPais.text;

    if(c != null){
      cliRepo.update(newCli);
    }else{
      cliRepo.save(newCli);
    }


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('Dados salvos'),
            actions: <Widget>[
              OutlinedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return HomePage();
                  }));
                },
              )
            ],
          ),
        );
      },
    );

  }

  Future<BuscaCep> _buscaCep() async{

    String cep = tCEP.text;
    var mobx = BuscaCepMobx();

    BuscaCep bc = (await mobx.buscaCep(cep))!;

    return bc;

  }

  _onClickFoto() async{
    var file = await ImagePicker().getImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
     c!.foto = file!.path;
    });
  }
}

Button(Function() function, String text) {
  return OutlinedButton(
      child: Text(text, style: TextStyle(fontSize: 16),),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.red, width: 1),
      ),
      onPressed: function);
}


