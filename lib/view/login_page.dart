import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_form_cep/controller/user_login.dart';
import 'package:flutter_form_cep/repositories/input_text.dart';
import 'package:flutter_form_cep/view/home_page.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    final userLogin = UserLogin();
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
                  child: ValueListenableBuilder(
                    valueListenable: userLogin.isLoading,
                      builder: (_, isLoading, __) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                key: UniqueKey(),
                                radius: 65,
                                backgroundImage:
                                    AssetImage('assets/login/logodeku.png'),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InputText("Usu??rio/E-mail", tEmail,
                                      keyboardType: TextInputType.emailAddress, validator: _validate, color: Theme.of(context).primaryColor),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            color: Colors.grey[200],
                            child: InputText("Senha", tPass, keyboardType: TextInputType.number, password: true, validator: _validate, color: Theme.of(context).primaryColor)),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          child: ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                side: BorderSide(color: Colors.red, width: 1),
                              ),
                              onPressed: _login,
                              child: Text('Entrar')),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          child: SignInButton(
                            Buttons.GoogleDark,
                            onPressed: userLogin.onGoogleLogin,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40,
                          child: SignInButton(
                            Buttons.FacebookNew,
                            onPressed: userLogin.onFaceLogin,
                          ),
                        ),
                      ],
                    );
                  }
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
      return 'Campo obrigat??rio';
    }
    return null;
  }

  _login() {
    if (!_formKey.currentState!.validate()) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          'Existe um erro em seu formul??rio',
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
          'Usu??rio/Senha inv??lidos',
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
