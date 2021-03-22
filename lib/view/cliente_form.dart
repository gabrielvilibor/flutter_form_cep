import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_cep/controller/buscacep_mobx.dart';
import 'package:flutter_form_cep/model/buscacep.dart';
import 'package:flutter_form_cep/model/cliente.dart';
import 'package:flutter_form_cep/repositories/input_text.dart';
import 'package:image_picker/image_picker.dart';

class ClienteFormPage extends StatefulWidget {

  Cliente cliente;

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

  File _file;

  Cliente get c => widget.cliente;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de cadastro', style: TextStyle(color: Colors.white)),
      ),
      body: _body(),
    );
  }

  _body() {
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
                  backgroundImage: _file != null ? FileImage(_file) : c == null ?
                  NetworkImage('https://controlacesta-images.s3.us-east-2.amazonaws.com/semimagem.jpg') :
                  NetworkImage(c.foto),
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
                              tEndereco.text = bc.logradouro;
                              tCEP.text = bc.cep;
                              tBairro.text = bc.bairro;
                              tCidade.text = bc.localidade;
                              tUF.text = bc.uf;
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
                    child: Button(_onClickSalvar, 'Cadastrar'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _validate(String value) {
    if (value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  _onClickSalvar() {
    if (!_formKey.currentState.validate()) {
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

    String nome = tNome.text;
    String cpf = tCPF.text;
    String cep = tCEP.text;
    String email = tEmail.text;
    String endereco = tEndereco.text;
    String numero = tNum.text;
    String bairro = tBairro.text;
    String cidade = tCidade.text;
    String uf = tUF.text;
    String pais = tPais.text;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('Dados salvos'),
            actions: <Widget>[
              Text('Seu nome é $nome'),
              Text('CPF $cpf'),
              Text('E-mail: $email'),
              Text('CEP $cep'),
              Text('Endereço: $endereco, $numero - $bairro'),
              Text('Cidade $cidade - $uf - $pais'),
              OutlinedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
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

    BuscaCep bc = await mobx.buscaCep(cep);

    return bc;

  }

  _onClickFoto() async{
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this._file = file;
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


