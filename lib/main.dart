//package
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/database/database.dart';
//Synchronisation
import 'package:pam/synchro/server_to_local.dart';
import 'package:pam/synchro/records.dart';
import 'package:pam/synchro/Videos.dart';

import 'page&widget/slider.dart';

//
var synchronisation;
var records;
var videos;

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  await StorageUtil.getInstance();
  //Recuperation des donnees dans la tablette
  List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
  if(tab.isNotEmpty){
    //Synchronisation des donnees
    synchronisation = Synchro("/data/user/0/com.tulipind.pam/databasespamdb",
        "/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/"
        ,"uploads/",tab[0]['user'],tab[0]['mdp'],tab[0]['dbname'],tab[0]['ip_server'],tab[0]['adresse_server']);
    //Synchronisation des records
    records = Records("/data/user/0/com.tulipind.pam/databasespamdb",
        "/storage/emulated/0/Android/data/com.tulipind.pam/files/"
        ,"vocal/",tab[0]['user'],tab[0]['mdp'],tab[0]['dbname'],tab[0]['ip_server'],tab[0]['adresse_server']);
    //Synchronisation des videos
    videos = Videos("/data/user/0/com.tulipind.pam/databasespamdb",
        "/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/"
        ,"uploads/",tab[0]['user'],tab[0]['mdp'],tab[0]['dbname'],tab[0]['ip_server'],tab[0]['adresse_server']);
    //
    synchronisation.synchronize();
    records.synchronize();
    videos.synchronize();
    //
    /*
    Timer.periodic(Duration(minutes: 10), (timer)  {
      print("video ${DateTime.now()}");
      //video
      synchrvideo();
    });
    //
    Timer.periodic(Duration(minutes: 60), (timer)  {
      print("donnees ${DateTime.now()}");
      synchronisation.synchronize();
    });*/
  } else {}
  //'https://ad.tulipcrmsupport.com/DeployApp/PamAPK/pam.apk'
  //Systeme
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight,DeviceOrientation.landscapeLeft]).then((_){
    runApp(PamApp());
  });
}
//***************************************************************************************************************
//
//Si tu Detecte la connection internet
synchrData() async {
  //
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network.
    print("Debut de la synchronisation apres 5 minutes via mobile");
    synchronisation.synchronize();
    records.synchronize();
    //videos.synchronize();
  }
  else if (connectivityResult == ConnectivityResult.wifi) {
    print("Debut de la synchronisation wifi");
    synchronisation.synchronize();
    records.synchronize();
    //videos.synchronize();
  }
}
//****************************************************************************************************************

class PamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'PAM',
      theme: new ThemeData(
          primarySwatch: Colors.blue
      ),
      //Application
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState(){
    return new _Home();
  }
}
class _Home extends State<Home>{

  @override
  Widget build (BuildContext context){
    //
    return Scaffold(
      //la video en plein ecran
      body: Sliderhome(),
    );
  }
}


//////////////////////////////////////////////////////////////////////



//pannel update
/*
class UpdatePage extends StatelessWidget {
  getdata2() async{
    List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
    if(tab.isNotEmpty){
      var synchronisation = Synchro("/data/user/0/com.tulipind.pam/databasespamdb",
          "/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/"
          ,"uploads/",tab[0]['user'],tab[0]['mdp'],tab[0]['dbname'],tab[0]['ip_server'],tab[0]['adresse_server']);
      synchronisation.synchronize();
      var records = Records("/data/user/0/com.tulipind.pam/databasespamdb",
          "/storage/emulated/0/Android/data/com.tulipind.pam/files/"
          ,"vocal/",tab[0]['user'],tab[0]['mdp'],tab[0]['dbname'],tab[0]['ip_server'],tab[0]['adresse_server']);
      records.synchronize();
    } else {}
  }
  @override
  Widget build(BuildContext context) {
    //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Synchronisation de la base de donnee"),
      ),
      body: FutureBuilder(
        future: getdata2(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          List snap = snapshot.data;
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          //si il ya une eurreur lor du chargement
          if(snapshot.hasError){
            return Center(
              child: Text("Une erreur ces produite"),
            );
            //autre action
          }
          //On insert les donnee dans la base de donnnee
          return Center(
            child: Text("Reception des donnees effectuer !"),
          );
        },
      )
    );
  }
}

//pannel update Contente
class UpdatePageContent extends StatelessWidget {
  //
  getdatavideo() async{
    List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
    if(tab.isNotEmpty){
      var videos = Videos("/data/user/0/com.tulipind.pam/databasespamdb",
          "/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/"
          ,"uploads/",tab[0]['user'],tab[0]['mdp'],tab[0]['dbname'],tab[0]['ip_server'],tab[0]['adresse_server']);
      videos.synchronize();
    }
  }

  @override
  Widget build(BuildContext context) {
    //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title: Text("Telechargement des videos"),
        ),
        body: FutureBuilder(
          future: getdatavideo(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            List snap = snapshot.data;
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            //si il ya une eurreur lor du chargement
            if(snapshot.hasError){
              return Center(
                child: Text("Une erreur ces produite"),
              );
              //autre action
            }
            //On insert les donnee dans la base de donnnee
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    );
  }
}
 */



