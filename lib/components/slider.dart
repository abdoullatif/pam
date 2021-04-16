import 'dart:async';
import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pam/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:in_app_update/in_app_update.dart';
import 'package:get_version/get_version.dart';
import 'package:ota_update/ota_update.dart';

import '../main.dart';


class Sliderhome extends StatefulWidget {
  @override
  _SliderhomeState createState() => _SliderhomeState();
}

class _SliderhomeState extends State<Sliderhome> {
  //
  //AppUpdateInfo _updateInfo;
  bool isLoading = false;
  //
  void _showError(dynamic exception) {
    Scaffold
        .of(context)
        .showSnackBar(SnackBar(content: Text(
        exception.toString(),
        style: TextStyle(
          fontSize: 15,
          color: Colors.white, fontFamily: "Quicksand", fontWeight: FontWeight.bold,
        ),
      ),
      duration: Duration(seconds: 5),));
  }

  //
  Future<void> checkForUpdate() async {
    setState(() {
      isLoading = true;
    });
    /*
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) => _showError(e));
    */
    setState(() {
      isLoading = false;
    });
  }

  OtaEvent currentEvent;

  @override
  void initState() {
    super.initState();
    //fetchVersionApp();
    tryOtaUpdate();
    //checkForUpdate();
  }

  List version = [];

  fetchVersionApp() async {
    final response = await http.get('http://ad.tulipcrmsupport.com/DeployApp/PamAPK/version.json');
    version = [];
    if (response.statusCode == 200) {
      setState(() {
        version = json.decode(response.body);
      });
    }
    //return version;
  }

  /*
  */

  Future<void> tryOtaUpdate() async {
    final response = await http.get('http://ad.tulipcrmsupport.com/DeployApp/PamAPK/version.json');
    if (response.statusCode == 200) {
      setState(() {
        version = json.decode(response.body);
      });
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      String versionLocal = "0";
      var v = version;
      String versionOnline = v[0]['version'];
      //print(versionOnline);
      //
      try {
        versionLocal = await GetVersion.projectVersion;
        //print(versionApp);
      } on PlatformException {
        print('Failed to get project version.');
      }
      //Verification
      String OnlineX = versionOnline.substring(0,1);
      String OnlineY = versionOnline.substring(2,3);
      String OnlineZ = versionOnline.substring(4,5);
      print(OnlineX);
      String appX = versionLocal.substring(0,1);
      String appY = versionLocal.substring(2,3);
      String appZ = versionLocal.substring(4,5);
      print(appX);

      //int.parse(OnlineX) > int.parse(appX)

      if(versionOnline.toString().compareTo(versionLocal) > 0){
        showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Nouvelle mise à jour disponible !!!"),
              content: Text("Une nouvelle mise à jour a été deployer, Version : $versionOnline !"),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok'),
                  onPressed: () {
                    Navigator.of(context).pop('oui');
                  },
                ),
              ],
              //shape: CircleBorder(),
            );
          },
        );
        try {
          //LINK CONTAINS APK
          OtaUpdate()
              .execute(
            'http://ad.tulipcrmsupport.com/DeployApp/PamAPK/pam.apk',
            destinationFilename: 'pam.apk',
            //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
            //sha256checksum: "d6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478",
          )
              .listen(
                (OtaEvent event) {
              setState(() => currentEvent = event);
            },
          );
        } catch (e) {
          print('Probleme. Details: $e');
        }
      } else { print("A jour !!!");}
    }
  }

  @override
  Widget build(BuildContext context) {

    // Only call clearSavedSettings() during testing to reset internal values.
    //Upgrader().clearSavedSettings();
    //final appcastURL = 'https://udea-guinee.com/soba/Appcast.xml';
    //final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);

    FutureOr onGoBack(dynamic value) {
      setState(() {});
    }
    var _uid_home = "";
    //-----------------------------------------------------------------------------------
    Future getUid(uid) async {
      List<Map<String, dynamic>> queryPersonne = await DB.queryWhereUid("personne", uid);
      //return querypersonne;
      if(queryPersonne.isNotEmpty){
        //
        if(queryPersonne[0]['iud'] == uid){
          //get table personne fonction
          List<Map<String, dynamic>> queryPersonne_adresse = await DB.queryWhereidpersonne("personne_adresse", queryPersonne[0]['id']);
          List<Map<String, dynamic>> querylocalite = await DB.queryWhere("localite", queryPersonne_adresse[0]['idlocalite']);
          List<Map<String, dynamic>> queryPersonne_tel = await DB.queryWhereidpersonne("personne_tel", queryPersonne[0]['id']);
          List<Map<String, dynamic>> queryPersonne_fonction = await DB.queryWhereidpersonne("personne_fonction", queryPersonne[0]['id']);
          if(queryPersonne_adresse.isNotEmpty && queryPersonne_tel.isNotEmpty && queryPersonne_fonction.isNotEmpty){
            //Recup les champs des autre tables
            //On envois ces donnee dans le sharepreference
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('idpersonne', queryPersonne[0]['id']);
            prefs.setString('nom', queryPersonne[0]['nom']);
            prefs.setString('prenom', queryPersonne[0]['prenom']);
            prefs.setString('date_naissance', queryPersonne[0]['date_naissance']);
            prefs.setString('idgenre', queryPersonne[0]['idgenre']);
            prefs.setString('date_creation', queryPersonne[0]['date_creation']);
            prefs.setString('iud', queryPersonne[0]['iud']);
            prefs.setString('email', queryPersonne[0]['email']);
            prefs.setString('mdp', queryPersonne[0]['mdp']);
            prefs.setString('image', queryPersonne[0]['image']);
            //personne adresse
            prefs.setString('idadresse', queryPersonne_adresse[0]['id']);
            prefs.setString('idlocalite', querylocalite[0]['description']);
            prefs.setString('adresse', queryPersonne_adresse[0]['adresse']);
            //personne tel
            prefs.setString('idpersonne_fonction', queryPersonne_fonction[0]['id']);
            prefs.setString('idtypefonction', queryPersonne_fonction[0]['idtypefonction']);
            if(queryPersonne_fonction[0]['idtypefonction'] == "DG"){
              List<Map<String, dynamic>> queryEcole = await DB.queryWhereidpersonne("ecole", queryPersonne[0]['id']);
              if(queryEcole.isNotEmpty){
                //ecole si c'est un directeur d'ecole
                prefs.setString('idecole', queryEcole[0]['id']);
                prefs.setString('nom_ecole', queryEcole[0]['nom_ecole']);
              }
            }
            ///////////////////////////////////////////////////////////////////////////////////
            //si tout ce passe bien on le redirige vers le pannel admin
            /*
            si l'utilisateur a sur l'ecran pr
             */
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Acceuil()),
            ).then(onGoBack);
          }//si c'est la bonne personne
          //
        }
      }
    }
    // execution de la fonction
    //**********************nfc****************************************
    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      _uid_home = response.id.substring(2);
      String _uid = _uid_home.toUpperCase();
      if(mounted){
        setState((){
          if(_uid_home != ""){
            bool currentRouteIsHome = false;
            bool currentRouteIsNewRoute = false;
            Navigator.popUntil(context, (currentRoute) {
              if (currentRoute.settings.name == "/") {
                print(currentRoute.settings.name);
                print(_uid);
                getUid(_uid);
                //_uid_home;
                //currentRouteIsHome = true;
              }
              // Return true so popUntil() pops nothing.
              return true;
            });

          } else if (_uid_home.isNotEmpty) {
            //
          }
        });
      } else {
        setState((){
          if(_uid_home != ""){
            Navigator.popUntil(context, (currentRoute) {
              if (currentRoute.settings.name == "/") {
                print(currentRoute.settings.name);
                print(_uid);
                getUid(_uid);
                //_uid_home;
                //currentRouteIsHome = true;
              } else {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Session En cours"),
                      content: const Text("Veuillez vous deconnecter pour scanner un nouveaux bracelet"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      //shape: CircleBorder(),
                    );
                  },
                );
              }
              // Return true so popUntil() pops nothing.
              return true;
            });
          } else if (_uid_home.isNotEmpty) {
            //
          }
        });
      }
    });
    //-----------------------------------------------------------------
    //**********************************************************************
    Duration temps = new Duration(hours:0, minutes:0, seconds:30);
    String superAdminpassword = "";

    if (currentEvent == null) {
      return Container(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              //...
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Carousel(
                  images: [
                    AssetImage('images/slider1.png'),
                    AssetImage('images/slider2.png'),
                    AssetImage("images/slider3.png"),
                    AssetImage("images/slider4.png"),
                  ],
                  dotSize: 4.0,
                  dotSpacing: 15.0,
                  dotColor: Colors.white10,
                  indicatorBgPadding: 5.0,
                  dotBgColor: Colors.black87.withOpacity(0.5),
                  autoplayDuration: temps,
                  borderRadius: false,
                  showIndicator: false,
                  onImageTap: (index) {
                    //
                    setState(() {
                      _uid_home;
                    });
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Acceuil()),
                    );
                  },
                ),
              ),
              ////les boutton administrateurs
              Positioned(
                top: 25,
                //bottom: 2,
                child: GestureDetector(
                  child: SizedBox(width: 150, height: 150, child: Text(""),),
                  onTap: (){
                    superAdminpassword = "";
                    superAdminpassword += "super";
                    print(superAdminpassword);
                  },
                ),
              ),
              Positioned(
                top: 25,
                right: 0,
                //bottom: 2,
                child: GestureDetector(
                  child: SizedBox(width: 150, height: 150, child: Text(""),),
                  onDoubleTap: (){
                    superAdminpassword += "word";
                    if(superAdminpassword == "superAdminpassword") {
                      //
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PageLogin()),
                      );
                    }
                    print(superAdminpassword);
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                //bottom: 2,
                child: GestureDetector(
                  child: SizedBox(width: 150, height: 150, child: Text(""),),
                  onTap: (){
                    superAdminpassword += "Admin";
                    print(superAdminpassword);
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                //bottom: 2,
                child: GestureDetector(
                  child: SizedBox(width: 150, height: 150, child: Text(""),),
                  onTap: (){
                    superAdminpassword += "pass";
                    print(superAdminpassword);
                  },
                ),
              ),
              Positioned(
                top: 400,
                left: 600,
                //bottom: 2,
                child: Text(''), //Text('OTA status: ${currentEvent.status} : ${currentEvent.value} \n'),
              ),
              //Upgrade
              /*
            Positioned(
              top: 400,
              left: 600,
              //bottom: 2,
              child: UpgradeAlert(
                appcastConfig: cfg,
                debugLogging: true,
                child: Center(child: Text('')),
              ),
            ),
            */
            ],
          ),
        ),
      );
    }

    return Container(
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            //...
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Carousel(
                images: [
                  AssetImage('images/slider1.png'),
                  AssetImage('images/slider2.png'),
                  AssetImage("images/slider3.png"),
                ],
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotColor: Colors.white10,
                indicatorBgPadding: 5.0,
                dotBgColor: Colors.black87.withOpacity(0.5),
                autoplayDuration: temps,
                borderRadius: false,
                showIndicator: false,
                onImageTap: (index) {
                  //
                  setState(() {
                    _uid_home;
                  });
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Acceuil()),
                  );
                },
              ),
            ),
            ////les boutton administrateurs
            Positioned(
              top: 25,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onTap: (){
                  superAdminpassword = "";
                  superAdminpassword += "super";
                  print(superAdminpassword);
                },
              ),
            ),
            Positioned(
              top: 25,
              right: 0,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onDoubleTap: (){
                  superAdminpassword += "word";
                  if(superAdminpassword == "superAdminpassword") {
                    //
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PageLogin()),
                    );
                  }
                  print(superAdminpassword);
                },
              ),
            ),
            Positioned(
              bottom: 0,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onTap: (){
                  superAdminpassword += "Admin";
                  print(superAdminpassword);
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onTap: (){
                  superAdminpassword += "pass";
                  print(superAdminpassword);
                },
              ),
            ),
            Positioned(
              top: 400,
              left: 600,
              //bottom: 2,
              child: Text(''), //Text('OTA status: ${currentEvent.status} : ${currentEvent.value} \n'),
            ),
            //Upgrade
            /*
            Positioned(
              top: 400,
              left: 600,
              //bottom: 2,
              child: UpgradeAlert(
                appcastConfig: cfg,
                debugLogging: true,
                child: Center(child: Text('')),
              ),
            ),
            */
          ],
        ),
      ),
    );

      /*
      isLoading ?
    Center(
      child: SpinKitCircle(
        color: Colors.blueGrey.shade900,
        size: 50.0,
      ),
    ) : _updateInfo?.updateAvailable != null &&  _updateInfo.updateAvailable == true ?
      Container(
        child: AlertDialog(
          backgroundColor: Colors.blueGrey.shade900,
          title: Text("Nouvelle mis a jour disponible !",
            style: TextStyle(fontFamily: "Quicksand", fontWeight: FontWeight.bold,color: Colors.white
            ),),
          actions: [
            FlatButton(onPressed: _updateInfo?.updateAvailable == true
                ? () {
              //InAppUpdate.performImmediateUpdate().catchError((e) => _showError(e));
            }
                : null,
                child: Text("Mettre a jour",
                  style: TextStyle(fontFamily: "Quicksand", fontWeight: FontWeight.bold,color: Colors.white
                  ),))
          ],
        ),
      ) :
      Container(
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            //...
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Carousel(
                images: [
                  AssetImage('images/slider1.png'),
                  AssetImage('images/slider2.png'),
                  AssetImage("images/slider3.png"),
                ],
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotColor: Colors.white10,
                indicatorBgPadding: 5.0,
                dotBgColor: Colors.black87.withOpacity(0.5),
                autoplayDuration: temps,
                borderRadius: false,
                showIndicator: false,
                onImageTap: (index) {
                  //
                  setState(() {
                    _uid_home;
                  });
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Acceuil()),
                  );
                },
              ),
            ),
            ////les boutton administrateurs
            Positioned(
              top: 25,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onTap: (){
                  superAdminpassword = "";
                  superAdminpassword += "super";
                  print(superAdminpassword);
                },
              ),
            ),
            Positioned(
              top: 25,
              right: 0,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onDoubleTap: (){
                  superAdminpassword += "word";
                  if(superAdminpassword == "superAdminpassword") {
                    //
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PageLogin()),
                    );
                  }
                  print(superAdminpassword);
                },
              ),
            ),
            Positioned(
              bottom: 0,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onTap: (){
                  superAdminpassword += "Admin";
                  print(superAdminpassword);
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onTap: (){
                  superAdminpassword += "pass";
                  print(superAdminpassword);
                },
              ),
            ),
            //Upgrade
            /*
            Positioned(
              top: 400,
              left: 600,
              //bottom: 2,
              child: UpgradeAlert(
                appcastConfig: cfg,
                debugLogging: true,
                child: Center(child: Text('')),
              ),
            ),
            */
          ],
        ),
      ),
    );
      */
  }
}
