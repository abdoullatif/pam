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

class UserAgriculteur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgriculteurPannel();
  }
}


class AgriculteurPannel extends StatefulWidget {
  @override
  _AgriculteurPannelState createState() => _AgriculteurPannelState();
}

class _AgriculteurPannelState extends State<AgriculteurPannel> {

  final _formKey5 = GlobalKey<FormState>();

  //Culture
  TextEditingController _datedebut = TextEditingController();
  TextEditingController _datefin = TextEditingController();
  TextEditingController _superficie = TextEditingController();
  TextEditingController _typeculture = TextEditingController();
  TextEditingController _quantite = TextEditingController();
  TextEditingController _QteStock = TextEditingController();

  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    //Donne personne garder en memoire
    var idtypefonction = '';
    //asynchrone
    idtypefonction = StorageUtil.getString("idtypefonction");

    var dateNow = new DateTime.now();
    //
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();
    //
    String id = ModalRoute.of(context).settings.arguments;

    Future<List<Map<String, dynamic>>> userprofil() async{
      List<Map<String, dynamic>> queryPerson = await DB.queryUserAgri(id);
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
                            subtitle: Text('date de debut: ${culture[index]["debut"]} \nDate de fin prevu: ${culture[index]["fin"]} \nQuantite de semence: ${culture[index]["quantite"]} Kg \nQuantite en Stock: ${culture[index]["QteStock"]} Kg'),
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
                                    hintText: "Quantité de Semence (Kilogramme)",
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
                                        String iddetcultgen = Param.device+"-"+randomAlphaNumeric(10);
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
                                        Fluttertoast.showToast(
                                            msg: "Enregistrement effectué avec succès !",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 5,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 20.0
                                        );
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

          return snap.isEmpty ? Center(
            child: Text("Un probleme est survenir lors du chargement des informations !"),
          ) :
          _Culture;
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

