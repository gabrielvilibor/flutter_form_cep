import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_form_cep/model/user_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthLogin {
  ValueNotifier<UserAuth?> _usuarioLogado = ValueNotifier(null); // recebe nulo para iniciar o app sem usuário logado

  ValueNotifier<UserAuth?> get usuario => _usuarioLogado;

  set userLogged(UserAuth? user) => _usuarioLogado.value = user;

  Future<void> loadUser(User userFirebase) async {
    if (usuario.value == null) { // se for nulo e tentar acessar atribuo ao meu usuario logado
      final token = await userFirebase.getIdToken();
      userLogged = UserAuth(
        email: userFirebase.email!,
        name: userFirebase.displayName!,
        urlPhoto: userFirebase.photoURL!,
        token: token,
      );
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    userLogged = null;
  }

  bool isLogged() {
    final usuarioLogado = FirebaseAuth.instance.currentUser;
    if (usuarioLogado != null) {
      loadUser(usuarioLogado);
      return true;
    }
    return false;
  }
}