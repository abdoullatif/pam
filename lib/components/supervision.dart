

import 'dart:io';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:pam/components/userPannel.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:random_string/random_string.dart';

class FormSuper extends StatefulWidget {
  @override
  _FormSuperState createState() => _FormSuperState();
}

class _FormSuperState extends State<FormSuper> {

  //
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  //
  TextEditingController _textController = TextEditingController();
  final items = List<String>.generate(10, (i) => "Item $i");

  String _niveau = "";
  String confirmNiveau = "";
  //
  //Nivau Select
  int niveau;

  //asynchrone
  var id_dg = StorageUtil.getString("idpersonne");

  //
  setSelectedAge(String val){
    setState(() {
      confirmNiveau = val;
    });
  }

  StateSetter _setState;

  @override
  Widget build(BuildContext context) {
    //initialquery();
    //var
    var idtypefonction = '';
    //asynchrone
    idtypefonction = StorageUtil.getString("idtypefonction");
    var idlocalite = StorageUtil.getString("idlocalite");
    //////////////////////////////////////////////////////////////////////////
    Future<List<Map<String, dynamic>>> Plantationquery() async{
      List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
      //Agent
      //var _locateAgent = await DB.queryWhereidlocalite("localite",idlocalite);
      //
      //print(tab[0]["locate"]);
      //print(_locateAgent[0]["description"]);
      List<Map<String, dynamic>> queryRows;
      if(tab[0]["locate"] == idlocalite){
        var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
        queryRows = await DB.queryPersonAgri(_locate[0]["id"].toString());
      }
      return queryRows;
    }
    //Si chef Agriculteurs
    //************************************************************************
    final _plantation = FutureBuilder(
        future: Plantationquery(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Map<String, dynamic>> snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          //si il ya une eurreur lor du chargement
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur est survenue ou vous n'etes pas autorisé a superviser cette localité"),
            );
          }
          print(snap);
          int n = snap == null ? 0 : int.tryParse(snap.length.toString()) ?? 0;
          final items = List<String>.generate(n, (i) => "Item $i");

          return Column(
              children: <Widget>[
                Container(
                  //color: Colors.indigo,
                    margin: EdgeInsets.only(bottom: 30.0),
                    child: Align(
                      //alignment: Alignment.center,
                      child: SizedBox(
                        //height: 50.0,
                        child: Text(
                          "Nombre d'agriculteur enregistré : $n",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return RaisedButton(
                          elevation: 0,
                          padding: EdgeInsets.all(0.0),
                          color: Colors.transparent,
                          disabledColor: Colors.transparent,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUser(),settings: RouteSettings(arguments: '${snap[index]["id"]}')),);
                          },
                          child: Card(
                            margin: EdgeInsets.only(top: 25.0,),
                            elevation: 2.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.transparent,
                                backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${snap[index]["image"]}')),
                                //backgroundImage: Image.file(file),
                              ),
                              title: Text('${snap[index]["nom"]} ${snap[index]["prenom"]}'),
                              subtitle: Text('${snap[index]["fonction"]}'),
                            ),
                          )
                      );
                    },
                  ),
                )
              ]
          );
        }
    );
    //------------------------------------------------------------------------
    //si Directeur
    //************************************************************************
    Future<List<Map<String, dynamic>>> Elevequery() async{
      List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
      //
      //Agent
      //var _locateAgent = await DB.queryWhereidlocalite("localite",idlocalite);
      //
      List<Map<String, dynamic>> queryRows;
      if(tab[0]["locate"] == idlocalite){
        var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
        queryRows = await DB.queryPersonEleve(_locate[0]["id"].toString(),id_dg);
        return queryRows;
      }
    }
    final _Eleve = FutureBuilder(
        future: Elevequery(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List snap = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur est survenue ou vous n'etes pas autorisé a superviser cette localité"),
            );
          }

          TextEditingController teSearch = TextEditingController();

          int n = snap == null ? 0 : int.tryParse(snap.length.toString()) ?? 0;
          final items = List<String>.generate(n, (i) => "Item $i");

          //************************************************************
          Future<void> SelectCodifClasse() async {
            List<Map<String, dynamic>> queryCodif = await DB.queryCodif(
                "codification", "niveau");
            return queryCodif;
          }
          //********************************************************************

          return Column(
              children: <Widget>[
                //Nombre de membre
                Container(
                  //color: Colors.indigo,
                    margin: EdgeInsets.only(bottom: 30.0),
                    child: Align(
                      //alignment: Alignment.center,
                      child: SizedBox(
                        //height: 50.0,
                        child: Text(
                          "Nombre d'élève enregistré : $n",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                ),
                Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return RaisedButton(
                            elevation: 0,
                            padding: EdgeInsets.all(0.0),
                            color: Colors.transparent,
                            disabledColor: Colors.transparent,
                            onPressed: () async{
                              //
                              //var _campagneAgri = await DB.queryCampagne();
                              var _campagneAnneeS = await DB.queryAnneeScolaire();

                              if(_campagneAnneeS.isNotEmpty){
                                //Decomposition de l'annee idtypeannee
                                String a = _campagneAnneeS[0]['description'];
                                String anneeSimple = a.substring(5);
                                int anneeEnCour = int.parse(anneeSimple);
                                print(anneeEnCour);
                                //idtypeAnne
                                String idtypeA = snap[index]['derniereAnne'];
                                int idtypeAnnee = int.parse(idtypeA);
                                print(idtypeAnnee);
                                //idtypeniveau
                                String idtypeN = snap[index]['idtypeniveau'];
                                int idtypeNiveau = int.parse(idtypeN);
                                //
                                if(idtypeAnnee == anneeEnCour){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUser(),settings: RouteSettings(arguments: '${snap[index]["idpersonne"]}')),);
                                } else if (idtypeAnnee < anneeEnCour) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Session Obselete"),
                                        content: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState){
                                            _setState = setState;
                                            return SingleChildScrollView(
                                              child: Form(
                                                key: _formKey2,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      //color: Colors.indigo,
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: SizedBox(
                                                            //height: 50.0,
                                                            child: Text(
                                                              "La session de l'élève a expiré, Merci de lui réinscrit pour la nouvelle session $anneeSimple",
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Divider(),
                                                    SizedBox(height: 25,),
                                                    Container(
                                                      //color: Colors.indigo,
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: SizedBox(
                                                            //height: 50.0,
                                                            child: Text(
                                                              "Niveau actuelle de l'élève : ${snap[index]['idtypeniveau']} eme Année",
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Container(
                                                      //color: Colors.indigo,
                                                        margin: EdgeInsets.only(bottom: 30.0),
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: SizedBox(
                                                            //height: 50.0,
                                                            child: Text(
                                                              "Vous devez sélectionner le niveau de l'élève",
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    FutureBuilder(
                                                        future: SelectCodifClasse(),
                                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                          List snap = snapshot.data;
                                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                                            return Center(
                                                              child: CircularProgressIndicator(),
                                                            );
                                                          }
                                                          //si il ya une eurreur lor du chargement
                                                          if (snapshot.hasError) {
                                                            return Center(
                                                              child: Text("Erreur de chargement"),
                                                            );
                                                          }
                                                          return DropDownFormField(
                                                            titleText: 'Classe',
                                                            hintText: 'niveau de l\'élève',
                                                            value: _niveau,
                                                            onSaved: (value) {
                                                              setState(() {
                                                                _niveau = value;
                                                              });
                                                            },
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _niveau = value;
                                                                niveau = int.parse(_niveau);
                                                                print(_niveau);
                                                                print(idtypeNiveau);
                                                                print(niveau);
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      title: Text("Comfirmation de Reinscription"),
                                                                      content: SingleChildScrollView(
                                                                        child: Column(
                                                                          children: [
                                                                            niveau != 0 && idtypeNiveau == niveau ?
                                                                            Text("Je comfirme la réinscription dans la meme classe : $_niveau eme annee ") :
                                                                            niveau != 0 && idtypeNiveau > niveau ?
                                                                            Text("Je comfirme la réinscription dans une classe anterieur : $_niveau eme annee ") :
                                                                            niveau != 0 && idtypeNiveau < niveau ?
                                                                            Text("Je comfirme la réinscription dans une classe superieur : $_niveau eme annee ") :
                                                                            Text("Un probleme est survenue !"),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: <Widget>[
                                                                        FlatButton(
                                                                          child: Text('OK'),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop('oui');
                                                                          },
                                                                        ),
                                                                      ],
                                                                      //shape: CircleBorder(),
                                                                    );
                                                                  },
                                                                );
                                                              });
                                                            },
                                                            dataSource: snap,
                                                            textField: 'description',
                                                            valueField: 'idcodification',
                                                            validator: (value) {
                                                              if (_niveau == "") {
                                                                return 'Veuiller selection le niveau de l\'eleve';
                                                              }
                                                              return null;
                                                            },
                                                          );
                                                        }
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Réinscrire'),
                                            onPressed: () async {
                                              //La classe est anterieur superieur ou egale
                                              if(_formKey2.currentState.validate()){
                                                //Reinscription dans la bd
                                                var _tab = await DB.initTabquery();
                                                //Directeur
                                                String idinsgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                String idclsgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                //
                                                var idecole = StorageUtil.getString("idecole");
                                                //
                                                await DB.insert("classe", {
                                                  "id": idclsgen,
                                                  "idecole": idecole,
                                                  "idtypeniveau": _niveau,
                                                  "anneeScolaire": _campagneAnneeS[0]['description'],
                                                  "flagtransmis": "",
                                                });
                                                //table//
                                                await DB.insert("inscription", {
                                                  "id": idinsgen,
                                                  "idpersonne": snap[index]['idpersonne'],
                                                  "idclasse": idclsgen,
                                                  "idtypeannee": anneeSimple,
                                                  "anneeScolaire": _campagneAnneeS[0]['description'],
                                                  "flagtransmis": "",
                                                });
                                                Navigator.of(context).pop('oui');
                                                setState(() {
                                                  _niveau = "";
                                                });
                                              }
                                            },
                                          ),
                                          FlatButton(
                                            onPressed: (){
                                              Navigator.of(context).pop('non');
                                            },
                                            child: Text('Annuler'),
                                          ),
                                        ],
                                        //shape: CircleBorder(),
                                      );
                                    },
                                  );
                                }

                              } else {
                                //Si la campagne agricole n'existe pas
                                var confirm = await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Session non valide"),
                                      content: Text("Aucune campagne enregistrer !"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop('oui');
                                          },
                                        ),
                                      ],
                                      //shape: CircleBorder(),
                                    );
                                  },
                                );
                              }
                            },
                            child: Card(
                              margin: EdgeInsets.only(top: 25.0,),
                              elevation: 2.0,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.transparent,
                                  backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${snap[index]["image"]}')),
                                  //backgroundImage: Image.file(file),
                                ),
                                title: Text('${snap[index]["nom"]} ${snap[index]["prenom"]}'),
                                subtitle: Text('${snap[index]["classe"]}'),
                              ),
                            )
                        );
                      },
                    )
                )
              ]
          );
        }
    );
    //--------------------------------------------------------------------------
    //si femme Emceinte
    //************************************************************************
    Future<List<Map<String, dynamic>>> FemmeEquery() async{
      List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
      //Agent
      //var _locateAgent = await DB.queryWhereidlocalite("localite",idlocalite);
      //
      if(tab[0]["locate"] == idlocalite){
        var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
        List<Map<String, dynamic>> queryRows = await DB.queryPersonFemmeE(_locate[0]["id"].toString());
        return queryRows;
      }
    }
    final _femme = FutureBuilder(
        future: FemmeEquery(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Map<String, dynamic>> snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur est survenue ou vous n'etes pas autorisé a superviser cette localité"),
            );
          }
          int n = snap == null ? 0 : int.tryParse(snap.length.toString()) ?? 0;

          final items = List<String>.generate(n, (i) => "Item $i");
          return Column(
            children: <Widget>[
              Container(
                //color: Colors.indigo,
                  margin: EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    //alignment: Alignment.center,
                    child: SizedBox(
                      //height: 50.0,
                      child: Text(
                        "Nombre de femme enceinte enregistré : $n",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return RaisedButton(
                        elevation: 0,
                        padding: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUser(),settings: RouteSettings(arguments: '${snap[index]["id"]}')),);
                        },
                        child: Card(
                          margin: EdgeInsets.only(top: 25.0,),
                          elevation: 2.0,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.transparent,
                              backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${snap[index]["image"]}')),
                              //backgroundImage: Image.file(file),
                            ),
                            title: Text('${snap[index]["nom"]} ${snap[index]["prenom"]}'),
                            subtitle: Text('${snap[index]["idtypefonction"]}'),
                          ),
                        )
                    );
                  },
                ),
              ),
            ],
          );
        }
    );
    //--------------------------------------------------------------------------
    return Padding(
      padding: EdgeInsets.only(left: 100.0, right: 100.0, top: 30, bottom: 30.0,),
      child: idtypefonction == "AA" ? _plantation : idtypefonction == "AFE" ? _femme : _Eleve,
    );
  }
}