
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:fcharts/fcharts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/database/database.dart';

import 'package:pam/components/ModifStock.dart';
import'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class AdminUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Admin_User();
  }
}

class Admin_User extends StatefulWidget {
  @override
  _Admin_UserState createState() => _Admin_UserState();
}

class _Admin_UserState extends State<Admin_User> {
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

  //
  //Questionnaire femme enceinte
  String centre_sante;
  String nbre_repas_femme;
  String nbre_fruit_femme;
  //String nbre_legume_femme;
  String nbre_viande_femme;
  String nbre_fonio_femme;
  TextEditingController _nbre_legume_femme = TextEditingController();
  TextEditingController _acces_eau_femme = TextEditingController();
  //var
  String _type_femme = "";

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey22 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();


  //Culture
  TextEditingController _datedebut = TextEditingController();
  TextEditingController _datefin = TextEditingController();
  TextEditingController _superficie = TextEditingController();
  TextEditingController _typeculture = TextEditingController();
  TextEditingController _quantite = TextEditingController();
  TextEditingController _QteStock = TextEditingController();


  //dropdown femme enceinte
  //List<Map<String, dynamic>> etat;
  String _etat_femme = "";
  //
  fonction_femme (idpersonne) async {

  }

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
      if(idtypefonction == "AA"){
        List<Map<String, dynamic>> queryPerson = await DB.queryUserAgri(id);
        return queryPerson;
      } else if (idtypefonction == "AFE") {
        List<Map<String, dynamic>> queryPerson = await DB.queryUserFemm(id);
        return queryPerson;
      } else {
        var _campagneAnneeS = await DB.queryAnneeScolaire();
        String a = _campagneAnneeS[0]['description'];
        String anneeSimple = a.substring(5);
        print(a);
        print(anneeSimple);
        List<Map<String, dynamic>> queryPerson = await DB.queryUserElev(id,anneeSimple,a);
        return queryPerson;
      }
    }

    final _user = FutureBuilder(
        future: userprofil(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Map<String, dynamic>> snap = snapshot.data;
          //Cultures
          Future<List<Map<String, dynamic>>> culture() async {
            List<Map<String, dynamic>> queryPerson = await DB.queryCulture(snap[0]['iddetenteur_plantation']);
            return queryPerson;
          }
          final _culture = FutureBuilder(
              future: culture(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Map<String, dynamic>> culture = snapshot.data;
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
                int n = culture.length;
                final items = List<String>.generate(n, (i) => "Item $i");
                FutureOr onGoBack(dynamic value) {
                  setState(() {});
                }
                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(top: 25.0,),
                        elevation: 2.0,
                        child: RaisedButton(
                          child: ListTile(
                            title: Text('Culture: ${culture[index]["idtypeculture"]} \nSuperficie: ${culture[index]["superficie"]} metre carre'),
                            subtitle: Text('date de debut: ${culture[index]["debut"]} \nDate de fin prevu: ${culture[index]["fin"]} \nQuantite prevu: ${culture[index]["quantite"]} Kg \nQuantite en Stock: ${culture[index]["QteStock"]} Kg'),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.all(0.0),
                          color: Colors.transparent,
                          disabledColor: Colors.transparent,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ModifStock(),settings: RouteSettings(arguments: '${culture[index]["id"]}')),).then(onGoBack);
                          },
                        ),
                      );
                    }
                );
              }
          );
          //les agriculteurs
          final _Culture = Row(
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
                      SizedBox(height: 15.0),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Groupement: ${snap[0]["groupement"]}",
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
                                "Nombre de membres : ${snap[0]["membre"]}",
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
                                "Nombre d'hommes : ${snap[0]["homme"]}",
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
                                "Nombre de femmes : ${snap[0]["femme"]}",
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
                                "Superficie: ${snap[0]["superficie"]} metre carré",
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
                ),
              ),
              VerticalDivider(),//-------------------------------------------------
              Container(
                margin: EdgeInsets.only(left:50.0, right:50.0),
                //padding: EdgeInsets.only(left: 50, right: 50),
                width: MediaQuery.of(context).size.width/2,
                child: DefaultTabController(
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
                                    child: Text("ENREGISTRER UNE CULTURE"),
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
                                    child: Text("VOIR LES CULTURES"),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      body: TabBarView(children: [
                        Form(
                          key: _formKey5,
                          child: SingleChildScrollView(
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
                                //widget
                                DateTimeField(
                                  format: format,
                                  controller: _datedebut,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.date_range, color: Colors.blue),
                                    hintText: "Entrer la date de debut",
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
                                    if (_datefin.text.isEmpty) {
                                      return 'Veuiller entrer une information';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 25.0),
                                DateTimeField(
                                  format: format,
                                  controller: _datefin,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.date_range, color: Colors.blue),
                                    hintText: "Entrer la date de fin prevu",
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
                                    if (_datefin.text.isEmpty) {
                                      return 'Veuiller entrer une information';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 25.0),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  controller: _superficie,
                                  decoration: InputDecoration(
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                    icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                                    hintText: "superficie",
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
                                  obscureText: false,
                                  controller: _typeculture,
                                  decoration: InputDecoration(
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    hintText: "Nom de la culture",
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
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  controller: _quantite,
                                  decoration: InputDecoration(
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                    icon: Icon(Icons.show_chart, color: Colors.blue),
                                    hintText: "Quantité prévu pour la culture en Kg (Sémance)",
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
                                      if (_formKey5.currentState.validate()) {
                                        //verification
                                        var _campagneAgri = await DB.queryCampagne();
                                        var _tab = await DB.initTabquery();
                                        String iddetcultgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                        //insertion du nom de la tablette
                                        await DB.insert("detenteur_culture", {
                                          "id": iddetcultgen,
                                          "iddetenteur_plantation": snap[0]["iddetenteur_plantation"],
                                          "datedebut": _datedebut.text,
                                          "datefinprevu": _datefin.text,
                                          "superficie": _superficie.text,
                                          "idtypeculture": _typeculture.text,
                                          "Quantiteprevu": _quantite.text,
                                          "QteStock": "0",
                                          "DateStock": "",
                                          "campagneAgricol": _campagneAgri[0]['description'],
                                          "flagtransmis": "",
                                        });
                                        setState(() {
                                          _datedebut = TextEditingController()..text = '';
                                          _datefin = TextEditingController()..text = '';
                                          _superficie = TextEditingController()..text = '';
                                          _typeculture = TextEditingController()..text = '';
                                          _quantite = TextEditingController()..text = '';
                                          _QteStock = TextEditingController()..text = '';
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
                        _culture,
                      ]),
                    )),
              ),
            ],
          );
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
                child: DefaultTabController(
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
                ),
              ),
            ],
          );

          //*****************************************************************************************
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
                List<String> listTab = new List();
                List<List<String>> listTab2 = new List();
                poids_reponse.forEach((element) {element.forEach((key, val) => listTab.add(val));});
                listTab2.add(listTab);
                print(listTab);
                print(listTab2);
                // X value -> Y value
                const myData = [
                  ["2020-09-25", "78"],
                  ["2020-09-26", "20"],
                  ["2020-09-27", "30"],
                  //["date4", "40kg"],
                  //["date5", "50kg"],
                  //["date6", "60kg"],
                  //["date7", "70kg"],
                  //["date8", "80kg"],
                  //["date9", "90kg"],
                  //["date10", "100kg"],
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
                                "Date de naissance: ${snap[0]["date_naissance"]}",
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
                                "Condition: ${snap[0]["status"]}",
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
                margin: EdgeInsets.all(50),
                width: MediaQuery.of(context).size.width/2,
                child: DefaultTabController(
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
                                    child: Text("SUIVIT D'ETAT DE LA FEMME"),
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
                                                String idgrosfemmegen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                await DB.insert("grossesse", {
                                                  "id": idgrosfemmegen,
                                                  "idpersonne": snap[0]["id"],
                                                  "status": _etat_femme,
                                                  "ordre": int.parse(_status[0]['ordre']) + 1,
                                                  "flagtransmis": "",
                                                });
                                                setState(() {
                                                  _etat_femme = '';
                                                });
                                                Scaffold
                                                    .of(context)
                                                    .showSnackBar(SnackBar(content: Text('Changement d\'etat effecter avec succes ! ')));
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
                                                Scaffold
                                                    .of(context)
                                                    .showSnackBar(SnackBar(content: Text('Changement d\'etat effecter avec succes ! ')));
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
                                //
                                Form(
                                  key: _formKey3,
                                  child: SingleChildScrollView(
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
                                        Container(
                                          //color: Colors.indigo,
                                            margin: EdgeInsets.only(bottom: 30.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                //height: 50.0,
                                                child: Text(
                                                  "Suivi nutritionnel des femmes enceintes et allaitantes",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                        /*
                                        DropDownFormField(
                                          titleText: 'Etes-vous une FA ? FE ? ou les 2 ?',
                                          hintText: 'FA/FE',
                                          value: _type_femme,
                                          onSaved: (value) {
                                            setState(() {
                                              _type_femme = value;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _type_femme = value;
                                            });
                                          },
                                          dataSource: [
                                            {"display": "Femme Enceinte", "value": "Femme Enceinte"},
                                            {"display": "Femme Allaitante", "value": "Femme Allaitante"},
                                            {"display": "Les 2", "value": "Les 2"}
                                          ],
                                          textField: 'display',
                                          valueField: 'value',
                                          validator: (value) {
                                            if (_type_femme == "") {
                                              return 'Veuiller Slectionner une localite';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 25.0),
                                        */
                                        DropDownFormField(
                                          titleText: 'Est-ce que vous etes rendu au moins une fois au CS pour un CPN/CPP dans le mois ?',
                                          hintText: 'Centre de sante',
                                          value: centre_sante,
                                          onSaved: (value) {
                                            setState(() {
                                              centre_sante = value;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              centre_sante = value;
                                            });
                                          },
                                          dataSource: [
                                            {"display": "Oui", "value": "Oui"},
                                            {"display": "Non", "value": "Non"}
                                          ],
                                          textField: 'display',
                                          valueField: 'value',
                                          validator: (value) {
                                            if (centre_sante == "") {
                                              return 'Veuiller Slectionner une localite';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 25.0),
                                        DropDownFormField(
                                          titleText: 'Combien de fois par jour vous mangez un repas ?',
                                          hintText: 'Mange',
                                          value: nbre_repas_femme,
                                          onSaved: (value) {
                                            setState(() {
                                              nbre_repas_femme = value;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              nbre_repas_femme = value;
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
                                            if (nbre_repas_femme == "") {
                                              return 'Veuiller Slectionner une localite';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 25.0),
                                        DropDownFormField(
                                          titleText: 'Combien de fois dans la semaine vous mangez des fruits ?',
                                          hintText: 'Mange',
                                          value: nbre_fruit_femme,
                                          onSaved: (value) {
                                            setState(() {
                                              nbre_fruit_femme = value;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              nbre_fruit_femme = value;
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
                                            if (nbre_fruit_femme == "") {
                                              return 'Veuiller Slectionner un nombre';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 25.0),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          obscureText: false,
                                          controller: _nbre_legume_femme,
                                          decoration: InputDecoration(
                                            //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                            //icon: Icon(Icons.show_chart, color: Colors.blue),
                                            hintText: "Combien de fois dans la semaine vous mangez des légumes ?",
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
                                          titleText: 'Combien de fois dans la semaine vous mangez de la viande, poisson/oeuf ?',
                                          hintText: 'Mange',
                                          value: nbre_viande_femme,
                                          onSaved: (value) {
                                            setState(() {
                                              nbre_viande_femme = value;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              nbre_viande_femme = value;
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
                                            if (nbre_viande_femme == "") {
                                              return 'Veuiller Slectionner un nombre';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 25.0),
                                        DropDownFormField(
                                          titleText: 'Combien de fois dans la semaine vous mangez du riz/fonio ?',
                                          hintText: 'Mange',
                                          value: nbre_fonio_femme,
                                          onSaved: (value) {
                                            setState(() {
                                              nbre_fonio_femme = value;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              nbre_fonio_femme = value;
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
                                            if (nbre_fonio_femme == "") {
                                              return 'Veuiller Slectionner un nombre';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 25.0),
                                        TextFormField(
                                          //keyboardType: TextInputType.number,
                                          obscureText: false,
                                          controller: _acces_eau_femme,
                                          decoration: InputDecoration(
                                            //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                            //icon: Icon(Icons.show_chart, color: Colors.blue),
                                            hintText: "Chez vous, d'où l’eau de boisson provient ?",
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
                                              if (_formKey3.currentState.validate()) {
                                                //
                                                //verification
                                                var _tab = await DB.initTabquery();

                                                String idquestfemmegen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                //
                                                await DB.insert("quiz_femmeEnceinte", {
                                                  "id": idquestfemmegen,
                                                  "idpersonne": snap[0]["id"],
                                                  "quiz1": snap[0]["status"],
                                                  "quiz2": centre_sante,
                                                  "quiz3": nbre_repas_femme,
                                                  "quiz4": nbre_fruit_femme,
                                                  "quiz5": _nbre_legume_femme.text,
                                                  "quiz6": nbre_viande_femme,
                                                  "quiz7": nbre_fonio_femme,
                                                  "quiz8": _acces_eau_femme.text,
                                                  "datequiz": date,
                                                  "typequiz": "Mensuel",
                                                  "flagtransmis": "",
                                                });
                                                setState(() {
                                                  centre_sante = '';
                                                  nbre_repas_femme = '';
                                                  nbre_fruit_femme = '';
                                                  _nbre_legume_femme = TextEditingController()..text = '';
                                                  nbre_viande_femme = '';
                                                  nbre_fonio_femme = '';
                                                  _acces_eau_femme = TextEditingController()..text = '';
                                                });
                                                Scaffold
                                                    .of(context)
                                                    .showSnackBar(SnackBar(content: Text('Enregistrement effectué avec succès !')));
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
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              //chart
                              SizedBox(height: 25.0),
                              _graphe_femme,
                            ],
                          ),
                        ),
                      ]),
                    )
                ),
              ),
            ],
          );
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
          return snap.isEmpty ? Center(
            child: Text("Un probleme est survenir lors du chargement des informations !"),
          ) :
          snap[0]["categories"] == "agriculteur" ? _Culture : (snap[0]["fonction"] == "FE" ? _grossesse : (snap[0]["fonction"] == "EV" ? _repas : Center(child: Text("Probleme  !"),)) );
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