
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';

class changePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: passwordPannel(),
    );
  }
}

class passwordPannel extends StatefulWidget {
  @override
  _passwordPannelState createState() => _passwordPannelState();
}

class _passwordPannelState extends State<passwordPannel> {

  // Inside your _MyAppState class
  bool isLoading = true;

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

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      //_login();
    });
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //asynchrone
    var idpersonne = StorageUtil.getString("idpersonne");
    var mdp = StorageUtil.getString("mdp");
    //print(idpersonne);
    //print(mdp);
    //
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();
    //
    final _formKey4 = GlobalKey<FormState>();

    //
    DBCrypt dBCrypt = DBCrypt();
    //String plainPwd = "123";

    TextEditingController _oldPassword = TextEditingController();
    TextEditingController _newPassword = TextEditingController();
    TextEditingController _confirmNewPassword = TextEditingController();

    //String id = ModalRoute.of(context).settings.arguments;
    //
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: Form(
          key: _formKey4,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //SizedBox(height: 100.0),
                Container(
                  //color: Colors.indigo,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        //height: 50.0,
                        child: Text(
                          "Modifier Mon password",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  obscureText: true,
                  controller: _oldPassword,
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                    hintText: "Ancien mot de passe ",
                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                    //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                    enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Veuiller entrer une information';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  obscureText: true,
                  controller: _newPassword,
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                    hintText: "Nouveau mot de passe ",
                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                    //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                    enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Veuiller entrer une information';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  obscureText: true,
                  controller: _confirmNewPassword,
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                    hintText: "Comfirmer le nouveau mot de passe ",
                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                    //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                    enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Veuiller entrer une information';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25.0),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color(0xff01A0C7),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async{
                      if (_formKey4.currentState.validate()) {
                        //_onLoading;

                        String oldMdp = _oldPassword.text;
                        //
                        String newMdp = _newPassword.text;
                        //

                        var isCorrect = new DBCrypt().checkpw(oldMdp, mdp);

                        if(isCorrect){ //_oldPassword.text == mdp
                          if(_newPassword.text == _confirmNewPassword.text ){

                            // Generate a salt with a cost of 12 and hash the password with it
                            String salt = dBCrypt.gensaltWithRounds(12);
                            String hashedPwd2 = dBCrypt.hashpw(newMdp, salt);

                            print(hashedPwd2);

                            String mdpEnter = hashedPwd2.replaceFirst(RegExp('b'), 'y');

                            print(mdpEnter);

                            //CHANNEL
                            //reponseFromNativeCode(mdp);
                            //
                            //print(_reponseFromNativeCode);

                            //insertion du nom de la tablette
                            await DB.updatePersonne("personne", {
                              "mdp": mdpEnter,
                              "flagtransmis": "",
                            },idpersonne);
                            setState(() {
                              _oldPassword = TextEditingController()..text = '';
                              _newPassword = TextEditingController()..text = '';
                              _confirmNewPassword = TextEditingController()..text = '';
                            });

                            Fluttertoast.showToast(
                                msg: "Modification du mot de passe effectuer avec succes !", //Présence enregistrée,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: "Comfirmation du mot de passe incorrete !", //Présence enregistrée,
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
                              msg: "Ancien mot de passe incorrecte !", //Présence enregistrée,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }

                      }
                    },
                    child: Text("Modifier",
                      textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(height: 25.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

