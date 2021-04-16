
//Page pour visionner les video sur l'app
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neeko/neeko.dart';
import 'package:pam/database/database.dart';

class Visionnage extends StatefulWidget {
  @override
  _VisionnageState createState() => _VisionnageState();
}

class _VisionnageState extends State<Visionnage> {

  VideoControllerWrapper _controllerWrapper;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }

  @override
  void dispose() {
    print("Sortir des video");
    SystemChrome.restoreSystemUIOverlays();

    if (_controllerWrapper.controller.value.isPlaying) _controllerWrapper.controller. pause();
    //_controllerWrapper.controller.removeListener(_controllerWrapper.controller.initialize());
    //_controllerWrapper.controller.value = null;
    //_controllerWrapper = null;
    //_controllerWrapper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final id = ModalRoute.of(context).settings.arguments;
    //Selection de video de presentation agriculture dans la base de donner
    //***********************************************************************
    Future<List<Map<String, dynamic>>> Media() async{
      List<Map<String, dynamic>> queryRows = await DB.queryMedia(id);
      return queryRows;
    }
    final _Media = FutureBuilder(
        future: Media(),
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

          _controllerWrapper  = VideoControllerWrapper(
              DataSource.file(
                  File("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[0]['media_file']}")));

          return Center(
            child: Container(
              //margin: EdgeInsets.only(left: 50.0, right: 50.0),
              child: Card(
                elevation: 5,
                child: NeekoPlayerWidget(
                  videoControllerWrapper: _controllerWrapper,
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print("partager");
                        })
                  ],
                ),
              ),
            ),
          );
        }
    );

    return Scaffold(
      appBar: AppBar(),
      body: _Media,
    );
  }
}