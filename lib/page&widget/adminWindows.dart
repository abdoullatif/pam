

import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_version/get_version.dart';
import 'package:pam/database/database_online.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/model/UserIn.dart';
import 'package:pam/model/parametre.dart';
import 'package:pam/model/user_data_online.dart';
import 'package:pam/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adminPannel.dart';
import 'choseLangue&Localite.dart';
import 'commercantWindows.dart';
import 'controlPannel.dart';
import 'enregistrement.dart';
import 'forgetuid.dart';
import 'pamWebsite.dart';
import 'supervision.dart';
import 'venteWindows.dart';
import 'zone.dart';


class AdminWindows extends StatefulWidget {

  //Modele contenant les variable personne
  final UserIn data;
  AdminWindows({this.data});

  @override
  _AdminWindowsState createState() => _AdminWindowsState();
}

class _AdminWindowsState extends State<AdminWindows> {

  var idpersonne = StorageUtil.getString("idpersonne");

  var nom = StorageUtil.getString("nom");

  var prenom = StorageUtil.getString("prenom");

  var email = StorageUtil.getString("email");

  var image = StorageUtil.getString("image");

  var emaillog = StorageUtil.getString("email");

  var mdplog = StorageUtil.getString("mdp");

  var idtypefonction = StorageUtil.getString("idtypefonction");

  String versionLocal;

  //Timmer
  Timer _timer;

  getVersion () async{
    try {
      String v = await GetVersion.projectVersion;
      //print(versionApp);
      return v;
    } on PlatformException {
      print('Failed to get project version.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    DbOnline.con();
    //Check the server every 10 seconds
    //_timer = Timer.periodic(const Duration(seconds: 10), (timer) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() async{
    // TODO: implement dispose
    //Remove connection
    await DbOnline.closeCon();
    //quitter
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove
    prefs.remove("idpersonne");
    prefs.remove("nom");
    prefs.remove("prenom");
    prefs.remove("date_naissance");
    prefs.remove("idgenre");
    prefs.remove("date_creation");
    prefs.remove("iud");
    prefs.remove("email");
    prefs.remove("mdp");
    prefs.remove("image");
    prefs.remove("idadresse");
    prefs.remove("idlocalite");
    prefs.remove("adresse");
    prefs.remove("idpersonne_fonction");
    prefs.remove("idtypefonction");
    //ecole si c'est un directeur d'ecole
    if(idtypefonction == "DG"){
      prefs.remove("idecole");
      prefs.remove("nom_ecole");
    }
    super.dispose();
  }

  void NotificationLauncher() async{
    var user_online = await DbOnline.getUser(email);
    for(var row in user_online) {

      UserData.id_user_online_tmp = row['id'];

      UserData.id = row['id'];
      UserData.name = row['name'];
      UserData.prenom = row['prenom'];
      UserData.image = row['image'];
      UserData.email_usr_pm = row['email_usr_pm'];
      UserData.localite = row['localite'];
      UserData.contacte = row['contacte'];
      UserData.mdp_usr_pm = row['mdp_usr_pm'];


      var commandeAccepter = await DbOnline.getNombreCommandeAccepter(row['id'].toString());
      if(commandeAccepter.toString() != "(Fields: {nombrecommandeaccepter: 0})") {
        print(commandeAccepter);
        for(var row2 in commandeAccepter) {
          //Notification pour les directeur d'ecole
          NotificationService().showNotification(Param.flutterLocalNotificationsPlugin,0,'Commande','Vous avez ${row2['nombrecommandeaccepter']} commandes accepter');
        }
      } else {
        print("pas de donnees (commande accepter)!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {


    if (idtypefonction == "DG") {

      if(DbOnline.conn != null) {

        setState(() {
          NotificationLauncher();
        });

      }

    }

    //versionLocal = getVersion();
    //composant
    final _parametre_component = ListTile(
        leading: Icon(Icons.tablet),
        title: new Text("Parametre"),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ControlPannel()),);
        });
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: <Widget>[
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                radius: 80,
                backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/$image')),
              ),
              accountName: Text(nom+" "+prenom),
              accountEmail: Text(email),
              /*
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xff74ABE4), Color(0xffA892ED)]),
              ),
              */
            ),
            emaillog == "SuperAdminTulipInd@tld.com" ? _parametre_component : Container(),
            new ListTile(
                leading: Icon(Icons.person),
                title: new Text("Mes informations"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfo()),);
                }),
            /*
            new ListTile(
                leading: Icon(Icons.update),
                title: new Text("Mettre a jour le contenu de l'application"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePageContent()),);
                }),
            */
            new ListTile(
                leading: Icon(Icons.language),
                title: new Text("Langue / Localite"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLangues()),);
                }),
            new Divider(),
            new ListTile(
                leading: Icon(Icons.nfc),
                title: new Text("Bracelet perdu ?"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ScanUID()),);
                }),
            /*
            FutureBuilder(
                future: getVersion(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  String snap = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Erreur Version"),
                    );
                  }
                  return ListTile(
                      leading: Icon(Icons.info),
                      title: new Text("Version: $snap"),
                      onTap: () {
                        Navigator.pop(context);
                      });
                }
            ),
            */
          ],
        ),
      ),
      body: Container(
        /*
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/backgroundempty.png"),
              fit: BoxFit.cover,
            )
        ),
        */
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 250.0, right: 250.0, top: 0),
                  //padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: <Widget>[
                      GridView.count(
                        shrinkWrap: true,
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //primary: false,
                        //padding: const EdgeInsets.all(0.0),
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 0.0,
                        crossAxisCount: 3,
                        children: <Widget>[
                          RaisedButton(
                              color: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              child: Image.asset("images/achat agriculteur.png"),
                              onPressed: idtypefonction != "AFE" ? (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Vente()),
                                );
                              } : (){
                                Fluttertoast.showToast(
                                    msg: "Pas autorisé",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 20.0
                                );
                              }),
                          RaisedButton(
                              color: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              child: Image.asset("images/supervision.png"),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AdminSuper()),
                                );
                              }),
                          RaisedButton(
                              color: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              child: Image.asset("images/add.png"),
                              onPressed: (){
                                //push
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AdminAdd()),
                                );
                              }
                          ),
                        ],
                      ),
                      SizedBox(height: 80, width: 80, child: Image.asset("images/small-logo.png"),),
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //padding: const EdgeInsets.only(left: 180.0, right: 180.0, top: 0),
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 0.0,
                        crossAxisCount: 3,
                        children: <Widget>[
                          /*
                          DbOnline.conn != null && idtypefonction == "DG" ?
                          FutureBuilder(
                              future: DbOnline.getNombreCommandeAccepter(UserData.id_user_online_tmp.toString()),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                var snap = snapshot.data;
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return RaisedButton(
                                      color: Colors.transparent,
                                      elevation: 0,
                                      padding: EdgeInsets.all(0.0),
                                      child: Image.asset("images/achat commercant.png"),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => produitsCommercant()),
                                        );
                                      });
                                }
                                if (snapshot.hasError) {
                                  return RaisedButton(
                                      color: Colors.transparent,
                                      elevation: 0,
                                      padding: EdgeInsets.all(0.0),
                                      child: Image.asset("images/achat commercant.png"),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => produitsCommercant()),
                                        );
                                      });
                                }

                                if(snapshot.hasData) {
                                  for(var row in snap)
                                    return Badge(
                                      padding: const EdgeInsets.all(13.0),
                                      position: BadgePosition.topEnd(top: 10, end: 10),
                                      badgeContent: Text( '${row['nombrecommandeaccepter']}',
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),),
                                      child: RaisedButton(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          padding: EdgeInsets.all(0.0),
                                          child: Image.asset("images/achat commercant.png"),
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => produitsCommercant()),
                                            );
                                          }),
                                    );
                                }
                                //Return
                                return RaisedButton(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset("images/achat commercant.png"),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => produitsCommercant()),
                                      );
                                    });
                              }
                          ): */
                          RaisedButton(
                              color: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              child: Image.asset("images/achat commercant.png"),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => produitsCommercant()),
                                );
                              }),
                          RaisedButton(
                              color: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              child: Image.asset("images/zone.png"),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AdminZone()),
                                );
                              }),
                          RaisedButton(
                              color: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              child: Image.asset("images/pam.png"),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AdminWeb()),
                                );
                              }),
                        ],
                        padding: EdgeInsets.all(0.0),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Remove connection
          await DbOnline.closeCon();
          //quitter
          SharedPreferences prefs = await SharedPreferences.getInstance();
          //Remove
          prefs.remove("idpersonne");
          prefs.remove("nom");
          prefs.remove("prenom");
          prefs.remove("date_naissance");
          prefs.remove("idgenre");
          prefs.remove("date_creation");
          prefs.remove("iud");
          prefs.remove("email");
          prefs.remove("mdp");
          prefs.remove("image");
          prefs.remove("idadresse");
          prefs.remove("idlocalite");
          prefs.remove("adresse");
          prefs.remove("idpersonne_fonction");
          prefs.remove("idtypefonction");
          //ecole si c'est un directeur d'ecole
          if(idtypefonction == "DG"){
            prefs.remove("idecole");
            prefs.remove("nom_ecole");
          }
          //Navigator.popUntil(context, ModalRoute.withName('/login'));
          Navigator.pop(context);
        },
        tooltip: 'Quitter', backgroundColor: Colors.transparent,
        child: Image.asset("images/close.png"),
      ),
      //bottomNavigationBar: BottomAppBar(
      //color: Colors.blue,
      //child: Container(height: 30.0,),
      //),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}