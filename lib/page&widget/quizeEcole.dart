import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';


class QuizeEcole extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quize Ecole"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(right: 100.0,left: 100.0),
        child: Quize(),
      ),
    );
  }
}


class Quize extends StatefulWidget {
  @override
  _QuizeState createState() => _QuizeState();
}

class _QuizeState extends State<Quize> {

  //
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  //Bool
  bool hebdo = false;
  bool mens = false;
  bool eau = false;

  //
  var dateNow = new DateTime.now();


  //
  String type_question;

  //Questionnaire Eleve
  String nbre_repas_eleve;
  String nbre_fruit_eleve;
  String nbre_legume_eleve;
  String nbre_viande_eleve;
  String nbre_fonio_eleve;
  String latrine;
  String _acces_eau_eleve;
  TextEditingController _acces_eau_eleve_autre = TextEditingController();

  @override
  Widget build(BuildContext context) {

    //
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();

    //Donne personne garder en memoire
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

    //Condition eau
    if(_acces_eau_eleve != "Autre"){
      eau = false;
    } else {
      eau = true;
    }


    return SingleChildScrollView(
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
              key: _formKey,
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
                        if (_formKey.currentState.validate()) {
                          //verification
                          var _tab = await DB.initTabquery();
                          var _campagneAnneeS = await DB.queryAnneeScolaire();
                          String idquestelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                          //insertion dans la tablette
                          await DB.insert("quiz_eleve", {
                            "id": idquestelevgen,
                            "idpersonne": idecole,
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
                  DropDownFormField(
                    titleText: 'D’où l’eau de boisson provient dans ta maison',
                    hintText: 'Eau',
                    value: _acces_eau_eleve,
                    onSaved: (value) {
                      setState(() {
                        _acces_eau_eleve = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _acces_eau_eleve = value;
                      });
                    },
                    dataSource: [
                      {"display": "Eau de puit", "value": "Eau de puit"},
                      {"display": "Puit Local", "value": "Puit Local"},
                      {"display": "Puit Ameliore", "value": "Puit Ameliore"},
                      {"display": "Forage", "value": "Forage"},
                      {"display": "Autre", "value": "Autre"},
                    ],
                    textField: 'display',
                    valueField: 'value',
                    validator: (value) {
                      if (_acces_eau_eleve == "") {
                        return 'Veuiller Slectionner une valeur';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 25.0),
                  Visibility(
                    visible: eau,
                    child: Column(
                      children: [
                        TextFormField(
                          //keyboardType: TextInputType.number,
                          obscureText: false,
                          controller: _acces_eau_eleve_autre,
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
                      ],
                    ),
                  ),
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
                            "idecole": idecole,
                            "quiz1": "",
                            "quiz2": nbre_fruit_eleve,
                            "quiz3": nbre_legume_eleve,
                            "quiz4": nbre_viande_eleve,
                            "quiz5": nbre_fonio_eleve,
                            "quiz6": _acces_eau_eleve != "Autre" ? _acces_eau_eleve : _acces_eau_eleve_autre,
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
                            _acces_eau_eleve = '';
                            _acces_eau_eleve_autre = TextEditingController()..text = '';
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
    );
  }
}
