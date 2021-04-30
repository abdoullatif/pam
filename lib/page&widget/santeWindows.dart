import 'package:flutter/material.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';
import 'phoneCall.dart';
import 'profileUser.dart';
import 'sous-categorieFemme.dart';

class SanteWindows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //
    var idtypefonction = StorageUtil.getString("idtypefonction");
    var emaillog = StorageUtil.getString("email");
    var mdplog = StorageUtil.getString("mdp");

    //var
    String Scateg;
    //Composant
    final _profile = RaisedButton(
      elevation: 0,
      padding: EdgeInsets.all(0.0),
      color: Colors.transparent,
      disabledColor: Colors.transparent,
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Profile()),
        );
      },
      child: Image.asset("images/profile.png"),
    );

    final categ = ModalRoute.of(context).settings.arguments;
    var idvideo;
    //var lang = "Malinké";
    String Langue = "Français";
    //Selection de video de presentation agriculture dans la base de donner
    //***********************************************************************
    Future<List<Map<String, dynamic>>> MediaPresentation() async{
      var _parametre = await DB.initTabquery();
      if(_parametre[0]['langue'] != "" || _parametre[0]['langue'] != null) {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaCategAll(categ,_parametre[0]['langue']);
        return queryRows;
      } else {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaCategAll(categ,Langue);
        return queryRows;
      }
    }
    final _sante = FutureBuilder(
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/banner5.png"),
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
                              child: Text("Santé", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold,),),
                            ),
                          )
                      ),
                    ),
                  ),
                  Container(
                      height: 140.0,
                      child: Center(
                          child: new Container(
                            margin: EdgeInsets.only(left: 50.0, right: 50.0),
                            padding: EdgeInsets.all(15.0),
                            color: Colors.transparent,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                RaisedButton(
                                  elevation: 0,
                                  padding: EdgeInsets.all(0.0),
                                  color: Colors.transparent,
                                  disabledColor: Colors.transparent,
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => Call()),
                                    );
                                  },
                                  child: Image.asset("images/call.png"),
                                ),
                                idtypefonction == "FE" ? _profile : Container(),
                                //Femme enceinte
                                RaisedButton(
                                  elevation: 0,
                                  padding: EdgeInsets.all(0.0),
                                  color: Colors.transparent,
                                  disabledColor: Colors.transparent,
                                  onPressed: (){
                                    Scateg = "Femme Enceinte";
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => SousCatFemme(),settings: RouteSettings(arguments: Scateg,)),
                                    );
                                  },
                                  child: Image.asset("images/femme_enceinte.png"),
                                ),
                                //Femme allaitante
                                RaisedButton(
                                  elevation: 0,
                                  padding: EdgeInsets.all(0.0),
                                  color: Colors.transparent,
                                  disabledColor: Colors.transparent,
                                  onPressed: (){
                                    Scateg = "Femme Allaitante";
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => SousCatFemme(),settings: RouteSettings(arguments: Scateg,)),
                                    );
                                  },
                                  child: Image.asset("images/femme_allaitante.png"),
                                ),
                                RaisedButton(
                                  elevation: 0,
                                  padding: EdgeInsets.all(0.0),
                                  color: Colors.transparent,
                                  disabledColor: Colors.transparent,
                                  onPressed: (){
                                    Scateg = "Enfant";
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => SousCatFemme(),settings: RouteSettings(arguments: Scateg,)),
                                    );
                                  },
                                  child: Image.asset("images/enfant.png"),
                                ),
                                /*
                                  RaisedButton(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => Balance()),
                                      );
                                    },
                                    child: Image.asset("images/balance.png"),
                                  ),
                                  */
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
                  Container(
                    child: Container(
                        height: 140.0,
                        child: Center(
                            child: new Container(
                              margin: EdgeInsets.only(left: 50.0, right: 50.0),
                              padding: EdgeInsets.all(15.0),
                              color: Colors.transparent,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  RaisedButton(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => Call()),
                                      );
                                    },
                                    child: Image.asset("images/call.png"),
                                  ),
                                  idtypefonction == "FE" ? _profile : Container(),
                                  //Femme enceinte
                                  RaisedButton(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    onPressed: (){
                                      Scateg = "Femme Enceinte";
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => SousCatFemme(),settings: RouteSettings(arguments: Scateg,)),
                                      );
                                    },
                                    child: Image.asset("images/femme_enceinte.png"),
                                  ),
                                  //Femme allaitante
                                  RaisedButton(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    onPressed: (){
                                      Scateg = "Femme Allaitante";
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => SousCatFemme(),settings: RouteSettings(arguments: Scateg,)),
                                      );
                                    },
                                    child: Image.asset("images/femme_allaitante.png"),
                                  ),
                                  RaisedButton(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    onPressed: (){
                                      Scateg = "Enfant";
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => SousCatFemme(),settings: RouteSettings(arguments: Scateg,)),
                                      );
                                    },
                                    child: Image.asset("images/enfant.png"),
                                  ),
                                  /*
                                  RaisedButton(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => Balance()),
                                      );
                                    },
                                    child: Image.asset("images/balance.png"),
                                  ),
                                  */
                                ],
                              ),
                            )
                        )
                    ),
                  ),
                  SizedBox(height: 25,),
                  /*
                  Center(
                    child: Text("Les vidéos", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
                  ),
                  Divider(
                    height: 50.0,
                    thickness: 3,
                    //color: Colors.white70,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50.0, right: 50.0),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      //physics: ,
                      //mainAxisSpacing: 40.0,
                      crossAxisSpacing: 50.0,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(snap.length, (index) {
                        return Center(
                          child: RaisedButton(
                            elevation: 0,
                            padding: EdgeInsets.all(0.0),
                            color: Colors.transparent,
                            disabledColor: Colors.transparent,
                            onPressed: (){
                              idvideo = snap[index]['id'];
                              //Visionage de la video sur page unique
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Visionnage(),settings: RouteSettings(arguments: idvideo,)),
                              );
                            },
                            child: Image.asset('images/cover.png'),
                          ),
                        );
                      }),
                    ),
                  ),
                  Center(
                    child: Text("", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
                  ),
                   */
                  Divider(
                    height: 50.0,
                    thickness: 3,
                    //color: Colors.white70,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),

                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/banner5.png"),
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
                              child: Text("Sante", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold,),),
                            ),
                          )
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                        height: 140.0,
                        child: Center(
                            child: new Container(
                              margin: EdgeInsets.only(left: 50.0, right: 50.0),
                              padding: EdgeInsets.all(15.0),
                              color: Colors.transparent,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  RaisedButton(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => Call()),
                                      );
                                    },
                                    child: Image.asset("images/call.png"),
                                  ),
                                  idtypefonction == "FE" ? _profile : Container(),
                                  //Femme enceinte
                                  RaisedButton(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    onPressed: (){
                                      Scateg = "Femme Enceinte";
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => SousCatFemme(),settings: RouteSettings(arguments: Scateg,)),
                                      );
                                    },
                                    child: Image.asset("images/femme_enceinte.png"),
                                  ),
                                  //Femme allaitante
                                  RaisedButton(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    onPressed: (){
                                      Scateg = "Femme Allaitante";
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => SousCatFemme(),settings: RouteSettings(arguments: Scateg,)),
                                      );
                                    },
                                    child: Image.asset("images/femme_allaitante.png"),
                                  ),
                                  RaisedButton(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    onPressed: (){
                                      Scateg = "Enfant";
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => SousCatFemme(),settings: RouteSettings(arguments: Scateg,)),
                                      );
                                    },
                                    child: Image.asset("images/enfant.png"),
                                  ),
                                  /*
                                  RaisedButton(
                                    elevation: 0,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => Balance()),
                                      );
                                    },
                                    child: Image.asset("images/balance.png"),
                                  ),
                                  */
                                ],
                              ),
                            )
                        )
                    ),
                  ),
                  Divider(
                    height: 50.0,
                    thickness: 3,
                    //color: Colors.white70,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 50.0, right: 50.0),
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                elevation: 10,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Image.asset("images/filles.png"),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                elevation: 10,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const ListTile(
                                      //leading: Icon(Icons.video_library),
                                      title: Text('', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                                      subtitle: Text('La santé revêt une importance vitale pour tous les êtres humains dans le monde, Tout le monde  a le droit d’avoir accès en temps opportun aux services de santé appropriés.\n Cela suppose l\’établissement d\’un système de protection de la santé, avec l\’accès aux médicaments essentiels.'
                                        , style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  /*
                  Center(
                    child: Text("Les vidéos", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
                  ),
                  Divider(
                    height: 50.0,
                    thickness: 3,
                    //color: Colors.white70,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  Center(
                    //margin: EdgeInsets.only(left: 50.0, right: 50.0),
                    child: Card(
                      child: Text("Video non disponible !"),
                    ),
                  ),
                  Center(
                    child: Text("", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
                  ),
                  */
                  Divider(
                    height: 50.0,
                    thickness: 3,
                    //color: Colors.white70,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                ],
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
        child: _sante,
      ),
    );
  }
}