import 'package:flutter/material.dart';
import 'package:flutter_form_cep/model/cliente.dart';
import 'package:flutter_form_cep/view/cliente_form.dart';
import 'package:flutter_form_cep/view/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aula GrowDev - Busca Cep App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}