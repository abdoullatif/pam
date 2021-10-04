
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
import 'package:pam/model/parametre.dart';
import 'package:random_string/random_string.dart';

import 'ModifStock.dart';
import 'suivitFemme.dart';
import 'suivit_enfant.dart';

class UserFemme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FemmePannel();
  }
}

class FemmePannel extends StatefulWidget {
  @override
  _FemmePannelState createState() => _FemmePannelState();
}

class _FemmePannelState extends State<FemmePannel> {
  //SetState
  StateSetter _setState;

  //Questionnaire femme enceinte
  String centre_sante;
  String nbre_repas_femme;
  String nbre_fruit_femme;
  //String nbre_legume_femme;
  String nbre_viande_femme;
  String nbre_fonio_femme;
  //var
  String _type_femme = "";

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  //dropdown femme allaitante (enfant)
  TextEditingController _nom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _date_naissance = TextEditingController();

  String _genre = "";

  String _etat_femme = "";
  //
  //fonction_femme (idpersonne) async {}

  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {

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

    var dateNow = new DateTime.now();
    //
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();
    //
    String id = ModalRoute.of(context).settings.arguments;


    Future<List<Map<String, dynamic>>> userprofil() async{
      List<Map<String, dynamic>> queryPerson = await DB.queryUserFemm(id);
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

          //GENRE
          Future<void> SelectCodifGenre() async {
            List<Map<String, dynamic>> queryCodif = await DB.queryCodif("codification", "genre");
            return queryCodif;
          }
          //Enfant
          Future<List<Map<String, dynamic>>> Enfant() async{
            List<Map<String, dynamic>> queryRows = await DB.queryPersonEnfant(snap[0]["id"]);
            return queryRows;
          }
          //Combo femme enceinte
          Future<void> fonction_femme() async {
            List<Map<String, dynamic>> _status = await DB.querygro(snap[0]["id"]);
            //print(_status);
            List<Map<String, dynamic>> etat;
            if (_status[0]['status'] == "Femme Enceinte"){
              etat = [
                {"display": "Femme Allaitante", "value": "Femme Allaitante"},
                {"display": "Fausse Couche", "value": "Fausse Couche"}
              ];
              return etat;
            } else if (_status[0]['status'] == "Femme Allaitante" || _status[0]['status'] == "Fausse Couche"){
              etat = [
                {"display": "Femme Enceinte", "value": "Femme Enceinte"},
              ];
              return etat;
            }
          }
          //Graphe d'evolution du pods de la femme enceinte
          Future<List<Map<String, dynamic>>> poids_femme() async{
            print(snap[0]['idgrossesse']);
            List<Map<String, dynamic>> queryPerson = await DB.queryPoidsFemme(snap[0]['idgrossesse'],snap[0]['status']);
            return queryPerson;
          }
          //Graphe d'evolution du pods de la femme enceinte
          Future<List<Map<String, dynamic>>> poids_femme_tableau() async{
            print(snap[0]['idgrossesse']);
            List<Map<String, dynamic>> queryPerson = await DB.querySuivitFemmeTableau(snap[0]['idgrossesse'],snap[0]['status']);
            return queryPerson;
          }
          final _graphe_femme = FutureBuilder(
              future: poids_femme(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List poids_reponse = snapshot.data;
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
                //
                //
                //
                int n = poids_reponse.length;
                List<List<String>> listTab2 = new List();
                poids_reponse.forEach((element) {element.forEach((key, val) {
                  List<String> listTab = new List();
                  listTab= [element['dateSuivit'],element['poids']];
                  listTab2.add(listTab);
                });});
                print(listTab2);
                // X value -> Y value
                const myData = [
                  ["2020-09-25", "78"],
                  ["2020-09-26", "20"],
                  ["2020-09-27", "30"],
                ];
                final items = List<String>.generate(n, (i) => "Item $i");

                if(poids_reponse.isEmpty){
                  return Center();
                } else {
                  return Container(
                    height: 300.0,
                    child: LineChart(
                      lines: [
                        new Line<List<String>, String, String>(
                          data: listTab2,
                          xFn: (datum) => datum[0],
                          yFn: (datum) => datum[1],
                        ),
                      ],
                      chartPadding: new EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 30.0),
                    ),
                  );
                }
              }
          );
          //les info du graphics femme enceinte /*******************************
          final _grossesse = Row(
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
                                "Contact: ${snap[0]["numero"]}",
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
                                "Age: ${snap[0]["date_naissance"]} ans",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      /*
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
                      */
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 10.0),
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
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Etat: ${snap[0]["status"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),
                      SizedBox(height: 25.0),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xff01A0C7),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => SuivitFemme(),settings: RouteSettings(arguments: DonneeRoute(
                                '${snap[0]["id"]}', '${snap[0]["status"]}'
                            )),),
                            );
                          },
                          child: Text("Suivi nutritionnel",
                            textAlign: TextAlign.center,),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      snap[0]["status"] == "Femme Allaitante" ? Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xff01A0C7),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            //Si femme Allaitante
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "ENREGISTRER L'ENFANT",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState){
                                      _setState = setState;
                                      return Container(
                                        width: MediaQuery.of(context).size.width/2,
                                        child: Form(
                                          key: _formKey1,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  obscureText: false,
                                                  controller: _nom,
                                                  //style: style,
                                                  decoration: InputDecoration(
                                                    icon: Icon(Icons.account_box_outlined, color: Colors.blue),
                                                    hintText: "Entrer le nom",
                                                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                    enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                                                  ),
                                                  validator: (value) {
                                                    if (_nom.text.isEmpty) {
                                                      return 'Veuiller entrer une information';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 25.0),
                                                TextFormField(
                                                  obscureText: false,
                                                  controller: _prenom,
                                                  //style: style,
                                                  decoration: InputDecoration(
                                                    icon: Icon(Icons.account_box_outlined, color: Colors.blue),
                                                    hintText: "Entrer le prenom",
                                                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                    enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                                                  ),
                                                  validator: (value) {
                                                    if (_prenom.text.isEmpty) {
                                                      return 'Veuiller entrer une information';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 25.0),
                                                DropDownFormField(
                                                  titleText: 'Genre',
                                                  hintText: 'sexe',
                                                  value: _genre,
                                                  onSaved: (value) {
                                                    setState(() {
                                                      _genre = value;
                                                    });
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _genre = value;
                                                    });
                                                  },
                                                  dataSource: [
                                                    {"display": "Masculin", "value" : "Masculin"},
                                                    {"display": "Feminin", "value" : "Feminin"}
                                                  ],
                                                  textField: 'display',
                                                  valueField: 'value',
                                                  validator: (value) {
                                                    if (_genre == "") {
                                                      return 'Veuiller selectionner le genre';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 25.0),
                                                DateTimeField(
                                                  format: format,
                                                  controller: _date_naissance,
                                                  decoration: InputDecoration(
                                                    icon: Icon(Icons.date_range, color: Colors.blue),
                                                    hintText: "Entrer la date de naissance",
                                                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                    enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                                                  ),
                                                  onShowPicker: (context, currentValue) {
                                                    return showDatePicker(
                                                        context: context,
                                                        firstDate: DateTime(1900),
                                                        initialDate: currentValue ?? DateTime.now(),
                                                        lastDate: DateTime(2100));
                                                  },
                                                  validator: (value) {
                                                    if (_date_naissance.text.isEmpty) {
                                                      return 'Veuiller entrer une information';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 25.0),
                                                //
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Annuler',style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      onPressed: () {
                                        Navigator.of(context).pop('non');
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Enregistrer',style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      onPressed: () async{

                                        int anneeN = int.tryParse(date.substring(0,4));
                                        String svt_date = date.substring(4);
                                        int date_limit = anneeN + 3;
                                        String date_final = date_limit.toString() + svt_date;
                                        print(date);
                                        print(anneeN);
                                        print(svt_date);
                                        print(date_limit);
                                        print(date_final);

                                        if (_formKey1.currentState.validate()){
                                          //Requette
                                          List<Map<String, dynamic>> grossesse_femme = await DB.querygro(snap[0]["id"]);
                                          var _tab = await DB.initTabquery();
                                          String idenfgen = Param.device+"-"+randomAlphaNumeric(10);
                                          await DB.insert("enfant", {
                                            "id": idenfgen,
                                            "nom": _nom.text,
                                            "prenom": _prenom.text,
                                            "sexe": _genre,
                                            "dateNaissance": _date_naissance.text,
                                            "idgrossesse": grossesse_femme[0]['id'],
                                            "date_limit": date_final,
                                            "flagtransmis": "",
                                          });
                                          setState(() {
                                            _genre = '';
                                            _nom = TextEditingController()..text = '';
                                            _prenom = TextEditingController()..text = '';
                                            _date_naissance = TextEditingController()..text = '';
                                          });
                                          Fluttertoast.showToast(
                                              msg: "Enregistrement effectué avec succès !", //Présence enregistrée,
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                          Navigator.of(context).pop('');
                                        }
                                      },
                                    ),
                                  ],
                                  //shape: CircleBorder(),
                                );
                              },
                            );
                          },
                          child: Text("Enfant",
                            textAlign: TextAlign.center,),
                        ),
                      ) : Container(),
                      SizedBox(height: 25.0),
                    ],
                  ),
                ),
              ),
              VerticalDivider(),//-------------------------------------------------
              Container(
                margin: EdgeInsets.all(50),
                width: MediaQuery.of(context).size.width/2,
                child: DefaultTabController(
                    length: 3,
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
                                    child: Text("ETAT"),
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
                                    child: Text("ENFANT"),
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
                                    child: Text("ETAT DE LA FEMME"),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      body: TabBarView(children: [
                        Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                //Questionnaire
                                SizedBox(height: 25.0),
                                Container(
                                  //color: Colors.indigo,
                                    margin: EdgeInsets.only(bottom: 30.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "Etat de la femme",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      // Verification en fonction du status
                                      FutureBuilder(
                                          future: fonction_femme(),
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
                                              titleText: 'Etat de la femme',
                                              hintText: 'FA/FE/FC',
                                              value: _etat_femme,
                                              onSaved: (value) {
                                                setState(() {
                                                  _etat_femme = value;
                                                });
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  _etat_femme = value;
                                                });
                                              },
                                              dataSource: snap,
                                              textField: 'display',
                                              valueField: 'value',
                                              validator: (value) {
                                                if (_etat_femme == "") {
                                                  return 'Veuiller Slectionner L\'etat de femme enceinte';
                                                }
                                                return null;
                                              },
                                            );
                                          }
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
                                              //verification status
                                              var _status = await DB.querygro(snap[0]["id"]);
                                              if (_status[0]["status"] == "Femme Allaitante" || _status[0]["status"] == "Fausse Couche"){
                                                //
                                                var _tab = await DB.initTabquery();
                                                String idgrosfemmegen = Param.device+"-"+randomAlphaNumeric(10);
                                                await DB.insert("grossesse", {
                                                  "id": idgrosfemmegen,
                                                  "idpersonne": snap[0]["id"],
                                                  "status": _etat_femme,
                                                  "ordre": _status[0]['ordre'] + 1,
                                                  "flagtransmis": "",
                                                });
                                                setState(() {
                                                  _etat_femme = '';
                                                });
                                                Fluttertoast.showToast(
                                                    msg: "Changement d\'etat effectué avec succès !", //Présence enregistrée, Enregistrement effectué avec succès !
                                                    toastLength: Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor: Colors.green,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              } else if (_status[0]["status"] == "Femme Enceinte"){
                                                //Enceinte => Allaintante
                                                print("Le status actuel dans la bd "+_status[0]["status"]);
                                                print("le status mis a jour "+_etat_femme);
                                                print("l'identifiant est "+ _status[0]["id"]);
                                                await  DB.updateGrossesse("grossesse", {
                                                  "status": _etat_femme,
                                                  "flagtransmis": "",
                                                }, _status[0]["id"]);
                                                setState(() {
                                                  _etat_femme = '';
                                                });
                                                Fluttertoast.showToast(
                                                    msg: "Changement d\'etat effectué avec succès !",
                                                    toastLength: Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor: Colors.green,
                                                    textColor: Colors.white,
                                                    fontSize: 20.0
                                                );
                                              } else {}
                                            }
                                            //verification bd
                                          },
                                          child: Text("Valider",
                                            textAlign: TextAlign.center,),
                                        ),
                                      ),
                                      SizedBox(height: 25.0),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //ENFANT
                        FutureBuilder(
                            future: Enfant(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              List<Map<String, dynamic>> info_enfant = snapshot.data;
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              //si il ya une eurreur lor du chargement
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text("Erreur est survenue !"),
                                );
                              }
                              print(snap);
                              int n = info_enfant == null ? 0 : int.tryParse(info_enfant.length.toString()) ?? 0;
                              final items = List<String>.generate(n, (i) => "Item $i");

                              //print("kghlkjk $info_enfant");

                              return info_enfant.isNotEmpty ?
                              Column(
                                  children: <Widget>[
                                    SizedBox(height: 25.0),
                                    Container(
                                      //color: Colors.indigo,
                                        margin: EdgeInsets.only(bottom: 10.0),
                                        child: Align(
                                          //alignment: Alignment.center,
                                          child: SizedBox(
                                            //height: 50.0,
                                            child: Text(
                                              "Nombre d'enfant : $n",
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
                                                //move
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => SuivitEnfant(),settings: RouteSettings(arguments: '${info_enfant[index]["id"]}')),);
                                              },
                                              child: Card(
                                                margin: EdgeInsets.only(top: 25.0,),
                                                elevation: 2.0,
                                                child: ListTile(
                                                  title: Text('${info_enfant[index]["nom"]} ${info_enfant[index]["prenom"]}'),
                                                  subtitle: Text('Enfant'),
                                                ),
                                              )
                                          );
                                        },
                                      ),
                                    )
                                  ]
                              ) : Center(child: Text("Pas d'enfant enregistrer !"),);
                            }
                        ),
                        //GRAPHE
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              //chart
                              SizedBox(height: 25.0),
                              _graphe_femme,
                              SizedBox(height: 25.0),
                              //
                              FutureBuilder(
                                  future: poids_femme_tableau(),
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    List<Map<String, dynamic>> suivit_reponse = snapshot.data;
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
                                    int n = suivit_reponse.length;
                                    final items = List<String>.generate(n, (i) => "Item $i");
                                    print(suivit_reponse);
                                    return DataTable(
                                      columns: [
                                        //DataColumn(label: Text('Date')),
                                        DataColumn(label: Text('Date')),
                                        DataColumn(label: Text('Poids')),
                                        DataColumn(label: Text('Taille')),
                                        DataColumn(label: Text('Imc')),
                                        DataColumn(label: Text('Perimetre Braciale')),
                                      ],
                                      rows:
                                      suivit_reponse // Loops through dataColumnText, each iteration assigning the value to element
                                          .map(
                                        ((element) => DataRow(
                                          cells: <DataCell>[
                                            //DataCell(Text(element["date"])), //Extracting from Map element the value
                                            DataCell(Text(element["datesuivit"])),
                                            DataCell(Text(element["poids"])),
                                            DataCell(Text(element["taille"])),
                                            DataCell(Text(element["imc"])),
                                            DataCell(Text(element["pb"])),
                                          ],
                                        )),
                                      )
                                          .toList(),
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),
                      ]),
                    )
                ),
              ),
            ],
          );

          return snap.isEmpty ? Center(
            child: Text("Un probleme est survenir lors du chargement des informations !"),
          ) :
          _grossesse;
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