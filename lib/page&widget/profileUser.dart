import 'dart:io';

import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';


class Profile extends StatelessWidget {
  //String id = "tablette1-25Z717A68H";
  var idpersonne = StorageUtil.getString("idpersonne");
  var idtypefonction = StorageUtil.getString("idtypefonction");

  @override
  Widget build(BuildContext context) {
    //fonction future bulder
    Future<List<Map<String, dynamic>>> userprofil() async{
      if(idtypefonction == "AG" || idtypefonction == "CA"){
        List<Map<String, dynamic>> queryPerson = await DB.queryUserAgri(idpersonne);
        return queryPerson;
      } else if (idtypefonction == "FE" || idtypefonction == "AFE") {
        List<Map<String, dynamic>> queryPerson = await DB.queryUserFemm(idpersonne);
        return queryPerson;
      } else {
        var _campagneAnneeS = await DB.queryAnneeScolaire();
        String a = _campagneAnneeS[0]['description'];
        String anneeSimple = a.substring(5);
        List<Map<String, dynamic>> queryPerson = await DB.queryUserElev(idpersonne,anneeSimple,a);
        return queryPerson;
      }
    }
    final _user = FutureBuilder(
        future: userprofil(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Map<String, dynamic>> snap = snapshot.data;
          //les cultures
          //Cultures
          Future<List<Map<String, dynamic>>> culture() async{
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
                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(top: 25.0,),
                        elevation: 2.0,
                        child: ListTile(
                          title: Text('Culture: ${culture[index]["idtypeculture"]} \nSuperficie: ${culture[index]["superficie"]} metre carre'),
                          subtitle: Text('date de debut: ${culture[index]["debut"]} \nDate de fin prevu: ${culture[index]["fin"]} \nQuantite prevu: ${culture[index]["quantite"]} Kg'),
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
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Plantation: ${snap[0]["plantation"]}",
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
                                "Superficie: ${snap[0]["superficie"]} hectares",
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
                    length: 1,
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
                                    child: Text("MES CULTURE"),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      body: TabBarView(children: [
                        _culture,
                      ]),
                    )),
              ),
            ],
          );
          //Courbe de Repas
          Future<List<Map<String, dynamic>>> repas() async{
            print(snap[0]['idinscription']);
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
                print(repas_reponse);
                final items = List<String>.generate(n, (i) => "Item $i");
                return DataTable(
                  columns: [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Present')),
                    DataColumn(label: Text('Manger')),
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
                  ).toList(),
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
                    ],
                  ),
                ),
              ),
              VerticalDivider(),//-------------------------------------------------
              Container(
                margin: EdgeInsets.all(50),
                width: MediaQuery.of(context).size.width/2,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //intro
                      Container(
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Emargement",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      _table_repas,
                    ],
                  ),
                ),
              ),
            ],
          );
          //Graphe d'evolution du pods de la femme enceinte
          Future<List<Map<String, dynamic>>> poids_femme() async{
            List<Map<String, dynamic>> queryPerson = await DB.queryPoidsFemme(snap[0]['idgrossesse'],snap[0]['status']);
            return queryPerson;
          }
          final _graphe_femme = FutureBuilder(
              future: poids_femme(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Map<String, dynamic>> poids_reponse = snapshot.data;
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
                int n = poids_reponse.length;
                List<String> listTab = new List();
                List<List<String>> listTab2 = new List();
                poids_reponse.forEach((element) {element.forEach((key, val) => listTab.add(val));});
                listTab2.add(listTab);
                final items = List<String>.generate(n, (i) => "Item $i");
                // X value -> Y value
                const myData = [
                  ["date1", "10kg"],
                  ["date2", "20kg"],
                  //["date3", "30kg"],
                  //["date4", "40kg"],
                  //["date5", "50kg"],
                  //["date6", "60kg"],
                  //["date7", "70kg"],
                  //["date8", "80kg"],
                  //["date9", "90kg"],
                  //["date10", "100kg"],
                ];
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
                                "Age: ${snap[0]["date_naissance"]} ans",
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
                                "Date debut: ${snap[0]["datedebut"]}",
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
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //intro
                      Container(
                        margin: EdgeInsets.only(bottom: 30.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            //height: 50.0,
                            child: Text(
                              "Suivit etat de la femme enceinte",
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //chart
                      _graphe_femme,
                    ],
                  ),
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
          if(snap.isNotEmpty){
            return snap[0]["categories"] == "agriculteur" ? _Culture : (snap[0]["fonction"] == "FE" ? _grossesse : _repas);
          } else {
            return Center(
              child: Card(
                child: Text("Information non disponible, une erreur c'est produite !"),
              ),
            );
          }
        }
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: _user,
      ),
    );
  }
}