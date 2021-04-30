import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adminWindows.dart';

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {

  //Channel java
  static const plateform = const MethodChannel('flutter.native/helper');
  String _reponseFromNativeCode = 'Waiting for reponse ...';

  Future<void> reponseFromNativeCode() async {
    String reponse = "";
    //
    try{
      final String result = await plateform.invokeMethod('helloFromNativeCode');
      reponse = result;
    } on PlatformException catch (e) {
      reponse = "Erreur to invoke: .'${e.message}'.";
    }

    _reponseFromNativeCode = reponse;

    setState(() {
      _reponseFromNativeCode = reponse;
    });

    print(_reponseFromNativeCode);

  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  String msg_error = "Veuillez Scanner votre bracelet pour confirmer votre identite";
  //variable de connexion
  TextEditingController _email = TextEditingController();
  TextEditingController _mdp = TextEditingController();
  //nfc
  bool nfc_msg_visible = false;
  //String
  String iud = "";
  String nfc = "";

  @override
  void initState() {
    super.initState();
    //CHANNEL
    reponseFromNativeCode();
  }

  @override
  Widget build(BuildContext context) {


    //fonction pour entrer admin pannel
    passAdmin(String nfc) async{
      //If textfield est remplir
      if(_email.text.isNotEmpty && _mdp.text.isNotEmpty){
        //Select from personne for verif
        List<Map<String, dynamic>> queryPersonne = await DB.query2Where("personne", _email.text, _mdp.text);
        //If existed
        if(queryPersonne.isNotEmpty){
          //nfc
          if (nfc != ""){
            List<Map<String, dynamic>> verifUid = await DB.query3Where("personne",_email.text,_mdp.text,nfc);
            if(verifUid.isNotEmpty){
              //get table personne fonction
              List<Map<String, dynamic>> queryPersonne_adresse = await DB.queryWhereidpersonne("personne_adresse", queryPersonne[0]['id']);
              List<Map<String, dynamic>> querylocalite = await DB.queryWhere("localite", queryPersonne_adresse[0]['idlocalite']);
              List<Map<String, dynamic>> queryPersonne_tel = await DB.queryWhereidpersonne("personne_tel", queryPersonne[0]['id']);
              List<Map<String, dynamic>> queryPersonne_fonction = await DB.queryWhereidpersonne("personne_fonction", queryPersonne[0]['id']);
              if(queryPersonne_adresse.isNotEmpty && queryPersonne_tel.isNotEmpty && queryPersonne_fonction.isNotEmpty){
                //Recup les champs des autre tables
                //On envois ces donnee dans le sharepreference
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('idpersonne', queryPersonne[0]['id']);
                prefs.setString('nom', queryPersonne[0]['nom']);
                prefs.setString('prenom', queryPersonne[0]['prenom']);
                prefs.setString('date_naissance', queryPersonne[0]['date_naissance']);
                prefs.setString('idgenre', queryPersonne[0]['idgenre']);
                prefs.setString('date_creation', queryPersonne[0]['date_creation']);
                prefs.setString('iud', queryPersonne[0]['iud']);
                prefs.setString('email', queryPersonne[0]['email']);
                prefs.setString('mdp', queryPersonne[0]['mdp']);
                prefs.setString('image', queryPersonne[0]['image']);
                //personne adresse
                prefs.setString('idadresse', queryPersonne_adresse[0]['id']);
                prefs.setString('idlocalite', querylocalite[0]['description']);
                prefs.setString('adresse', queryPersonne_adresse[0]['adresse']);
                //personne tel
                prefs.setString('idpersonne_fonction', queryPersonne_fonction[0]['id']);
                prefs.setString('idtypefonction', queryPersonne_fonction[0]['idtypefonction']);
                if(queryPersonne_fonction[0]['idtypefonction'] == "DG"){
                  List<Map<String, dynamic>> queryEcole = await DB.queryWhereidpersonne("ecole", queryPersonne[0]['id']);
                  if(queryEcole.isNotEmpty){
                    //ecole si c'est un directeur d'ecole
                    prefs.setString('idecole', queryEcole[0]['id']);
                    prefs.setString('nom_ecole', queryEcole[0]['nom_ecole']);
                  }
                }
                ////////////////////////////////////////////////////////////////////////////////
                //si tout ce passe bien on le redirige vers le pannel admin
                setState(() {
                  _email = TextEditingController()..text = '';
                  _mdp = TextEditingController()..text = '';
                });
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AdminWindows()),
                );
                ////////////////////////////////////////////////////////////////////////////////
              }
            } else {
              //message alerte
              msg_error = "Ce bracelets ne correspond pas a votre identifiants, Veuillez scanner a nouveau";
            }
          } else {
            //msg alerte
            msg_error = "Veuillez Scanner votre bracelet pour confirmer votre identite";
          }
        } else if(_email.text == "SuperAdminTulipInd@tld.com" && _mdp.text == "TulipInd2017"){
          //Si on est super utiliisateur
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', "SuperAdminTulipInd@tld.com");
          prefs.setString('mdp', "TulipInd2017");
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => AdminWindows()),
          );
        } else {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Probleme d'identification"),
                content: const Text("Oups nous avons rencontrer un probleme lors de l'identification, Veuiller ressailler ou contacter la call center"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                //shape: CircleBorder(),
              );
            },
          );
        }
      }
      //
    }

    //Nfc reader live time
    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      iud = response.id.substring(2);
      nfc = iud.toUpperCase();
      setState(() {
        if(mounted) {
          print(nfc);
          passAdmin(nfc);
        } else {
          print(nfc);
          passAdmin(nfc);
        }
      });
    });

    //les champs
    final emailField = TextFormField(
      obscureText: false,
      style: style,
      controller: _email,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Padding(
          padding: EdgeInsets.all(0.0),
          child: Icon(
            Icons.account_circle,
            color: Colors.grey,
          ), // icon is 48px widget.
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Veuiller entrer votre addresse email';
        }
        return null;
      },
    );
    final passwordField = TextFormField(
      obscureText: true,
      style: style,
      controller: _mdp,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Padding(
          padding: EdgeInsets.all(0.0),
          child: Icon(
            Icons.vpn_key,
            color: Colors.grey,
          ), // icon is 48px widget.
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Veuiller entrer votre mot de passe';
        }
        return null;
      },
    );
    //Button login
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async{
          //
          var iud_bracelet = StorageUtil.getString("iud");
          if (_formKey.currentState.validate()) {
            // Lancement du modale
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return InkWell(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 30.0,),
                        SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage("images/scan_nfc.png"),
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Text('Placer votre bracelet sur la tablette'),
                        SizedBox(height: 10.0,),
                        Text('$msg_error'),//, style: TextStyle(color: Colors.green,),
                        SizedBox(height: 30.0,),
                      ],
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  );
                });
          }
        },
        child: Text("Se connecter",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    //end
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/backgroundempty.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Form(
          key: _formKey,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 100.0, right: 100.0),
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  //Column(),
                  Text(_reponseFromNativeCode),
                  SizedBox(height: 30.0),
                  SizedBox(
                    height: 100.0,
                    child: Image.asset(
                      "images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 45.0),
                  emailField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(
                    height: 35.0,
                  ),
                  loginButon,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}