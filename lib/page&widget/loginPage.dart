

import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adminWindows.dart';
import 'forgetuid.dart';

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {

  /*
  //Channel java
  static const plateform = const MethodChannel('flutter.native/java');
  String _reponseFromNativeCode = '';

  Future<void> reponseFromNativeCode(String mdpUser) async {
    String reponse = "";
    //
    try{
      final String result = await plateform.invokeMethod('encryptPassword',{"password": mdpUser});
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
  */

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
  }

  @override
  void dispose() {
    print("out nfc");
    //FlutterNfcReader.stop().then((response) {
      //print(response.status.toString());
    //);
    super.dispose();
  }

  //crypt
  DBCrypt dBCrypt = DBCrypt();
  // Generate a salt with a cost of 12 and hash the password with it
  //String salt = dBCrypt.gensaltWithRounds(12);
  //String hashedPwd2 = dBCrypt.hashpw(mdpEnter, salt);

  @override
  Widget build(BuildContext context) {

    //
    passAdmin(String nfc) async{
      //If textfield est remplir
      if(_email.text.isNotEmpty && _mdp.text.isNotEmpty){
        String mdpEnter = _mdp.text;
        //var isCorrect = new DBCrypt().checkpw(mdpEnter, hashedPwd2);
        //CHANNEL
        //reponseFromNativeCode(mdp);
        //Select from personne for verif
        List<Map<String, dynamic>> queryPersonne = await DB.queryEmail("personne", _email.text); // _mdp.text
        print(queryPersonne);
        //If existed
        if(queryPersonne.isNotEmpty){
          //Loading !!!!!!!!!!!!!!!!!!!!!!!!!!!!!

          var passwordIsCorrect = dBCrypt.checkpw(mdpEnter, queryPersonne[0]['mdp']);
          print(passwordIsCorrect);
          if(passwordIsCorrect){
            if (nfc != ""){
              List<Map<String, dynamic>> verifUid = await DB.queryEmailNfc("personne",_email.text,nfc);
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
                  //ecole si c'est un directeur d'ecole
                  if(queryPersonne_fonction[0]['idtypefonction'] == "DG"){
                    List<Map<String, dynamic>> queryEcole = await DB.queryWhereidpersonne("ecole", queryPersonne[0]['id']);
                    if(queryEcole.isNotEmpty){
                      //Si Ecole existe, Si le directeur est lie a une ecole
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

                  //Navigator.of(context).pushNamedAndRemoveUntil('/admin', ModalRoute.withName ('/Acceuil'));

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) => AdminWindows()), ModalRoute.withName('/Acceuil'));

                  //Navigator.pop(context);
                  /*
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AdminWindows()),
                  );
                  */
                  ////////////////////////////////////////////////////////////////////////////////
                }
              } else {
                //message alerte
                Fluttertoast.showToast(
                    msg: "Ce bracelets ne correspond pas a votre identifiants, Veuillez scanner a nouveau", //Présence enregistrée,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                //msg_error = "";
              }
            } else {
              //msg alerte
              Fluttertoast.showToast(
                  msg: "Veuillez Scanner votre bracelet pour confirmer votre identite", //Présence enregistrée,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              msg_error = "";
            }
          } else {
            Fluttertoast.showToast(
                msg: "Email ou mot de passe incorrecte, Veuillez réessayer", //Présence enregistrée,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }

        } else if(_email.text == "SuperAdminTulipInd@tld.com" && _mdp.text == "TulipInd2017"){
          //Si on est super utiliisateur
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', "SuperAdminTulipInd@tld.com");
          prefs.setString('mdp', "TulipInd2017");

          //Navigator.of(context).pushNamedAndRemoveUntil('/admin', ModalRoute.withName ('/Acceuil'));
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) => AdminWindows()), ModalRoute.withName('/Acceuil'));

          /*Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) => AdminWindows()), (route) => false);

                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AdminWindows()),
                  );
                  */
        } else if(_email.text == "nfc-scan" && _mdp.text == "123456"){
          //scan nfc
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', "nfc-scan");
          prefs.setString('mdp', "123456");

          //Navigator.of(context).pushNamedAndRemoveUntil('/admin', ModalRoute.withName ('/Acceuil'));
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) => ScanUID()), ModalRoute.withName('/Acceuil'));

          /*Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) => AdminWindows()), (route) => false);

                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AdminWindows()),
                  );
                  */
        } else {
          Fluttertoast.showToast(
              msg: "Email ou mot de passe incorrecte, Veuillez réessayer", //Présence enregistrée,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: "Veuillez rempli email et mot de passe ", //Présence enregistrée,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      //
    }

    if(mounted) {
      //Nfc reader live time
      FlutterNfcReader.read().then((response) {
        //print(response.id.substring(2));
        iud = response.id.substring(2);
        nfc = iud.toUpperCase();
        setState(() {
          print(nfc);
          passAdmin(nfc);
        });
      });

    } else {
      FlutterNfcReader.stop().then((response) {
        print(response.status.toString());
      });
    }




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
                    onTap: () async{
                      Navigator.pop(context);
                      //Tout est bon avec un toucher on passe
                      passAdmin(nfc);
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
                  //Text(_reponseFromNativeCode),
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