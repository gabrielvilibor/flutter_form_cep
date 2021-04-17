import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_form_cep/controller/auth_login.dart';
import 'package:flutter_form_cep/model/user_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserLogin {
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  void toggleLoading() => isLoading.value = !isLoading.value; // metódo já declarado, posso utilizar em outros lugares sem construir o metodo

  Future<void> onGoogleLogin() async {

    toggleLoading();

    try{
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final loginResult =
      await FirebaseAuth.instance.signInWithCredential(credential);

      await setUserLogged(loginResult.user);

      print(loginResult.user!.displayName);
      print(loginResult.user!.email);
    }catch(e){
      print('erro no login google');
      toggleLoading();
    }
  } // fim login google

  Future<void> onFaceLogin() async {

    toggleLoading();

    final faceLogin = await FacebookAuth.instance.login();

    try{
      print(faceLogin.status);
      if(faceLogin.status == LoginStatus.success){
        final credential = FacebookAuthProvider.credential(faceLogin.accessToken!.token);

        final firebaseLogin = await FirebaseAuth.instance.signInWithCredential(credential);

        await setUserLogged(firebaseLogin.user);

        print(firebaseLogin.user!.displayName);
        print(firebaseLogin.user!.email);
      }

      print('Login sem sucesso');
    }catch(e){
      print('erro ao carregador login do face');
      toggleLoading();
    }
  } // fim login face

  Future<void> setUserLogged(User? firebaseUser) async {
    final token = await firebaseUser!.getIdToken();

    final userAuth = UserAuth(
      email: firebaseUser.email!,
      name: firebaseUser.displayName!,
      urlPhoto: firebaseUser.photoURL!,
      token: token,
    );

    final authController = GetIt.I.get<AuthLogin>();

    authController.userLogged = userAuth;
    toggleLoading();
  }

}