import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:fcharts/fcharts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/database/database.dart';
import'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:pam/model/donnee_route.dart';
import 'package:random_string/random_string.dart';

import 'ModifStock.dart';
import 'suivitFemme.dart';

class UserEleve extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevePannel();
  }
}


class ElevePannel extends StatefulWidget {
  @override
  _ElevePannelState createState() => _ElevePannelState();
}

class _ElevePannelState extends State<ElevePannel> {

  //Questionnaire Eleve
  TextEditingController _poids_eleve = TextEditingController();
  TextEditingController _tail_eleve = TextEditingController();
  String nbre_repas_eleve;
  String nbre_fruit_eleve;
  String nbre_legume_eleve;
  String nbre_viande_eleve;
  String nbre_fonio_eleve;
  String latrine;
  TextEditingController _acces_eau_eleve = TextEditingController();

  //Bool
  bool hebdo = false;
  bool mens = false;

  //
  String type_question;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();

  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    //Donne personne garder en memoire
    var idtypefonction = '';

    //asynchrone
    idtypefonction = StorageUtil.getString("idtypefonction");

    //condition
    if (type_question == "Hebdomadaire"){
      hebdo = true;
      mens = false;
    } else if (type_question == "Mensuel"){
      hebdo = false;
      mens = true;
    } else {
      hebdo = false;
      mens = false;
    }

    var dateNow = new DateTime.now();
    //
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();
    //
    String id = ModalRoute.of(context).settings.arguments;


    Future<List<Map<String, dynamic>>> userprofil() async{
      var _campagneAnneeS = await DB.queryAnneeScolaire();
      String a = _campagneAnneeS[0]['description'];
      String anneeSimple = a.substring(5);
      print(a);
      print(anneeSimple);
      List<Map<String, dynamic>> queryPerson = await DB.queryUserElev(id,anneeSimple,a);
      return queryPerson;
    }

    final _user = FutureBuilder(
        future: userprofil(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Map<String, dynamic>> snap = snapshot.data;

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

          //Courbe de Repas
          Future<List<Map<String, dynamic>>> repas() async{
            List<Map<String, dynamic>> queryPerson = await DB.querySuiviRepas(snap[0]['id']);
            return queryPerson;
          }
          final _table_repas = FutureBuilder(
              future: repas(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Map<String, dynamic>> repas_reponse = snapshot.data;
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
                int n = repas_reponse.length;
                final items = List<String>.generate(n, (i) => "Item $i");
                return DataTable(
                  columns: [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Presence')),
                    DataColumn(label: Text('Repas')),
                  ],
                  rows:
                  repas_reponse // Loops through dataColumnText, each iteration assigning the value to element
                      .map(
                    ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(element["date"])), //Extracting from Map element the value
                        DataCell(Text(element["present"] == "1" ? "✔": "✖")),
                        DataCell(Text(element["manger"] == "1" ? "✔": "✖")),
                      ],
                    )),
                  )
                      .toList(),
                );
              }
          );

          final _repas = Row(
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
                                "Classe: ${snap[0]["description"]}",
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
                    ],
                  ),
                ),
              ),
              VerticalDivider(),//-------------------------------------------------
              Container(
                margin: EdgeInsets.only(left: 70),
                width: MediaQuery.of(context).size.width/2,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 25.0),
                      _table_repas,
                    ],
                  ),
                ),
                /*
                DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        bottom: TabBar(
                            unselectedLabelColor: Colors.indigo,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.indigo),
                            tabs: [
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(color: Colors.indigo, width: 1)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("QUESTIONNAIRE"),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(color: Colors.indigo, width: 1)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("EMARGEMENT"),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      body: TabBarView(children: [
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              //intro
                              Container(
                                  margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 10.0,
                                    ),
                                  )
                              ),
                              DropDownFormField(
                                titleText: 'Type de Questionnaire',
                                hintText: 'Questionnaire',
                                value: type_question,
                                onSaved: (value) {
                                  setState(() {
                                    type_question = value;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    type_question = value;
                                  });
                                },
                                dataSource: [
                                  {"display": "Hebdomadaire", "value": "Hebdomadaire"},
                                  {"display": "Mensuel", "value": "Mensuel"}
                                ],
                                textField: 'display',
                                valueField: 'value',
                              ),
                              SizedBox(height: 25.0),
                              Visibility(
                                visible: hebdo,
                                child: Form(
                                  key: _formKey22,
                                  child: Column(
                                    children: <Widget>[
                                      DropDownFormField(
                                        titleText: 'Combien de fois dans la semaine tu as mangé à l’école',
                                        hintText: 'Mange',
                                        value: nbre_repas_eleve,
                                        onSaved: (value) {
                                          setState(() {
                                            nbre_repas_eleve = value;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            nbre_repas_eleve = value;
                                          });
                                        },
                                        dataSource: [
                                          {"display": "1", "value": "1"},
                                          {"display": "2", "value": "2"},
                                          {"display": "3", "value": "3"},
                                          {"display": "4", "value": "4"},
                                          {"display": "5", "value": "5"},
                                          {"display": "6", "value": "6"},
                                          {"display": "7", "value": "7"},
                                          {"display": "8", "value": "8"},
                                          {"display": "9", "value": "9"},
                                          {"display": "10", "value": "10"}
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                        validator: (value) {
                                          if (nbre_repas_eleve == "") {
                                            return 'Veuiller Slectionner une valeur';
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
                                            if (_formKey22.currentState.validate()) {
                                              //verification
                                              var _tab = await DB.initTabquery();
                                              var _campagneAnneeS = await DB.queryAnneeScolaire();
                                              String idquestelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                              //insertion dans la tablette
                                              await DB.insert("quiz_eleve", {
                                                "id": idquestelevgen,
                                                "idpersonne": snap[0]["id"],
                                                "quiz1": nbre_repas_eleve,
                                                "quiz2": "",
                                                "quiz3": "",
                                                "quiz4": "",
                                                "quiz5": "",
                                                "quiz6": "",
                                                "quiz7": "",
                                                "datequiz": date,
                                                "typequiz": "Hebdomadaire",
                                                "anneeScolaire": _campagneAnneeS[0]['description'],
                                                "flagtransmis": "",
                                              });
                                              setState(() {
                                                nbre_repas_eleve = '';
                                              });
                                              Scaffold
                                                  .of(context)
                                                  .showSnackBar(SnackBar(content: Text('Enregistrement effectuer avec succes !')));
                                            }
                                          },
                                          child: Text("Enregistrer",
                                            textAlign: TextAlign.center,),
                                        ),
                                      ),
                                      SizedBox(height: 25.0),

                                    ],
                                  ),
                                ),
                              ),
                              //Mensuel
                              Visibility(
                                visible: mens,
                                child: Form(
                                  key: _formKey2,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        //color: Colors.indigo,
                                          margin: EdgeInsets.only(bottom: 30.0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              //height: 50.0,
                                              child: Text(
                                                "COMPOSITION DES REPAS A L’ECOLE / MES REPAS",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                      DropDownFormField(
                                        titleText: 'Combien de fois dans la semaine vous avez mangé des fruits a l’école',
                                        hintText: 'Mange',
                                        value: nbre_fruit_eleve,
                                        onSaved: (value) {
                                          setState(() {
                                            nbre_fruit_eleve = value;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            nbre_fruit_eleve = value;
                                          });
                                        },
                                        dataSource: [
                                          {"display": "1", "value": "1"},
                                          {"display": "2", "value": "2"},
                                          {"display": "3", "value": "3"},
                                          {"display": "4", "value": "4"},
                                          {"display": "5", "value": "5"},
                                          {"display": "6", "value": "6"},
                                          {"display": "7", "value": "7"},
                                          {"display": "8", "value": "8"},
                                          {"display": "9", "value": "9"},
                                          {"display": "10", "value": "10"}
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                        validator: (value) {
                                          if (nbre_fruit_eleve == "") {
                                            return 'Veuiller Slectionner une valeur';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 25.0),
                                      DropDownFormField(
                                        titleText: 'Combien de fois dans la semaine vous avez mange des légumes a l’ecole',
                                        hintText: 'Mange',
                                        value: nbre_legume_eleve,
                                        onSaved: (value) {
                                          setState(() {
                                            nbre_legume_eleve = value;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            nbre_legume_eleve = value;
                                          });
                                        },
                                        dataSource: [
                                          {"display": "1", "value": "1"},
                                          {"display": "2", "value": "2"},
                                          {"display": "3", "value": "3"},
                                          {"display": "4", "value": "4"},
                                          {"display": "5", "value": "5"},
                                          {"display": "6", "value": "6"},
                                          {"display": "7", "value": "7"},
                                          {"display": "8", "value": "8"},
                                          {"display": "9", "value": "9"},
                                          {"display": "10", "value": "10"}
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                        validator: (value) {
                                          if (nbre_legume_eleve == "") {
                                            return 'Veuiller Slectionner une valeur';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 25.0),
                                      DropDownFormField(
                                        titleText: 'Combien de fois dans la semaine vous avez mange de la viande, poisson/oeuf a l’ecole',
                                        hintText: 'Mange',
                                        value: nbre_viande_eleve,
                                        onSaved: (value) {
                                          setState(() {
                                            nbre_viande_eleve = value;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            nbre_viande_eleve = value;
                                          });
                                        },
                                        dataSource: [
                                          {"display": "1", "value": "1"},
                                          {"display": "2", "value": "2"},
                                          {"display": "3", "value": "3"},
                                          {"display": "4", "value": "4"},
                                          {"display": "5", "value": "5"},
                                          {"display": "6", "value": "6"},
                                          {"display": "7", "value": "7"},
                                          {"display": "8", "value": "8"},
                                          {"display": "9", "value": "9"},
                                          {"display": "10", "value": "10"}
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                        validator: (value) {
                                          if (nbre_viande_eleve == "") {
                                            return 'Veuiller Slectionner une valeur';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 25.0),
                                      DropDownFormField(
                                        titleText: 'Combien de fois par semaine vous avez mange du riz/fonio/pomme de terre a l’ecole',
                                        hintText: 'Mange',
                                        value: nbre_fonio_eleve,
                                        onSaved: (value) {
                                          setState(() {
                                            nbre_fonio_eleve = value;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            nbre_fonio_eleve = value;
                                          });
                                        },
                                        dataSource: [
                                          {"display": "1", "value": "1"},
                                          {"display": "2", "value": "2"},
                                          {"display": "3", "value": "3"},
                                          {"display": "4", "value": "4"},
                                          {"display": "5", "value": "5"},
                                          {"display": "6", "value": "6"},
                                          {"display": "7", "value": "7"},
                                          {"display": "8", "value": "8"},
                                          {"display": "9", "value": "9"},
                                          {"display": "10", "value": "10"}
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                        validator: (value) {
                                          if (nbre_fonio_eleve == "") {
                                            return 'Veuiller Slectionner une valeur';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 25.0),
                                      TextFormField(
                                        //keyboardType: TextInputType.number,
                                        obscureText: false,
                                        controller: _acces_eau_eleve,
                                        decoration: InputDecoration(
                                          //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                          //icon: Icon(Icons.show_chart, color: Colors.blue),
                                          hintText: "D’où l’eau de boisson provient dans ta maison",
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
                                      DropDownFormField(
                                        titleText: 'Utilisez-vous des latrines a la maison ?',
                                        hintText: 'latrine',
                                        value: latrine,
                                        onSaved: (value) {
                                          setState(() {
                                            latrine = value;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            latrine = value;
                                          });
                                        },
                                        dataSource: [
                                          {"display": "Air libre", "value": "Air libre"},
                                          {"display": "toilettes turques", "value": "toilettes turques"}
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                        validator: (value) {
                                          if (latrine == "") {
                                            return 'Veuiller Selectionner une valeur';
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
                                            if (_formKey2.currentState.validate()) {
                                              //
                                              //verification
                                              var _tab = await DB.initTabquery();
                                              var _campagneAnneeS = await DB.queryAnneeScolaire();
                                              String idquestelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                              //insertion dans la tablette
                                              await DB.insert("quiz_eleve", {
                                                "id": idquestelevgen,
                                                "idpersonne": snap[0]["id"],
                                                "quiz1": "",
                                                "quiz2": nbre_fruit_eleve,
                                                "quiz3": nbre_legume_eleve,
                                                "quiz4": nbre_viande_eleve,
                                                "quiz5": nbre_fonio_eleve,
                                                "quiz6": _acces_eau_eleve.text,
                                                "quiz7": latrine,
                                                "datequiz": date,
                                                "typequiz": "Mensuel",
                                                "anneeScolaire": _campagneAnneeS[0]['description'],
                                                "flagtransmis": "",
                                              });
                                              setState(() {
                                                nbre_repas_eleve = '';
                                                nbre_fruit_eleve = '';
                                                nbre_legume_eleve = '';
                                                nbre_fonio_eleve = '';
                                                nbre_viande_eleve = '';
                                                _acces_eau_eleve = TextEditingController()..text = '';
                                                latrine = '';
                                              });
                                              Scaffold
                                                  .of(context)
                                                  .showSnackBar(SnackBar(content: Text('Enregistrement effectuer avec succes !')));
                                            }
                                          },
                                          child: Text("Enregistrer",
                                            textAlign: TextAlign.center,),
                                        ),
                                      ),
                                      SizedBox(height: 25.0),

                                    ],
                                  ),
                                ),
                              ),
                              //
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 25.0),
                              _table_repas,
                            ],
                          ),
                        ),
                      ]),
                    )
                ),*/
              ),
            ],
          );

          return snap.isEmpty ? Center(
            child: Text("Un probleme est survenir lors du chargement des informations !"),
          ) :
          _repas;
        }
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: _user,
    );
  }
}

