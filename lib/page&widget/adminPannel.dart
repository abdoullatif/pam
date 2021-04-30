
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pam/database/storageUtil.dart';

import 'changePassword.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var
    var idpersonne = '';
    var nom = '';
    var prenom = '';
    var date_naissance = '';
    var idgenre = '';
    var date_creation = '';
    var iud = '';
    var email = '';
    var mdp = '';
    var image = '';
    var idadresse = '';
    var idlocalite = '';
    var adresse = '';
    var idpersonne_fonction = '';
    var idtypefonction = '';
    var idecole = '';
    var ecole = '';
    //asynchrone
    idpersonne = StorageUtil.getString("idpersonne");
    nom = StorageUtil.getString("nom");
    prenom = StorageUtil.getString("prenom");
    date_naissance = StorageUtil.getString("date_naissance");
    idgenre = StorageUtil.getString("idgenre");
    date_creation = StorageUtil.getString("date_creation");
    iud = StorageUtil.getString("iud");
    email = StorageUtil.getString("email");
    mdp = StorageUtil.getString("mdp");
    image = StorageUtil.getString("image");
    idlocalite = StorageUtil.getString("idlocalite");
    adresse = StorageUtil.getString("adresse");
    idpersonne_fonction = StorageUtil.getString("idpersonne_fonction");
    idtypefonction = StorageUtil.getString("idtypefonction");
    idecole = StorageUtil.getString("idecole");
    ecole = StorageUtil.getString("ecole");
    //var
    String id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon profile"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width/3,
          child: Card(
            elevation: 10.0,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //widget
                  Container(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/$image')),
                    ),
                  ),
                  Divider(),
                  Container(
                    //color: Colors.indigo,
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          //height: 50.0,
                          child: Text(
                            "$nom $prenom",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                  ),
                  Container(
                    //color: Colors.indigo,
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          //height: 50.0,
                          child: Text(
                            "Localite: $idlocalite",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                  ),
                  Container(
                    //color: Colors.indigo,
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          //height: 50.0,
                          child: Text(
                            "Adresse: $adresse",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                  ),
                  Container(
                    //color: Colors.indigo,
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Align(
                        //alignment: Alignment.center,
                        child: SizedBox(
                          //height: 50.0,
                          child: Text(
                            "Email: $email",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                  ),
                  Container(
                    //color: Colors.indigo,
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          //height: 50.0,
                          child: Text(
                            "date de naissance: $date_naissance",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                  ),
                  Container(
                    //color: Colors.indigo,
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          //height: 50.0,
                          child: Text(
                            "Sexe: $idgenre",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                  ),
                  Container(
                    //color: Colors.indigo,
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          //height: 50.0,
                          child: Text(
                            "Inscrit: $date_creation",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                  ),
                  Divider(),
                  FlatButton(
                    child: Text("Modifier mon mot de passe"),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => changePassword()),);
                    },
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