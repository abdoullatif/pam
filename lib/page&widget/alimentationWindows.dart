import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neeko/neeko.dart';
import 'package:pam/database/database.dart';

import 'phoneCall.dart';
import 'sous-categorieAlimentation.dart';


class AlimentationWindows extends StatefulWidget {
  @override
  _AlimentationWindowsState createState() => _AlimentationWindowsState();
}

class _AlimentationWindowsState extends State<AlimentationWindows> {

  VideoControllerWrapper _controllerWrapper;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }

  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();
    if (_controllerWrapper.controller.value.isPlaying) _controllerWrapper.controller. pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    var name;
    final categ = ModalRoute.of(context).settings.arguments;
    //Selection de video de presentation agriculture dans la base de donner
    //***********************************************************************
    Future<List<Map<String, dynamic>>> MediaPresentation() async{
      var _parametre = await DB.initTabquery();
      if(_parametre[0]['langue'] != "" || _parametre[0]['langue'] != null) {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaCateg(categ,_parametre[0]['langue']);
        return queryRows;
      } else {
        String Langue = "Français";
        List<Map<String, dynamic>> queryRows = await DB.queryMediaCateg(categ,Langue);
        return queryRows;
      }
    }
    final _VideoPresentation = FutureBuilder(
        future: MediaPresentation(),
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
          if(snap.isNotEmpty){

            _controllerWrapper = VideoControllerWrapper(
                DataSource.file(
                    File("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[0]['media_file']}")));

            return Container(
              //margin: EdgeInsets.only(left: 50.0, right: 50.0),
              child: Card(
                elevation: 10,
                child: NeekoPlayerWidget(
                  videoControllerWrapper: _controllerWrapper,
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print("");
                        })
                  ],
                ),
              ),
            );
          } else {
            return Center(
              //margin: EdgeInsets.only(left: 50.0, right: 50.0),
              child: Card(
                child: Text("Video non disponible !"),
              ),
            );
          }
        }
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/backgroundempty.png"),
              fit: BoxFit.cover,
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/banner2.png"),
                      fit: BoxFit.cover,
                    )
                ),
              ),
              new Container(
                child: Center(
                  child: Container(
                      color: Colors.black,
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text("Alimentation", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),),
                        ),
                      )
                  ),
                ),
              ),
              // Listview horizontal start
              Container(
                  height: 120.0,
                  child: Center(
                      child: new Container(
                        margin: EdgeInsets.only(left: 80.0, right: 80.0),
                        padding: EdgeInsets.all(15.0),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            RaisedButton(
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              color: Colors.transparent,
                              disabledColor: Colors.transparent,
                              onPressed: (){
                                name = "Laitiers";
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                                );
                              },
                              child: Image.asset("images/laitier.png"),
                            ),
                            RaisedButton(
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              color: Colors.transparent,
                              disabledColor: Colors.transparent,
                              onPressed: (){
                                name = "Fruits";
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                                );
                              },
                              child: Image.asset("images/fruit.png"),
                            ),
                            RaisedButton(
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              color: Colors.transparent,
                              disabledColor: Colors.transparent,
                              onPressed: (){
                                name = "Fruits Secs";
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                                );
                              },
                              child: Image.asset("images/fruit_secs.png"),
                            ),
                            RaisedButton(
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              color: Colors.transparent,
                              disabledColor: Colors.transparent,
                              onPressed: (){
                                name = "Legumes";
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                                );
                              },
                              child: Image.asset("images/legume.png"),
                            ),
                            RaisedButton(
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              color: Colors.transparent,
                              disabledColor: Colors.transparent,
                              onPressed: (){
                                name = "Pain";
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                                );
                              },
                              child: Image.asset("images/pain.png"),
                            ),
                            RaisedButton(
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              color: Colors.transparent,
                              disabledColor: Colors.transparent,
                              onPressed: (){
                                name = "Viandes";
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                                );
                              },
                              child: Image.asset("images/viande.png"),
                            ),
                          ],
                        ),
                      )

                  )

              ),
              Divider(
                height: 50.0,
                thickness: 3,
                //color: Colors.white70,
                indent: 50.0,
                endIndent: 50.0,
              ),
              //_VideoPresentation,
              _VideoPresentation,
              SizedBox(height: 25,),
            ],
          ),
        ),
      ),
    );
  }
}