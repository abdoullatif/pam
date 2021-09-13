//package native
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

class Nfc{
  //attribut


  //methode
  static getuid(){
    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      String _iud = response.id.substring(2);
      String nfc = _iud.toUpperCase();
      return nfc;
    });
  }

}