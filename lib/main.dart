import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_cep/controller/auth_login.dart';
import 'package:flutter_form_cep/controller/user_login.dart';
import 'package:flutter_form_cep/model/cliente.dart';
import 'package:flutter_form_cep/model/user_auth.dart';
import 'package:flutter_form_cep/view/cliente_form.dart';
import 'package:flutter_form_cep/view/home_page.dart';
import 'package:flutter_form_cep/view/login_page.dart';
import 'package:get_it/get_it.dart';

final Future<FirebaseApp> _initialization = Firebase.initializeApp();

void main() {
  runApp(MyApp());
  GetIt.I.registerSingleton(AuthLogin());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, AsyncSnapshot<FirebaseApp> snapshot) {

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao inicializar o Firebase'),
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final controller = GetIt.I.get<AuthLogin>();

          return ValueListenableBuilder<UserAuth?>(
            valueListenable: controller.usuario,
            builder: (_, userLogged, __){
              return MaterialApp(
                title: 'Aula GrowDev - Busca Cep App',
                theme: ThemeData(
                  primarySwatch: Colors.red,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                initialRoute: '/',
                routes: {
                '/': (_) {
                  if (controller.isLogged()) return HomePage();

                  return LoginPage();
                  },
                  '/cliente-form-page': (ctx) {
                  final param = ModalRoute.of(ctx)?.settings.arguments;
                  Cliente? cliente = param == null ? null : param as Cliente;

                  return ClienteFormPage(cliente: cliente);
                },
                },
              );
            },
          );
        }
    );
  }
}