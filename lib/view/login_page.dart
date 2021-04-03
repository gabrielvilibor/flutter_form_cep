import 'package:flutter/material.dart';
import 'package:flutter_form_cep/repositories/input_text.dart';
import 'package:flutter_form_cep/view/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final tEmail = new TextEditingController();
  final tPass = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login/fundonargo.jpg'),
                fit: BoxFit.fitHeight
              )
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: this._formKey,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            key: UniqueKey(),
                            radius: 85,
                            backgroundImage: AssetImage('assets/login/logodeku.png'),
                        ),
                      ),
                      SizedBox(height: 40,),
                      Container(
                          color: Colors.grey[200],
                          child:
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InputText("Usuário/E-mail", tEmail, keyboardType: TextInputType.emailAddress, validator: _validate, color: Theme.of(context).primaryColor),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InputText("Senha", tPass, keyboardType: TextInputType.number, password: true, validator: _validate, color: Theme.of(context).primaryColor),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 60,
                        child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                              side: BorderSide(color: Colors.red, width: 1),
                            ),
                            onPressed: _login,
                            child: Text('Entrar')),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validate(String? value) {
    if (value!.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  _login() {
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

    String email = tEmail.text;
    int pass = int.parse(tPass.text);

    if(email == 'teste@gmail.com' && pass == 321){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return HomePage();
      }));
    }else{
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          'Usuário/Senha inválidos',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
