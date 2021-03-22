import 'package:flutter_form_cep/model/buscacep.dart';
import 'package:flutter_form_cep/services/buscacep_api.dart';
import 'package:mobx/mobx.dart';
part 'buscacep_mobx.g.dart';

class BuscaCepMobx = BuscaCepMobxBase with _$BuscaCepMobx;

abstract class BuscaCepMobxBase with Store{

  @observable
  BuscaCep bc;

  @observable
  Error error;

  @action
  Future<BuscaCep> buscaCep(String cep) async{
    try{
      return await BuscaCepApi.getCep(cep);
    }catch(e){
      error = e;
    }
  }

}