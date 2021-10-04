import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neeko/neeko.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/page&widget/video_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'phoneCall.dart';
import 'profileUser.dart';
import 'sous_categories.dart';


class AgricultureWindows extends StatefulWidget {
  @override
  _AgricultureWindowsState createState() => _AgricultureWindowsState();
}

class _AgricultureWindowsState extends State<AgricultureWindows> {


  VideoControllerWrapper _controllerWrapper;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }

  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();
    //if (_controllerWrapper.controller != null && _controllerWrapper.controller.value.isPlaying) _controllerWrapper.controller. pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //
    getThumbnail(String videoPath) async{
      var uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 1280, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      return uint8list;
    }

    final categ = ModalRoute.of(context).settings.arguments;
    String Langue = "Français";

    //variable
    var name;
    //
    var idtypefonction = StorageUtil.getString("idtypefonction");
    var emaillog = StorageUtil.getString("email");
    var mdplog = StorageUtil.getString("mdp");
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
              */
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

    //Video presentation capture
    final VideoPresentation = FutureBuilder(
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

            return Center(
              child: RaisedButton(
                  elevation: 0,
                  padding: EdgeInsets.all(0.0),
                  color: Colors.transparent,
                  disabledColor: Colors.transparent,
                  onPressed: (){
                    //Visionage de la video sur page unique
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Visionnage(),settings: RouteSettings(arguments: snap[0]['id'],)),
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
                                future: getThumbnail("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[0]['media_file']}"),
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
                      Text(snap[0]['media_title'] != null ? snap[0]['media_title'] : "" , style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  )
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
                Container(
                    height: 120.0,
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
                              idtypefonction == "AG" ?_profile : (idtypefonction == "CA" ? _profile : Container()),
                              RaisedButton(
                                elevation: 0,
                                padding: EdgeInsets.all(0.0),
                                color: Colors.transparent,
                                disabledColor: Colors.transparent,
                                onPressed: (){
                                  name = "Cereales";

                                  /*
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                      builder: (context) => SousCat(),settings: RouteSettings(arguments: name,)), ModalRoute.withName('/Acceuil')
                                  );
                                  */
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => SousCat(),settings: RouteSettings(arguments: name,)),
                                  );

                                },
                                child: Image.asset("images/cereales.png"),
                              ),
                              RaisedButton(
                                elevation: 0,
                                padding: EdgeInsets.all(0.0),
                                color: Colors.transparent,
                                disabledColor: Colors.transparent,
                                onPressed: (){
                                  name = "Haricots";
                                  /*
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                      builder: (context) => SousCat(),settings: RouteSettings(arguments: name,)), ModalRoute.withName('/Acceuil')
                                  );
                                  */
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => SousCat(),settings: RouteSettings(arguments: name,)),
                                  );
                                },
                                child: Image.asset("images/haricots.png"),
                              ),
                              RaisedButton(
                                elevation: 0,
                                padding: EdgeInsets.all(0.0),
                                color: Colors.transparent,
                                disabledColor: Colors.transparent,
                                onPressed: (){
                                  name = "Oignons";
                                  /*
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                      builder: (context) => SousCat(),settings: RouteSettings(arguments: name,)), ModalRoute.withName('/Acceuil')
                                  );
                                  */
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => SousCat(),settings: RouteSettings(arguments: name,)),
                                  );
                                },
                                child: Image.asset("images/oignons.png"),
                              ),
                              RaisedButton(
                                elevation: 0,
                                padding: EdgeInsets.all(0.0),
                                color: Colors.transparent,
                                disabledColor: Colors.transparent,
                                onPressed: (){
                                  name = "Pommes de Terre";
                                  /*
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                      builder: (context) => SousCat(),settings: RouteSettings(arguments: name,)), ModalRoute.withName('/Acceuil')
                                  );
                                  */
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => SousCat(),settings: RouteSettings(arguments: name,)),
                                  );
                                },
                                child: Image.asset("images/pommesTerre.png"),
                              ),
                              RaisedButton(
                                elevation: 0,
                                padding: EdgeInsets.all(0.0),
                                color: Colors.transparent,
                                disabledColor: Colors.transparent,
                                onPressed: (){
                                  name = "Tomates";
                                  /*
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                      builder: (context) => SousCat(),settings: RouteSettings(arguments: name,)), ModalRoute.withName('/Acceuil')
                                  );
                                  */
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => SousCat(),settings: RouteSettings(arguments: name,)),
                                  );
                                },
                                child: Image.asset("images/tomates.png"),
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
                //Affiche video presentation image for clique,
                VideoPresentation,
                SizedBox(height: 25,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}