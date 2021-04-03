
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_form_cep/model/buscacep.dart';

class BuscaCepApi {

  static Future<BuscaCep?> getCep(String cep) async{
    var url = "https://viacep.com.br/ws/";
    try{
      var dio = Dio(BaseOptions(baseUrl: url));

      final response = await dio.get('$cep/json');

      if(response.statusCode == 200 || response.statusCode == 201){
        BuscaCep cep = BuscaCep.fromMap(response.data);
        return cep;
      }
      return null;

    }catch(e){
      return null;
    }


  }


}