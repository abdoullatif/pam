import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';
import 'package:pam/database/database.dart';

class SuivitEnfant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SuivitEnfantPannel(),
    );
  }
}


class SuivitEnfantPannel extends StatefulWidget {
  @override
  _SuivitEnfantPannelState createState() => _SuivitEnfantPannelState();
}

class _SuivitEnfantPannelState extends State<SuivitEnfantPannel> {

  @override
  Widget build(BuildContext context) {
    //
    String id = ModalRoute.of(context).settings.arguments;

    //Removelastchar fonction
    String removeLastChar(String s) {
      return (s == null || s.length == 0)
          ? null
          : (s.substring(0, s.length - 1));
    }

    //Tableau Enfant
    Future<List<Map<String, dynamic>>> suivit_enfant_tableau() async{
      List<Map<String, dynamic>> queryPerson = await DB.querySuivitEnfantTab(id);
      return queryPerson;
    }
    //Graphe d'evolution du poids de l'enfant
    Future<List<Map<String, dynamic>>> poids_enfant() async{
      //print(snap[0]['idgrossesse']);
      List<Map<String, dynamic>> queryPerson = await DB.querySuivitEnfant(id);
      return queryPerson;
    }
    //Graphe d'evolution du taille de la enfant
    Future<List<Map<String, dynamic>>> taille_enfant() async{
      //print(snap[0]['idgrossesse']);
      List<Map<String, dynamic>> queryPerson = await DB.querySuivitEnfantTaille(id);
      return queryPerson;
    }

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width/1.2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //
              Container(
                //color: Colors.indigo,
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      //height: 50.0,
                      child: Text(
                        "Information de suivit de l'enfant",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
              ),
              //
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/4,
                    child: FutureBuilder(
                        future: suivit_enfant_tableau(),
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
                          //print(suivit_reponse);
                          return DataTable(
                            columns: [
                              //DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Poids')),
                              DataColumn(label: Text('Taille')),
                            ],
                            rows:
                            suivit_reponse // Loops through dataColumnText, each iteration assigning the value to element
                                .map(
                              ((element) => DataRow(
                                cells: <DataCell>[
                                  //DataCell(Text(element["date"])), //Extracting from Map element the value
                                  DataCell(Text(element["dateSuivit"])),
                                  DataCell(Text(element["poids"])),
                                  DataCell(Text(element["taille"])),
                                ],
                              )),
                            )
                                .toList(),
                          );
                        }
                    ),
                  ),
                  SizedBox(width: 40.0),
                  VerticalDivider(),
                  SizedBox(width: 40.0),
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: poids_enfant(),
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
                              int n = poids_reponse.length;

                              List<List<String>> listTab2 = new List();
                              poids_reponse.forEach((element) {element.forEach((key, val) {
                                List<String> listTab = new List();
                                listTab= [element['dateSuivit'],element['poids']];
                                listTab2.add(listTab);
                              });});
                              //print(listTab);
                              //print(listTab2);
                              // X value -> Y value
                              final items = List<String>.generate(n, (i) => "Item $i");

                              if(poids_reponse.isEmpty){
                                return Center(child: Text("pas de suivit"),);
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
                        ),
                        //
                        SizedBox(height: 40.0),
                        //
                        FutureBuilder(
                            future: taille_enfant(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              List taille_reponse = snapshot.data;
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
                              const myData = [
                                ["2020-09-25", "78"],
                                ["2020-09-26", "20"],
                                ["2020-09-27", "30"],
                              ];
                              //
                              int n = taille_reponse.length;

                              List<List<String>> listTab2 = new List();

                              //String p =taille_reponse.toString().replaceFirst("[", "").replaceAll("{", "[").replaceAll("},", "]").replaceAll("}", "]").replaceAll("dateSuivit: ", "").replaceAll(" taille: ", "");
                              print(taille_reponse);
                              //var o = removeLastChar(p);
                              //var pp = o.split(" ");
                              taille_reponse.forEach((element) {element.forEach((key, val) {
                                List<String> listTab = new List();
                                listTab= [element['dateSuivit'],element['taille']];
                                listTab2.add(listTab);
                                print(listTab);
                              } );});
                              print(listTab2);
                              // X value -> Y value
                              final items = List<String>.generate(n, (i) => "Item $i");

                              if(taille_reponse.isEmpty){
                                return Center(child: Text("pas de suivit"),);
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
