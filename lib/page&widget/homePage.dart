import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:pam/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'agricultureWindows.dart';
import 'alimentationWindows.dart';
import 'cooperativeWindows.dart';
import 'eleveWindows.dart';
import 'loginPage.dart';
import 'santeWindows.dart';

class Acceuil extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //
    String categ;
    //flutter screen resize
    StateSetter _setState;
    String _localite;
    //localite
    Future<void> SelectLocalite() async {
      List<Map<String, dynamic>> queryLocalite = await DB.queryAll("localite");
      return queryLocalite;
    }
    final GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();
    //boutton addministration
    final _admin = RaisedButton(
        color: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.all(0.0),
        child: Image.asset("images/admin.png"),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => PageLogin()),
          );
        }
    );
    //boutton personne normal
    final _user = RaisedButton(
        color: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.all(0.0),
        child: Image.asset("images/admin.png"),
        onPressed: (){}
    );
    //ScreenUtil.init(width: defaultScreenWidth, height: defaultScreenHeight, allowFontScaling: true);
    return Scaffold (
      body: Container(
        child: Container(
          /*
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/backgroundempty.png"),
                fit: BoxFit.cover,
              )
          ),
           */
          child: Padding(
            padding: const EdgeInsets.only(left: 200.0, right: 200.0, top: 0),
            //padding: const EdgeInsets.all(0.0),
            child: SingleChildScrollView(
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
                          child: Image.asset("images/agriculture.png"),
                          onPressed: (){
                            //player.play('audio/agri.mp3');
                            categ = "Agriculture";
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => AgricultureWindows(),settings: RouteSettings(arguments: categ,)),
                            );
                          }
                      ),
                      RaisedButton(
                          color: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.all(0.0),
                          child: Image.asset("images/alimentation.png"),
                          onPressed: (){
                            categ = "Alimentation";
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => AlimentationWindows(),settings: RouteSettings(arguments: categ,)),
                            );
                          }
                      ),
                      RaisedButton(
                          color: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.all(0.0),
                          child: Image.asset("images/cooperative.png"),
                          onPressed: (){
                            categ = "Cooperative";
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => CooperativeWindows(),settings: RouteSettings(arguments: categ,)),
                            );
                          }
                      ),
                    ],
                  ),
                  SizedBox(height: 100, width: 100, child: Image.asset("images/small-logo.png"),),
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
                          child: Image.asset("images/education.png"),
                          onPressed: (){
                            categ = "Education";
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ElevesWindows(),settings: RouteSettings(arguments: categ,)),
                            );
                          }
                      ),
                      RaisedButton(
                          color: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.all(0.0),
                          child: Image.asset("images/sante.png"),
                          onPressed: (){
                            categ = "Sante";
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => SanteWindows(),settings: RouteSettings(arguments: categ,)),
                            );
                          }
                      ),
                      RaisedButton(
                          color: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.all(0.0),
                          child: Image.asset("images/admin.png"),
                          onPressed: () async{
                            List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
                            //var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
                            if(tab[0]["locate"] == "" || tab[0]["locate"] == null){
                              print(tab[0]["locate"]);
                              List<Map<String, dynamic>> queryLocalite = await DB.queryAll("localite");
                              if(queryLocalite.isNotEmpty){
                                print(queryLocalite);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text("Localite"),
                                        content: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState){
                                            _setState = setState;
                                            return SingleChildScrollView(
                                              child: Form(
                                                key: _formKey2,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      //color: Colors.indigo,
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: SizedBox(
                                                            //height: 50.0,
                                                            child: Text(
                                                              "Selectionner une localite !",
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Divider(),
                                                    SizedBox(height: 10,),
                                                    FutureBuilder(
                                                        future: SelectLocalite(),
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
                                                          return DropDownFormField(
                                                            titleText: 'Localite',
                                                            hintText: 'zone',
                                                            value: _localite,
                                                            onSaved: (value) {
                                                              setState(() {
                                                                _localite = value;
                                                              });
                                                            },
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _localite = value;
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      title: Text("Comfirmation de la localite"),
                                                                      content: Text("Je comfirme la localite : $_localite"),
                                                                      actions: <Widget>[
                                                                        FlatButton(
                                                                          child: Text('OK'),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop('oui');
                                                                          },
                                                                        ),
                                                                      ],
                                                                      //shape: CircleBorder(),
                                                                    );
                                                                  },
                                                                );
                                                              });
                                                            },
                                                            dataSource: snap,
                                                            textField: 'description',
                                                            valueField: 'description',
                                                            validator: (value) {
                                                              if (_localite == "") {
                                                                return 'Veuiller Slectionner une localite';
                                                              }
                                                              return null;
                                                            },
                                                          );
                                                        }
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Enregistrer'),
                                            onPressed: () async {
                                              //La classe est anterieur superieur ou egale
                                              // Validate returns true if the form is valid, otherwise false.
                                              if (_formKey2.currentState.validate()) {
                                                var _parametre = await DB.initTabquery();
                                                if(_parametre.isEmpty){
                                                  await DB.insert("parametre", {
                                                    "locate": _localite,
                                                  });
                                                } else {
                                                  await DB.update("parametre", {
                                                    "locate": _localite,
                                                  }, _parametre[0]['id']);
                                                }
                                              }
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            onPressed: (){
                                              Navigator.of(context).pop('non');
                                            },
                                            child: Text('Annuler'),
                                          ),
                                        ],
                                        //shape: CircleBorder(),
                                      );
                                    }
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Synchronisation"),
                                      content: Text("Synchronisation en cours ..."),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop('oui');
                                          },
                                        ),
                                      ],
                                      //shape: CircleBorder(),
                                    );
                                  },
                                );
                              }
                            } else if (tab == null) {
                              //
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Data !"),
                                    content: Text("Donnee de synchro non disponible"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop('oui');
                                        },
                                      ),
                                    ],
                                    //shape: CircleBorder(),
                                  );
                                },
                              );
                            } else {
                              //
                              /*
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => PageLogin()),
                              );*/
                              Navigator.of(context).pushNamed('/login');
                            }
                          }
                      ), //_user
                    ],
                    padding: EdgeInsets.all(0.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //remove all share pre
          SharedPreferences prefs = await SharedPreferences.getInstance();
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
          prefs.remove("idlocalite");
          prefs.remove("adresse");
          prefs.remove("idpersonne_fonction");
          prefs.remove("idtypefonction");
          prefs.remove("ecole");
          //
          prefs.remove("idtemp");
          prefs.remove("typefoncttemp");
          prefs.remove("imagetemp");
          prefs.remove("nomtemp");
          prefs.remove("prenomtemp");
          prefs.remove("nbscan");
          //quitter
          Navigator.pop(context, "Acceuil");
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