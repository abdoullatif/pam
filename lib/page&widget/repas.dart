import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repas extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //
    final globalScaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: globalScaffoldKey,
      appBar: AppBar(
        title: Text("Repas"),
      ),
      body: RepasPannel(),
    );
  }
}

class RepasPannel extends StatefulWidget {
  @override
  _RepasPannelState createState() => _RepasPannelState();
}

class _RepasPannelState extends State<RepasPannel> {

  /*
  @override
  void dispose() {
    super.dispose();
    FlutterNfcReader.stop();
  }
  */

  //var
  String _uid = "";
  int qte = 0;
  int nbs = 0;
  var nbscan = "";

  @override
  Widget build(BuildContext context) {
    //
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var heur = DateFormat.H().format(DateTime.now()).toString();
    var date = dates.toString();
    //
    DateTime now = DateTime.now();
    // \n EEE d MMM
    String formattedDate = DateFormat('kk:mm:ss').format(now);
    //
    var idpersonne = StorageUtil.getString("idpersonne");
    var idtypefonction = StorageUtil.getString("idtypefonction");
    var iud = StorageUtil.getString("iud");
    //
    var idtemp = "";
    var typefoncttemp = "";
    var nomtemp = "";
    var prenomtemp = "";
    var imagetemp = "";

    //
    var manger = "";
    var presence = "";

    //
    print(heur);
    print(dates);

    /*
    getuserInfo (String nfc) async {
      List<Map<String, dynamic>> queryPersonne = await DB.queryWhereUid("personne", nfc);
      List<Map<String, dynamic>> queryEleve = await DB.queryUserElevUid(nfc);
      List<Map<String, dynamic>> queryPersonne_fonction = await DB.queryWhereidpersonne("personne_fonction", queryPersonne[0]['id']);
      print(queryPersonne);
      print(queryEleve);
      if(queryEleve.isNotEmpty && queryPersonne_fonction.isNotEmpty){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('idtemp', queryEleve[0]['id']);
        prefs.setString('typefoncttemp', queryPersonne_fonction[0]['idtypefonction']);
        prefs.setString('imagetemp', queryEleve[0]['image']);
        prefs.setString('nomtemp', queryEleve[0]['nom']);
        prefs.setString('prenomtemp', queryEleve[0]['prenom']);

        //On enregistre l'eleve
        var _tab = await DB.initTabquery();
        String idsuivitgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
        if(_tab.isNotEmpty){
          //
          var _campagneAnneeS = await DB.queryAnneeScolaire();

          if(_campagneAnneeS.isNotEmpty){
            //
            //Decomposition de l'annee idtypeannee
            String a = _campagneAnneeS[0]['description'];
            String anneeSimple = a.substring(5);
            int anneeEnCour = int.parse(anneeSimple);
            print(anneeEnCour);
            //idtypeAnne
            String idtypeA = queryEleve[0]['derniereAnne'];
            int idtypeAnnee = int.parse(idtypeA);
            print(idtypeAnnee);
            //idtypeniveau
            String idtypeN = queryEleve[0]['niveau'];
            int idtypeNiveau = int.parse(idtypeN);
            //

            if(idtypeAnnee == anneeEnCour){
              //leleve est reinscrit
              //
              var suivit = await DB.query2WhereidPers("suivit_repas",queryEleve[0]["id"],date);
              //Verification dans la bd
              if (suivit.isEmpty) {
                if(int.parse(heur) >= 8 && int.parse(heur) <= 14){
                  // Les eleve du jours
                  await DB.insert("suivit_repas", {
                    "id": idsuivitgen,
                    "idpersonne": queryEleve[0]["id"],
                    "present": "1",
                    "manger": "0",
                    "nbscan": "1",
                    "date": date,
                    "flagtransmis": "",
                  });
                  //
                  List<Map<String, dynamic>> querynbscan = await DB.queryNbrScan(date);
                  prefs.setString('nbscan', querynbscan[0]['nombre'].toString());
                  //return "Presence enregistrer !";
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text(
                      'Presence enregistrer !')));

                } else if(int.parse(heur) >= 13 && int.parse(heur) <= 17){
                  //Les eleves du soires
                  await DB.insert("suivit_repas", {
                    "id": idsuivitgen,
                    "idpersonne": queryEleve[0]["id"],
                    "present": "1",
                    "manger": "0",
                    "nbscan": "1",
                    "date": date,
                    "flagtransmis": "",
                  });
                  //
                  List<Map<String, dynamic>> querynbscan = await DB.queryNbrScan(date);
                  prefs.setString('nbscan', querynbscan[0]['nombre'].toString());
                  //return "Presence enregistrer !";
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text(
                      'Présence enregistrée !')));
                }
              } else if(suivit.isNotEmpty){
                if(int.parse(suivit[0]["nbscan"]) < 2 && suivit[0]["date"] == date && int.parse(heur) >= 11) {
                  //update
                  await DB.updateWhereIdPers("suivit_repas", {
                    //"id": idsuivitgen,
                    //"idinscription": snap[0]["idInscription"],
                    //"present": "Present",
                    "manger": "1",
                    "nbscan": "2",
                    //"date": date,
                    "flagtransmis": ""
                  },queryEleve[0]["id"]);
                  //scan manger
                  //
                  List<Map<String, dynamic>> querynbscan = await DB.queryNbrScan(date);
                  prefs.setString('nbscan', querynbscan[0]['nombre'].toString());
                  //return "Enregistrer, Bon Repas,Regaler vous !";
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text(
                      'Enregistrer, Bon Repas, Regaler vous !')));
                } else {
                  //
                  List<Map<String, dynamic>> querynbscan = await DB.queryNbrScan(date);
                  prefs.setString('nbscan', querynbscan[0]['nombre'].toString());
                  //return "Vous avez deja scanner deux fois votre bracelet";
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text(
                      'Vous avez déjà scanné votre bracelet')));
                }
              }
            } else {
              //
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Session expirée !"),
                    content: const Text("Veuiller vous faire réinscrire !!!"),
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
          } else {
            //
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Annee Scolaire !"),
                  content: const Text("Année Scolaire indisponible !"),
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



          //plus encors
          if(mounted){
            setState(() {
              nfc;
            });
          }
        }

      } else if (queryEleve.isEmpty && queryPersonne_fonction.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('typefoncttemp', queryPersonne_fonction[0]['idtypefonction']);
        //
        if(mounted){
          setState(() {
            nfc;
          });
        }
        //
      } else if (queryPersonne_fonction.isEmpty && queryEleve.isEmpty){
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Bracelet non enregistrer"),
              content: const Text("Ce bracelet n'est pas attribuer !"),
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
      else {
        /*
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("idtemp");
        prefs.remove("typefoncttemp");
        prefs.remove("imagetemp");
        prefs.remove("nomtemp");
        prefs.remove("prenomtemp");
        prefs.remove("nbscan");
         */
      }

    }

    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      _uid = response.id.substring(2);
      _uid = _uid.toUpperCase();
      print(_uid);
      getuserInfo(_uid);
    });
    */

    //
    /*
    idtemp = StorageUtil.getString("idtemp");
    typefoncttemp = StorageUtil.getString("typefoncttemp");
    nomtemp = StorageUtil.getString("nomtemp");
    prenomtemp = StorageUtil.getString("prenomtemp");
    imagetemp = StorageUtil.getString("imagetemp");
    nbscan = StorageUtil.getString("nbscan");
    //
    nbs = int.tryParse(nbscan) ?? 0;
    qte = nbs*150;
    */

    //print(typefoncttemp);

    /*
    final Component = Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width/3,
          child: typefoncttemp == "EV" ? SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //widget
                Container(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/$imagetemp')),
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
                          "$nomtemp $prenomtemp",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                ),
                Divider(),
              ],
            ),
          ) :
          Center(
            child: Card(
              child: Text("Bracelet non autorise, Ce bracelet n'appartient pas a un eleve"),
            ),
          ),
        ),
        // VerticalDivider(),//-------------------------------------------------
        Center(
          child: Container(
            margin: EdgeInsets.only(left: 50.0),
            width: MediaQuery.of(context).size.width/2,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    '$date',
                    style: TextStyle(color: Colors.black54, fontSize: 30.0, fontWeight: FontWeight.bold,),
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  Text(
                    'Nombre d\'élèves scanné: ',
                    style: TextStyle(color: Colors.black54, fontSize: 30.0, fontWeight: FontWeight.bold,),
                  ),
                  nbscan.isNotEmpty ?
                  Text(
                    '$nbscan',
                    style: TextStyle(color: Colors.black54, fontSize: 90.0),
                  ) :
                  Text(
                    '0',
                    style: TextStyle(color: Colors.black54, fontSize: 90.0),),
                  Text(
                    'Quantité de nourriture servie en gramme (NB: 150g/élève) ',
                    style: TextStyle(color: Colors.black54, fontSize: 20.0, fontWeight: FontWeight.bold,),
                  ),
                  nbscan.isNotEmpty ?
                  Text(
                    '$qte grammes',
                    style: TextStyle(color: Colors.black54, fontSize: 70.0),
                  ) :
                  Text(
                    '0',
                    style: TextStyle(color: Colors.black54, fontSize: 90.0),),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    */


    /*
    //fonction future builder
    Future<List<Map<String, dynamic>>> profil_eleve() async {
      if(uid == "") {
        if(idtypefonction == "EV") {
          List<Map<String, dynamic>> queryPerson = await DB.queryUserElevUid(iud);
          return queryPerson;
        } else {
          List<Map<String, dynamic>> queryPerson = await DB.queryUserElevUid(uid);
          return queryPerson;
        }
      } else if (uid != ""){
        List<Map<String, dynamic>> queryPerson = await DB.queryUserElevUid(uid);
        return queryPerson;
      }
    }


    final _Repas = FutureBuilder(
        future: profil_eleve(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement, Veuillez ressaillez"),
            );
          }

          //Coiunt Nombre eleveves scanner
          Future<List<Map<String, dynamic>>> Nbscan() async{
            List<Map<String, dynamic>> queryPerson = await DB.queryNbrScan(date);
            return queryPerson;
          }
          final _NbreScan = FutureBuilder(
              future: Nbscan(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Map<String, dynamic>> nombre = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erreur de chargement, Veuillez ressaillez"),
                  );
                }

                return Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 50.0),
                    width: MediaQuery.of(context).size.width/2,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text(
                            '$date',
                            style: TextStyle(color: Colors.black54, fontSize: 30.0, fontWeight: FontWeight.bold,),
                          ),
                          SizedBox(
                            height: 100.0,
                          ),
                          Text(
                            'Nombre d\'eleves scanner: ',
                            style: TextStyle(color: Colors.black54, fontSize: 30.0, fontWeight: FontWeight.bold,),
                          ),
                          nombre.isNotEmpty ?
                          Text(
                            '${nombre[0]['nombre']}',
                            style: TextStyle(color: Colors.black54, fontSize: 90.0),
                          ) :
                          Text(
                            '0',
                            style: TextStyle(color: Colors.black54, fontSize: 90.0),),
                        ],
                      ),
                    ),
                  ),
                );
              }
          );

          suivit_repas () async {
            if(snap[0]["fonction"] == "EV"){
              //On enregistre l'eleve
              var _tab = await DB.initTabquery();
              String idsuivitgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
              if(_tab.isNotEmpty){
                var suivit = await DB.query2WhereidInscription("suivit_repas",snap[0]["idInscription"],date);
                if(suivit.isNotEmpty){
                  //update
                  if(suivit[0]["nbscan"] < 2 && suivit[0]["date"] == date) {
                    //update
                    await DB.updateWhereIdInscription("suivit_repas", {
                      //"id": idsuivitgen,
                      //"idinscription": snap[0]["idInscription"],
                      //"presence": "Present",
                      "repas": "ok",
                      "nbscan": "2",
                      "date": date,
                      "flagtransmis": "",
                    },snap[0]["idInscription"]);
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text(
                        'Enregistrer, Bon Repas,Regaler vous !')));
                  } else {
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text(
                        'Vous avez deja scanner deux fois votre bracelet')));
                  }
                } else {
                  await DB.insert("suivit_repas", {
                    "id": idsuivitgen,
                    "idinscription": snap[0]["idInscription"],
                    "presence": "Present",
                    "repas": "",
                    "nbscan": "1",
                    "date": date,
                    "flagtransmis": "",
                  });
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text(
                      'Presence enregistrer !')));
                }
              }
            }
          }


          //le profile de l'eleve en question
          if(snap.isNotEmpty){
            //suivit_repas();
            return Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width/3,
                  child: snap[0]["fonction"] == "EV" ? SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        //widget
                        Container(
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${snap[0]["image"]}')),
                          ),
                        ),
                        Divider(),
                        Container(
                          //color: Colors.indigo,
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                //height: 50.0,
                                child: Text(
                                  "Identifiant:  ${snap[0]["id"]}",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
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
                                  "${snap[0]["nom"]} ${snap[0]["prenom"]}",
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
                                  "Localite: ${snap[0]["localite"]}",
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
                                  "Adresse: ${snap[0]["adresse"]}",
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
                                  "Contacte: ${snap[0]["numero"]}",
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
                                  "date de naissance: ${snap[0]["date_naissance"]}",
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
                                  "Sexe: ${snap[0]["genre"]}",
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
                                  "Inscrit: ${snap[0]["date_creation"]}",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
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
                                  "Classe: ${snap[0]["niveau"]}",
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
                                  "Session: ${snap[0]["session"]}",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                        ),
                        Divider(),
                      ],
                    ),
                  ) :
                  Center(
                    child: Card(
                      child: Text("Bracelet non autorise, Ce bracelet n'appartient pas a un eleve"),
                    ),
                  ),
                ),
                // VerticalDivider(),//-------------------------------------------------
                _NbreScan,
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                Center(
                  child: Card(
                    child: Text("Bracelet non autorise !"),
                  ),
                ),
              ],
            );
          }
        }
    );
    */
    //***********************************************************************************************
    /*
    return idtemp != "" ? Component :
    Center(
      child: Image.asset("images/repas.png"),
    );
    */
    //-----------------------------------------------------------------------------------------------
    getUser (String uid) async{
      List<Map<String, dynamic>> queryPersonne = await DB.queryWhereUid("personne", uid);
      List<Map<String, dynamic>> queryEleve = await DB.queryUserElevUid(uid);
      List<Map<String, dynamic>> queryPersonne_fonction;
      if(queryPersonne.isNotEmpty) {
        queryPersonne_fonction = await DB.queryWhereidpersonne("personne_fonction", queryPersonne[0]['id']);
      }

      print(queryPersonne_fonction);

      Map<String, dynamic> dataUser;

      if(queryEleve.isNotEmpty && queryPersonne_fonction.isNotEmpty){
        //dataUser
        dataUser = {
          'idtemp': queryEleve[0]['id'],
          'typefoncttemp': queryPersonne_fonction[0]['idtypefonction'],
          'imagetemp': queryEleve[0]['image'],
          'nomtemp': queryEleve[0]['nom'],
          'prenomtemp': queryEleve[0]['prenom']
        };
        //On enregistre l'eleve
        var _tab = await DB.initTabquery();
        String idsuivitgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
        if(_tab.isNotEmpty){
          //
          var _campagneAnneeS = await DB.queryAnneeScolaire();
          if(_campagneAnneeS.isNotEmpty){
            //Decomposition de l'annee idtypeannee
            String a = _campagneAnneeS[0]['description'];
            String anneeSimple = a.substring(5);
            int anneeEnCour = int.parse(anneeSimple);
            print(anneeEnCour);
            //idtypeAnne
            String idtypeA = queryEleve[0]['derniereAnne'];
            int idtypeAnnee = int.parse(idtypeA);
            print(idtypeAnnee);
            //idtypeniveau
            String idtypeN = queryEleve[0]['niveau'];
            int idtypeNiveau = int.parse(idtypeN);
            //
            if(idtypeAnnee == anneeEnCour){
              //leleve est reinscrit
              var suivit = await DB.query2WhereidPers("suivit_repas",queryEleve[0]["id"],date);
              //Verification dans la bd
              if (suivit.isEmpty) {
                if(int.parse(heur) >= 8 && int.parse(heur) <= 14){
                  // Les eleve du jours
                  await DB.insert("suivit_repas", {
                    "id": idsuivitgen,
                    "idpersonne": queryEleve[0]["id"],
                    "present": "1",
                    "manger": "0",
                    "nbscan": "1",
                    "date": date,
                    "anneeScolaire": _campagneAnneeS[0]['description'],
                    "flagtransmis": "",
                  });
                  //
                  List<Map<String, dynamic>> querynbscan = await DB.queryNbrScan(date);
                  dataUser['nbscan'] = querynbscan[0]['nombre'].toString();
                  Fluttertoast.showToast(
                      msg: "Pointage pour la présence", //Présence enregistrée,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  /*
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text(
                      '')));
                  */
                } else if(int.parse(heur) >= 15 && int.parse(heur) <= 17){
                  //Les eleves du soires
                  await DB.insert("suivit_repas", {
                    "id": idsuivitgen,
                    "idpersonne": queryEleve[0]["id"],
                    "present": "1",
                    "manger": "0",
                    "nbscan": "1",
                    "date": date,
                    "anneeScolaire": _campagneAnneeS[0]['description'],
                    "flagtransmis": "",
                  });
                  //
                  List<Map<String, dynamic>> querynbscan = await DB.queryNbrScan(date);
                  dataUser['nbscan'] = querynbscan[0]['nombre'].toString();
                  Fluttertoast.showToast(
                      msg: "Pointage pour la présence",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                } else {
                  //Message d'error
                  Fluttertoast.showToast(
                      msg: "Désolé le scanne est possible entre 8h et 17h",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              } else if(suivit.isNotEmpty){
                if(int.parse(suivit[0]["nbscan"]) < 2 && suivit[0]["date"] == date && int.parse(heur) >= 11) {
                  //Si les heur ne son pas correcte
                  if(int.parse(heur) >= 12 && int.parse(heur) <= 17){
                    //update
                    await DB.updateWhereIdPers("suivit_repas", {
                      //"id": idsuivitgen,
                      //"idinscription": snap[0]["idInscription"],
                      //"present": "Present",
                      "manger": "1",
                      "nbscan": "2",
                      //"date": date,
                      "flagtransmis": ""
                    },queryEleve[0]["id"]);
                    //scan manger
                    //
                    List<Map<String, dynamic>> querynbscan = await DB.queryNbrScan(date);
                    dataUser['nbscan'] = querynbscan[0]['nombre'].toString();
                    Fluttertoast.showToast(
                        msg: "Pointage pour le manger",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  } else {
                    //Message d'error
                    Fluttertoast.showToast(
                        msg: "La journée est terminée, revenez demain !",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                } else if (int.parse(suivit[0]["nbscan"]) == 2 && suivit[0]["date"] == date && int.parse(heur) >= 11) {
                  //
                  List<Map<String, dynamic>> querynbscan = await DB.queryNbrScan(date);
                  dataUser['nbscan'] = querynbscan[0]['nombre'].toString();
                  Fluttertoast.showToast(
                      msg: "Vous êtes déjà servir",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                } else {
                  //
                  List<Map<String, dynamic>> querynbscan = await DB.queryNbrScan(date);
                  dataUser['nbscan'] = querynbscan[0]['nombre'].toString();
                  Fluttertoast.showToast(
                      msg: "Le scanne pour la nourriture début a partir de 12h !",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              }
            } else {
              //ssession expirer
              Fluttertoast.showToast(
                  msg: "Session expirée : Veuillez vous faire réinscrire !",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          } else {
            //Annee Scolaire Indispaunible
            Fluttertoast.showToast(
                msg: "Année Scolaire indisponible !",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        }
        //dataUser = {};
        return dataUser;
      } else if (queryEleve.isEmpty && queryPersonne_fonction.isNotEmpty) {
        //dataUser;
        dataUser = {
          'typefoncttemp': queryPersonne_fonction[0]['idtypefonction'],
        };
        Fluttertoast.showToast(
            msg: "Vous n'etes pas élève !",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        //
        return dataUser;
      } else if (queryPersonne_fonction.isEmpty && queryEleve.isEmpty){
        Fluttertoast.showToast(
            msg: "Bracelet non enregistrer : Ce bracelet n'est pas attribuer !",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        return dataUser;
      }
      else {}
      //dataUser = {};
      return dataUser;
    }
    //Fonction de get Nombre
    getNombre() async{
      //Map<String, dynamic> dataUser;
      List<Map<String, dynamic>> querynbscan = await DB.queryNbrScan(date);
      Map<String, dynamic> dataUser = {'nbscan': querynbscan[0]['nombre'].toString()};
      print(querynbscan[0]['nombre'].toString());
      //
      return dataUser;
    }


    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      _uid = response.id.substring(2);
      _uid = _uid.toUpperCase();
      print(_uid);
      if(mounted){
        setState((){
          //getUser(_uid);
          _uid;
        });
      }
    });

    return _uid != "" ?
    FutureBuilder(
        future: getUser(_uid),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          var snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Bracelet non attribuer ou ce bracelet n'appartient pas a un élève"),
            );
          }


          nbs = int.tryParse(snap['nbscan']) ?? 0;
          qte = nbs*150;

          print(nbs);

          return snap != null ?
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width/3,
                child: snap["typefoncttemp"] == "EV" ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //widget
                      Container(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(File("/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${snap['imagetemp']}")),
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
                                "${snap["nomtemp"]} ${snap["prenomtemp"]}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),
                    ],
                  ),
                ) :
                Center(
                  child: Card(
                    child: Text("Bracelet non autorise, Ce bracelet n'appartient pas a un eleve"),
                  ),
                ),
              ),
              // VerticalDivider(),//-------------------------------------------------
              Center(
                child: Container(
                  margin: EdgeInsets.only(left: 50.0),
                  width: MediaQuery.of(context).size.width/2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '$formattedDate',
                          style: TextStyle(color: Colors.black, fontSize: 60.0, fontWeight: FontWeight.bold,),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          '$date',
                          style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                        Text(
                          'Nombre d\'élèves scanné: ',
                          style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),
                        ),
                        nbs != 0 ?
                        Text(
                          '$nbs',
                          style: TextStyle(color: Colors.black, fontSize: 90.0),
                        ) :
                        Text(
                          '0',
                          style: TextStyle(color: Colors.black, fontSize: 90.0),),
                        Text(
                          'Quantité de nourriture a préparer en gramme (NB: 150g/élève) ',
                          style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold,),
                        ),
                        nbs != 0 ?
                        Text(
                          '$qte gramme(s)',
                          style: TextStyle(color: Colors.black, fontSize: 70.0),
                        ) :
                        Text(
                          '0',
                          style: TextStyle(color: Colors.black, fontSize: 90.0),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
              :
          Center(
            child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        //color: Colors.indigo,
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Vous n'etes pas eleve",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                )
            ),
          );
        }
    ) :
    //Si il n'y pas de bracelet scanner
    FutureBuilder(
        future: getNombre(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          var snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Probleme !"),
            );
          }


          nbs = int.tryParse(snap['nbscan']) ?? 0;
          qte = nbs*150;

          print(nbs);

          return Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width/3,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //widget
                      Container(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(File("")),
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
                                "",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
              // VerticalDivider(),//-------------------------------------------------
              Center(
                child: Container(
                  margin: EdgeInsets.only(left: 50.0),
                  width: MediaQuery.of(context).size.width/2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '$formattedDate',
                          style: TextStyle(color: Colors.black, fontSize: 60.0, fontWeight: FontWeight.bold,),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          '$date',
                          style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                        Text(
                          'Nombre d\'élèves scanné: ',
                          style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),
                        ),
                        nbs != 0 ?
                        Text(
                          '$nbs',
                          style: TextStyle(color: Colors.black, fontSize: 90.0),
                        ) :
                        Text(
                          '0',
                          style: TextStyle(color: Colors.black, fontSize: 90.0),),
                        Text(
                          'Quantité de nourriture a préparer en gramme (NB: 150g/élève) ',
                          style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold,),
                        ),
                        nbs != 0 ?
                        Text(
                          '$qte gramme(s)',
                          style: TextStyle(color: Colors.black, fontSize: 70.0),
                        ) :
                        Text(
                          '0',
                          style: TextStyle(color: Colors.black, fontSize: 90.0),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}