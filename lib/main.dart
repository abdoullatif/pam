//package
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:get_version/get_version.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
//pakage importer pub get
import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neeko/neeko.dart';
import 'package:pam/components/ModifStock.dart';
import 'package:pam/components/adminPannel.dart';
import 'package:pam/searchUI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:video_player/video_player.dart';
import 'package:fcharts/fcharts.dart';
import 'package:usb_serial/usb_serial.dart';
//------------mes modeles lass prince
import 'package:pam/model/UserControl.dart';
import 'package:pam/model/nfc_auth.dart';
import 'package:pam/model/UserIn.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/components/horizontal_listview.dart';
import 'package:pam/components/ShowVideo.dart';
import 'package:pam/components/myWidget.dart';
import 'package:pam/database/database.dart';
import 'package:pam/components/formulaire.dart';
import 'components/forgetuid.dart';
import 'components/slider.dart';
//Synchronisation
import 'package:pam/synchro/server_to_local.dart';
import 'package:pam/synchro/records.dart';
import 'package:pam/synchro/Videos.dart';

import 'components/supervision.dart';
import 'components/video_view.dart';

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

//***************************************************************Acceuill*****
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
                            } else if (tab.isEmpty) {
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
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => PageLogin()),
                              );
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
//////////////////////////////////////////////////////////////////////////////////////

class AgricultureWindows extends StatefulWidget {
  @override
  _AgricultureWindowsState createState() => _AgricultureWindowsState();
}

class _AgricultureWindowsState extends State<AgricultureWindows> {


  VideoControllerWrapper _controllerWrapper;

  //static const String beeUri = 'https://media.w3.org/2010/05/sintel/trailer.mp4';
  //static const String beeUri = 'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4';

  /*
  final VideoControllerWrapper videoControllerWrapper = VideoControllerWrapper(
      DataSource.network(
          'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4',
          displayName: "displayName"));
  */

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

    final categ = ModalRoute.of(context).settings.arguments;
    String Langue = "Français";
    //Selection de video de presentation agriculture dans la base de donner
    //***********************************************************************
    Future<List<Map<String, dynamic>>> MediaPresentation() async{
      var _parametre = await DB.initTabquery();
      if(_parametre[0]['langue'] != "" || _parametre[0]['langue'] != null) {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaCateg(categ,_parametre[0]['langue']);
        return queryRows;
      } else {
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
              //File("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[0]['media_file']}"))),
              /*
              ChewieItem(
                  videoPlayerController: VideoPlayerController.file(File("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[0]['media_file']}")),
                  looping: true,
                ),
              * */
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
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // la baniere
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/banner1.png"),
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
                            child: Text("Agriculture", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),),
                          ),
                        )
                    ),
                  ),
                ),
                // Listview horizontal les sous categories
                HorizontalList(),
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
      ),
    );
  }
}

//----------------------------------------------------Alimentation windows
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
              HorizontalList2(),
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

//--------------------------------------------------------
class CooperativeWindows extends StatefulWidget {
  @override
  _CooperativeWindowsState createState() => _CooperativeWindowsState();
}

class _CooperativeWindowsState extends State<CooperativeWindows> {
  @override
  Widget build(BuildContext context) {
    //
    getThumbnail(String videoPath) async{
      var uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 640, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      return uint8list;
    }
    //
    @override
    void initState() {
      super.initState();
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    }

    @override
    void dispose() {
      SystemChrome.restoreSystemUIOverlays();
      super.dispose();
    }
    //
    final categ = ModalRoute.of(context).settings.arguments;
    var idvideo;
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
    final _cooperative = FutureBuilder(
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
            return Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/banner3.png"),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
                Container(
                  child: Center(
                    child: Container(
                        color: Colors.black,
                        margin: EdgeInsets.only(bottom: 30.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: Text("Cooperative", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),),
                          ),
                        )
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 50,),
                  child: Text("", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Card(
                          elevation: 10,
                          child: Image.asset("images/paysant.png"),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            title: Text('', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                            subtitle: Text('Les cooperatives jouent un rôle essentiel dans les services sociaux, l\'accès aux services financiers afin de réduire la pauvreté et pourvoyer des emplois.'
                              , style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40,),
                Center(
                  child: Text("Vidéos", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
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
                          child: Column(
                            children: [
                              new Card(
                                elevation: 10.0,
                                child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    // Use the VideoPlayer widget to display the video.
                                    child: FutureBuilder(
                                        future: getThumbnail("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[index]['media_file']}"),
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          var imgThumbnail = snapshot.data;
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
                                          return Image.memory(imgThumbnail);
                                        }
                                    )
                                  //pathThumnail != null ? Image.memory(pathThumnail) : Container(), //VideoPlayer(_controller), //Image.asset('images/cover.png'), // Image.memory(pathThumnail), //VideoPlayer(_controller),
                                ),
                              ),
                              SizedBox(height: 20.0,),
                              //Image.asset('images/cover.png'),
                              Text(snap[index]['media_title'] != null ? snap[index]['media_title'] : "" , style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Center(
                  child: Text("", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
                ),
                Divider(
                  height: 50.0,
                  thickness: 3,
                  //color: Colors.white70,
                  indent: 50.0,
                  endIndent: 50.0,
                ),
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/banner3.png"),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
                Container(
                  child: Center(
                    child: Container(
                        color: Colors.black,
                        margin: EdgeInsets.only(bottom: 30.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: Text("Cooperative", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),),
                          ),
                        )
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 50,),
                  child: Text("", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Card(
                          elevation: 10,
                          child: Image.asset("images/paysant.png"),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            title: Text('', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                            subtitle: Text('Les cooperatives jouent un rôle essentiel dans les services sociaux, l\'accès aux services financiers afin de réduire la pauvreté et pourvoyer des emplois.'
                              , style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40,),
                Center(
                  child: Text("Vidéos", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
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
                Divider(
                  height: 50.0,
                  thickness: 3,
                  //color: Colors.white70,
                  indent: 50.0,
                  endIndent: 50.0,
                ),
              ],
            );
          }
        }
    );
    //--------------------------------------------------------------------------
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
          child: _cooperative,
        ),
      ),
    );
  }
}

//****************************************************************************

class ElevesWindows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final categ = ModalRoute.of(context).settings.arguments;
    var idvideo;
    //var lang = "Malinké";
    String Langue = "Français";

    getThumbnail(String videoPath) async{
      var uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 640, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      return uint8list;
    }
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
    final _education = FutureBuilder(
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
                          image: AssetImage("images/banner4.png"),
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Container(
                          color: Colors.black,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Text("Education", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold,),),
                            ),
                          )
                      ),
                    ),
                  ),
                  CallProfileEleve(),
                  Divider(
                    height: 50.0,
                    thickness: 3,
                    //color: Colors.white70,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  Component1Eleve(),
                  SizedBox(height: 25,),
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
                            child: Column(
                              children: [
                                new Card(
                                  elevation: 10.0,
                                  child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      // Use the VideoPlayer widget to display the video.
                                      child: FutureBuilder(
                                          future: getThumbnail("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[index]['media_file']}"),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            var imgThumbnail = snapshot.data;
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
                                            return Image.memory(imgThumbnail);
                                          }
                                      )
                                    //pathThumnail != null ? Image.memory(pathThumnail) : Container(), //VideoPlayer(_controller), //Image.asset('images/cover.png'), // Image.memory(pathThumnail), //VideoPlayer(_controller),
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                //Image.asset('images/cover.png'),
                                Text(snap[index]['media_title'] != null ? snap[index]['media_title'] : "" , style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Center(
                    child: Text("", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
                  ),
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
                          image: AssetImage("images/banner4.png"),
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Container(
                          color: Colors.black,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Text("Education", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold,),),
                            ),
                          )
                      ),
                    ),
                  ),
                  CallProfileEleve(),
                  Divider(
                    height: 50.0,
                    thickness: 3,
                    //color: Colors.white70,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  Component1Eleve(),
                  SizedBox(height: 25,),
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
        child: _education,
      ),
    );
  }
}

class SanteWindows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

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
                  CallProfileSante(),
                  Divider(
                    height: 50.0,
                    thickness: 3,
                    //color: Colors.white70,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  Container(
                    child: Component1Sante(),
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
                  CallProfileSante(),
                  Divider(
                    height: 50.0,
                    thickness: 3,
                    //color: Colors.white70,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  Container(
                    child: Component1Sante(),
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

/////////////////////////////////////////Administrateurs/////////////////////

// ignore: must_be_immutable
/*
class PageLogin extends StatelessWidget {
  @override
}
*/
class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  //variable de connexion
  TextEditingController _email = TextEditingController();
  TextEditingController _mdp = TextEditingController();
  //nfc
  bool nfc_msg_visible = false;
  //String
  String iud = "";
  String nfc = "";

  @override
  Widget build(BuildContext context) {
    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      iud = response.id.substring(2);
      nfc = iud.toUpperCase();
    });
    //les champs et boutton
    final emailField = TextFormField(
      obscureText: false,
      style: style,
      controller: _email,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Padding(
          padding: EdgeInsets.all(0.0),
          child: Icon(
            Icons.account_circle,
            color: Colors.grey,
          ), // icon is 48px widget.
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Veuiller entrer votre addresse email';
        }
        return null;
      },
    );
    final passwordField = TextFormField(
      obscureText: true,
      style: style,
      controller: _mdp,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Padding(
          padding: EdgeInsets.all(0.0),
          child: Icon(
            Icons.vpn_key,
            color: Colors.grey,
          ), // icon is 48px widget.
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Veuiller entrer votre mot de passe';
        }
        return null;
      },
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async{
          //
          var iud_bracelet = StorageUtil.getString("iud");
          if (_formKey.currentState.validate()) {
            // verification de l'admin
            Future<void> Selectpersonne() async{

              List<Map<String, dynamic>> queryPersonne = await DB.query2Where("personne", _email.text, _mdp.text);
              //return queryCodif;
              if(queryPersonne.isNotEmpty){
                //nfc
                if (nfc != ""){
                  List<Map<String, dynamic>> verifUid = await DB.query3Where("personne",_email.text,_mdp.text,nfc);
                  if(verifUid.isNotEmpty){
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
                      ////////////////////////////////////////////////////////////////////////////////
                      //si tout ce passe bien on le redirige vers le pannel admin
                      setState(() {
                        _email = TextEditingController()..text = '';
                        _mdp = TextEditingController()..text = '';
                      });
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AdminWindows()),
                      );
                      ////////////////////////////////////////////////////////////////////////////////
                    }
                  } else {
                    var confirm = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Authentification"),
                          content: Text(
                            'Ce bracelets ne correspond pas a votre identifiants', style: TextStyle(color: Colors.red,),),
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
                } else {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Authentification"),
                        content: Text(
                          'Veuillez Scanner votre bracelet pour confirmer votre identite', style: TextStyle(color: Colors.green,),),
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
              } else if(_email.text == "SuperAdminTulipInd@tld.com" && _mdp.text == "TulipInd2017"){
                //Si on est super utiliisateur
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('email', "SuperAdminTulipInd@tld.com");
                prefs.setString('mdp', "TulipInd2017");
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AdminWindows()),
                );
              } else {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Probleme d'identification"),
                      content: const Text("Oups nous avons rencontrer un probleme lors de l'identification, Veuiller ressailler ou contacter la call center"),
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
            }
            //end
            Selectpersonne();
          }
        },
        child: Text("Se connecter",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    //end
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
        child: Form(
          key: _formKey,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 100.0, right: 100.0),
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  //Column(),
                  SizedBox(height: 30.0),
                  SizedBox(
                    height: 100.0,
                    child: Image.asset(
                      "images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 45.0),
                  emailField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(
                    height: 35.0,
                  ),
                  loginButon,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////
class ControlPannel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
      ),
      body: SaveIdTab(),
    );
  }
}
////////////////////////////////////////////////////////////////////////

class SaveIdTab extends StatefulWidget {
  @override
  _SaveIdTabState createState() => _SaveIdTabState();
}

class _SaveIdTabState extends State<SaveIdTab> {
  //-----------------------------------------------------------------------------------
  //variable
  final _formKey = GlobalKey<FormState>();

  //TextEditingController _locate = TextEditingController();
  TextEditingController _device = TextEditingController();
  TextEditingController _adresse_server = TextEditingController();
  TextEditingController _ip_server = TextEditingController();
  TextEditingController _site_commercant = TextEditingController();
  TextEditingController _site_pam = TextEditingController();
  TextEditingController _user = TextEditingController();
  TextEditingController _mdp = TextEditingController();
  TextEditingController _dbname = TextEditingController();
  //-------------------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 100.0, right: 100.0, top: 30, bottom: 30.0,),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              //color: Colors.indigo,
                margin: EdgeInsets.only(bottom: 30.0),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 30.0,
                    child: Text("Panneau de configuration", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),),
                  ),
                )
            ),
            TextFormField(
              obscureText: false,
              controller: _device,
              decoration: InputDecoration(
                icon: Icon(Icons.tablet, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Identifiant de la tablette",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  print(value);
                  return 'Veuiller entrer le nom de la tablette';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            //_Localites,
            //SizedBox(height: 25.0),
            /*
            TextFormField(
              obscureText: false,
              controller: _locate,
              decoration: InputDecoration(
                icon: Icon(Icons.add_location, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "localite manuel",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le nom de la localite';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            */
            TextFormField(
              obscureText: false,
              controller: _adresse_server,
              decoration: InputDecoration(
                icon: Icon(Icons.vpn_lock, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Adresse DNS du server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer l\'Adresse DNS du server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _dbname,
              decoration: InputDecoration(
                icon: Icon(Icons.vpn_lock, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Nom de la base de donnee",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer l\'Adresse DNS du server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _ip_server,
              decoration: InputDecoration(
                icon: Icon(Icons.settings, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Adresse ip du server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer l\'Adresse ip du server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _site_commercant,
              decoration: InputDecoration(
                icon: Icon(Icons.web, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Site web pour effectuer des commandes (commercant)",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le Site web pour effectuer des commandes (commercant)';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _site_pam,
              decoration: InputDecoration(
                icon: Icon(Icons.web, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Site web officiel du pam",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le nom de la tablette';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _user,
              decoration: InputDecoration(
                icon: Icon(Icons.edit, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Nom utlilisateur server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le Nom utlilisateur server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _mdp,
              decoration: InputDecoration(
                icon: Icon(Icons.security, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Mot de passe Utilisateur-server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le Mot de passe Utilisateur-server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/2.1,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xff01A0C7),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () async{
                        if (true) {
                          //Verification
                          List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
                          if(tab.isNotEmpty){
                            //On modifie les informations present
                            await DB.update("parametre", {
                              "device": _device.text,
                              "adresse_server": _adresse_server.text,
                              "dbname": _dbname.text,
                              "ip_server": _ip_server.text,
                              "site_commercant": _site_commercant.text,
                              "site_pam": _site_pam.text,
                              "user": _user.text,
                              "mdp": _mdp.text,
                            },tab[0]['id']);
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Modification effectuer avec succes !')));
                          } else {
                            // insertion du nom de la tablette
                            await DB.insert("parametre", {
                              "device": _device.text,
                              "adresse_server": _adresse_server.text,
                              "dbname": _dbname.text,
                              "ip_server": _ip_server.text,
                              "site_commercant": _site_commercant.text,
                              "site_pam": _site_pam.text,
                              "langue": "Français",
                              "user": _user.text,
                              "mdp": _mdp.text,
                            });
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Enregistrement effectuer avec succes !')));
                          }
                        }
                      },
                      child: Text("Enregistrer", textAlign: TextAlign.center,),
                    ),
                  ),
                ),
                VerticalDivider(),
                Container(
                  width: MediaQuery.of(context).size.width/3,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xff01A0C7),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () async{
                        List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
                        if(tab.isNotEmpty){
                          setState(() {
                            //_locate = TextEditingController(text: tab[0]['locate']);
                            _device = TextEditingController(text: tab[0]['device']);
                            _adresse_server = TextEditingController(text: tab[0]['adresse_server']);
                            _dbname = TextEditingController(text: tab[0]['dbname']);
                            _ip_server = TextEditingController(text: tab[0]['ip_server']);
                            _site_commercant = TextEditingController(text: tab[0]['site_commercant']);
                            _site_pam = TextEditingController(text: tab[0]['site_pam']);
                            _user = TextEditingController(text: tab[0]['user']);
                            _mdp = TextEditingController(text: tab[0]['mdp']);
                          });
                        }
                      },
                      child: Text("Voir les info", textAlign: TextAlign.center,),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 35.0),
          ],
        ),
      ),
    );
  }
}


//////////////////////////////////////////////////////////////////////
class AdminWindows extends StatelessWidget {
  //Modele contenant les variable personne/////////////////////////////
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

//pannel update
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

//-------------------------------------------------------------pannel update Contente
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
//************************************************************************************
class ScanUID extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Bracelet perdu : Scanner un nouveau bracelet"),
      ),
      body: component_uid(),
    );
  }
}
//******************************************************panel admin Supervision********
class AdminSuper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Supervision"),
        actions: <Widget> [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                showSearch(context: context, delegate: SearchUI());
              }
          )
        ]
      ),
      body: FormSuper(),
    );
  }
}
//***********************Hero img***********************************************
class UserDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context).settings.arguments;
    //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 30.0),
              child: Hero(
                tag: 'image',
                child: CircleAvatar(
                  radius: 200,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                  backgroundImage: image,
                  //backgroundImage: Image.file(file),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//r****************************Admin use**********************************


//*************************************************************************
/////////////////////////////panel Admin Enregistrement/////////////////
class AdminAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final id = ModalRoute.of(context).settings.arguments;
    //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Enregistrement"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            //les formulaire
            FormAdd(),
          ],
        ),
      ),
    );
  }
}
//////////////////////panel admin Langues//////////////
class AdminLangues extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: ListView(
        children: <Widget>[
          //formulaire
          FormLangues(),
        ],
      ),
    );
  }
}
//***************************************************panel admin bon**************
const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';
class AdminBon extends StatelessWidget {
  
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {

    Future CommerceWeb() async{
      var _tab = await DB.initTabquery();
      //String Url = await "https://fr.wfp.org/";
      return _tab;
    }
    final _CommercantWebsite = FutureBuilder(
        future: CommerceWeb(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement, Veuillez ressaillez ou assurer vous d'etre connecter a internet"),
            );
          }
          return Builder(builder: (BuildContext context) {
            return WebView(
              initialUrl: '${snap[0]['site_commercant']}',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              // TODO(iskakaushik): Remove this when collection literals makes it to stable.
              // ignore: prefer_collection_literals
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            );
          });
        }
    );


    return Scaffold(
      appBar: AppBar(
        title: const Text('Commander un produit'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(_controller.future),
          //SampleMenu(_controller.future),
        ],
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: _CommercantWebsite,
      //floatingActionButton: favoriteButton(),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final String url = await controller.data.currentUrl();
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Favoris $url')),
                );
              },
              child: const Icon(Icons.favorite),
            );
          }
          return Container();
        });
  }
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
}

class SampleMenu extends StatelessWidget {
  SampleMenu(this.controller);

  final Future<WebViewController> controller;
  final CookieManager cookieManager = CookieManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.showUserAgent:
                _onShowUserAgent(controller.data, context);
                break;
              case MenuOptions.listCookies:
                _onListCookies(controller.data, context);
                break;
              case MenuOptions.clearCookies:
                _onClearCookies(context);
                break;
              case MenuOptions.addToCache:
                _onAddToCache(controller.data, context);
                break;
              case MenuOptions.listCache:
                _onListCache(controller.data, context);
                break;
              case MenuOptions.clearCache:
                _onClearCache(controller.data, context);
                break;
              case MenuOptions.navigationDelegate:
                _onNavigationDelegateExample(controller.data, context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.showUserAgent,
              child: const Text('Afficher l\'agent utilisateur'),
              enabled: controller.hasData,
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCookies,
              child: Text('Liste des cookies'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCookies,
              child: Text('Effacer les cookies'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.addToCache,
              child: Text('Ajouter au cache'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCache,
              child: Text('Cache de liste'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCache,
              child: Text('Vider le cache'),
            ),
            /*
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.navigationDelegate,
              child: Text('Exemple de délégué de navigation'),
            ),
            */
          ],
        );
      },
    );
  }

  void _onShowUserAgent(
      WebViewController controller, BuildContext context) async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    await controller.evaluateJavascript(
        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }

  void _onListCookies(
      WebViewController controller, BuildContext context) async {
    final String cookies =
    await controller.evaluateJavascript('document.cookie');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Cookies:'),
          _getCookieList(cookies),
        ],
      ),
    ));
  }

  void _onAddToCache(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript(
        'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
    Scaffold.of(context).showSnackBar(const SnackBar(
      content: Text('Ajouter !'),
    ));
  }

  void _onListCache(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript('caches.keys()'
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  void _onClearCache(WebViewController controller, BuildContext context) async {
    await controller.clearCache();
    Scaffold.of(context).showSnackBar(const SnackBar(
      content: Text("Cache effacer."),
    ));
  }

  void _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'Il y avait des cookies. Maintenant, ils sont partis!';
    if (!hadCookies) {
      message = 'Il n\'y a pas de cookies.';
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _onNavigationDelegateExample(
      WebViewController controller, BuildContext context) async {
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
    await controller.loadUrl('data:text/html;base64,$contentBase64');
  }

  Widget _getCookieList(String cookies) {
    if (cookies == null || cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
    cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                if (await controller.canGoBack()) {
                  await controller.goBack();
                } else {
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(content: Text("Aucun élément d'historique de retour")),
                  );
                  return;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                if (await controller.canGoForward()) {
                  await controller.goForward();
                } else {
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Aucun élément d'historique de transfert")),
                  );
                  return;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                controller.reload();
              },
            ),
          ],
        );
      },
    );
  }
}
//*************************************************************************
//*************************************************************************
//**********************************************************panel admin Zones
class AdminZone extends StatelessWidget {

  //
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.0472856, -12.8916414),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    //
    Future map() async{
      var _tab = await DB.initTabquery();
      var _locate = await DB.queryWherelocalite("localite",_tab[0]['locate']);
      //String Url = await "https://fr.wfp.org/";
      return _locate;
    }
    final _zone = FutureBuilder(
        future: map(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement, Veuillez ressaillez ou assurer vous d'etre connecter a internet"),
            );
          }
          return snap.isNotEmpty ? GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(snap[0]['latitude']), double.parse(snap[0]['longitude'])),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ) : Center(
            child: Text("Aucune localite selectionner"),
          );
        }
    );
    //
    return Scaffold(
      appBar: AppBar(
        title: Text("Ma zone"),
      ),
      body: _zone,
      /*
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    */
    );
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
//////////////////////panel admin Webview//////////////
class AdminWeb extends StatelessWidget {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    //************************************************************************
    Future PamWeb() async{
      var _tab = await DB.initTabquery();
      //String Url = await "https://fr.wfp.org/";
      return _tab;
    }
    final _PamWebsite = FutureBuilder(
        future: PamWeb(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement, Veuillez ressaillez ou assurer vous d'etre connecter a internet"),
            );
          }
          return Builder(builder: (BuildContext context) {
            return WebView(
              initialUrl: '${snap[0]['site_pam']}',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              // TODO(iskakaushik): Remove this when collection literals makes it to stable.
              // ignore: prefer_collection_literals
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            );
          });
        }
    );
    //--------------------------------------------------------------------------
    return Scaffold(
      appBar: AppBar(
        title: const Text('Site web Pam'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(_controller.future),
          //SampleMenu(_controller.future),
        ],
      ),
      body: _PamWebsite,
    );
  }
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final String url = await controller.data.currentUrl();
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Favoris $url')),
                );
              },
              child: const Icon(Icons.favorite),
            );
          }
          return Container();
        });
  }
}


//****************************************************************************
class Vente extends StatefulWidget {
  @override
  _VenteState createState() => _VenteState();
}

class _VenteState extends State<Vente> {
  final List<Map<String, String>> listOfColumns = [
    {"Date": "AAAAAA", "Agriculteur": "1", "Prix Achat": "Yes", "Quantite Acheter": "Yes"},
    {"Date": "BBBBBB", "Agriculteur": "2", "Prix Achat": "no", "Quantite Acheter": "Yes"},
    {"Date": "CCCCCC", "Agriculteur": "3", "Prix Achat": "Yes", "Quantite Acheter": "Yes"}
  ];
  @override
  Widget build(BuildContext context) {
    // var
    var idpersonne = '';
    var nom = '';
    var prenom = '';
    var date_naissance = '';
    var idgenre = '';
    var date_creation = '';
    var iud = '';
    var email = '';
    var mdp = '';
    var image = '';
    var idadresse = '';
    var idlocalite = '';
    var adresse = '';
    var idpersonne_fonction = '';
    var idtypefonction = '';
    var idecole = '';
    var ecole = '';
    //asynchrone
    idpersonne = StorageUtil.getString("idpersonne");
    nom = StorageUtil.getString("nom");
    prenom = StorageUtil.getString("prenom");
    date_naissance = StorageUtil.getString("date_naissance");
    idgenre = StorageUtil.getString("idgenre");
    date_creation = StorageUtil.getString("date_creation");
    iud = StorageUtil.getString("iud");
    email = StorageUtil.getString("email");
    mdp = StorageUtil.getString("mdp");
    image = StorageUtil.getString("image");
    idlocalite = StorageUtil.getString("idlocalite");
    adresse = StorageUtil.getString("adresse");
    idpersonne_fonction = StorageUtil.getString("idpersonne_fonction");
    idtypefonction = StorageUtil.getString("idtypefonction");
    idecole = StorageUtil.getString("idecole");
    ecole = StorageUtil.getString("ecole");
    //Future builder
    Future<List<Map<String, dynamic>>> historique_vente() async{
      List<Map<String, dynamic>> queryRows = await DB.queryVente(idpersonne);
      return queryRows;
    }
    final _vente = FutureBuilder(
        future: historique_vente(),
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
          return Container(
            child: Center(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Date', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                    DataColumn(label: Text('Agriculteur', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                    DataColumn(label: Text('Prix Achat', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                    DataColumn(label: Text('Culture', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                    DataColumn(label: Text('Quantité Achetée', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                    DataColumn(label: Text('Code du Réçu', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                  ],
                  rows:
                  snap // Loops through dataColumnText, each iteration assigning the value to element
                      .map(
                    ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(element["Date"], style: TextStyle(fontSize: 16.0),)), //Extracting from Map element the value
                        DataCell(Text(element["Agriculteur"], style: TextStyle(fontSize: 16.0),)),
                        DataCell(Text(element["Prix"], style: TextStyle(fontSize: 16.0),)),
                        DataCell(Text(element["Culture"], style: TextStyle(fontSize: 16.0),)),
                        DataCell(Text(element["Quantite"]+" Kg", style: TextStyle(fontSize: 16.0),)),
                        DataCell(Text(element["Code_recu"], style: TextStyle(fontSize: 16.0),)),
                      ],
                    )),
                  )
                      .toList(),
                ),
              ),
            ),
          );
        }
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Historique d'achat Agriculteur")
      ),
      body: _vente,
    );
  }
}
//------------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class SousCatFemme extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    getThumbnail(String videoPath) async{
      var uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 640, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      return uint8list;
    }

    final Scateg = ModalRoute.of(context).settings.arguments;
    var idvideo;
    //var lang = "Malinké";
    String categ = "Sante";
    String Langue = "Français";
    //Selection de video de presentation agriculture dans la base de donner
    //***********************************************************************
    Future<List<Map<String, dynamic>>> MediaPresentation() async{
      var _parametre = await DB.initTabquery();
      if(_parametre[0]['langue'] != "" || _parametre[0]['langue'] != null) {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaScateg(categ,Scateg,_parametre[0]['langue']);
        return queryRows;
      } else {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaScateg(categ,Scateg,Langue);
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
            return Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Scateg == "Femme Enceinte" ? AssetImage("images/banner6.png") : AssetImage("images/banner7.png"),
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
                            child: Text(Scateg, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),),
                          ),
                        )
                    ),
                  ),
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
                          child: Column(
                            children: [
                              new Card(
                                elevation: 10.0,
                                child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    // Use the VideoPlayer widget to display the video.
                                    child: FutureBuilder(
                                        future: getThumbnail("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[index]['media_file']}"),
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          var imgThumbnail = snapshot.data;
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
                                          return Image.memory(imgThumbnail);
                                        }
                                    )
                                  //pathThumnail != null ? Image.memory(pathThumnail) : Container(), //VideoPlayer(_controller), //Image.asset('images/cover.png'), // Image.memory(pathThumnail), //VideoPlayer(_controller),
                                ),
                              ),
                              SizedBox(height: 20.0,),
                              //Image.asset('images/cover.png'),
                              Text(snap[index]['media_title'] != null ? snap[index]['media_title'] : "" , style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          } else{
            return Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/banner6.png"),
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
                            child: Text(Scateg, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),),
                          ),
                        )
                    ),
                  ),
                ),
                Center(
                  child: Card(
                    child: Text("Video non disponible !"),
                  ),
                ),
              ],
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


