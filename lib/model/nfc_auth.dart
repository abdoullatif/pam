//package native
import 'dart:async';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

//code
class Nfc{
  //attribut
  String _uid;
  //methode
  static getuid(){
    var _uid;
    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
     _uid = response.id.substring(2);
      _uid= _uid.toUpperCase();
      if(_uid != ""){
        print(_uid);
      }
    });
    return _uid;
  }
}