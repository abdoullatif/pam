import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neeko/neeko.dart';
import 'package:pam/database/database.dart';


class SousCatAlimentation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final name = ModalRoute.of(context).settings.arguments;
    var idvideo;
    String lang = "Français";
    String categ = "Alimentation";
    //Selection de video de presentation agriculture dans la base de donner
    //***********************************************************************
    Future<List<Map<String, dynamic>>> MediaPresentation() async{
      var _parametre = await DB.initTabquery();
      if(_parametre[0]['langue'] != "" || _parametre[0]['langue'] != null) {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaScategAliment(categ,name,_parametre[0]['langue']);
        return queryRows;
      } else {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaScategAliment(categ,name,lang);
        return queryRows;
      }

    }
    final _Sous_categories = FutureBuilder(
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
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      //margin: EdgeInsets.only(left: 50.0, right: 50.0),
                      child: Card(
                        elevation: 10,
                        child: NeekoPlayerWidget(
                          videoControllerWrapper: VideoControllerWrapper(
                              DataSource.file(
                                  File("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[0]['media_file']}"))),
                          actions: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  print("share");
                                })
                          ],
                        ),
                      ),
                    ),
                  )
                ],
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
        child: _Sous_categories,
      ),
    );
  }
}