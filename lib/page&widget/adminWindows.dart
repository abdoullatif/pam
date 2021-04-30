import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/model/UserIn.dart';

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


class AdminWindows extends StatelessWidget {

  //Modele contenant les variable personne
  final UserIn data;
  AdminWindows({this.data});
  //
  var nom = StorageUtil.getString("nom");
  var prenom = StorageUtil.getString("prenom");
  var email = StorageUtil.getString("email");
  //
  var emaillog = StorageUtil.getString("email");
  var mdplog = StorageUtil.getString("mdp");
  //
  var idtypefonction = StorageUtil.getString("idtypefonction");
  //
  String versionLocal;

  getVersion () async{
    //
    try {
      String v = await GetVersion.projectVersion;
      //print(versionApp);
      return v;
    } on PlatformException {
      print('Failed to get project version.');
    }

  }


  @override
  Widget build(BuildContext context) {
    //verificateur de connection
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
              accountName: new Text("$nom $prenom"),
              accountEmail: new Text("$email"),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text('A', style: TextStyle(color: Colors.black87))
              ),
              /*
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.colorPrimaryDark,
                      AppColors.indigo
                    ]),
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
                              } : (){}),
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
                          RaisedButton(
                              color: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.all(0.0),
                              child: Image.asset("images/achat commercant.png"),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AdminBon()),
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
          //quitter
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