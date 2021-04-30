import 'package:flutter/material.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'phoneCall.dart';
import 'myWidget.dart';
import 'profileUser.dart';
import 'repas.dart';
import 'video_view.dart';


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
                  Container(
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
                                  new Image.asset("images/eleves.jpg"),
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
                                    subtitle: Text('L’éducation est vitale pour le développement économique, social et culturel de toutes les sociétés; L’éducation est un droit humain qui doit être accessible à toutes les personnes, sans aucune discrimination. Tous les enfants doivent pouvoir aller à l’école, et ainsi bénéficier des mêmes opportunités de se construire un avenir'
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
                  Container(
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
                                  new Image.asset("images/eleves.jpg"),
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
                                    subtitle: Text('L’éducation est vitale pour le développement économique, social et culturel de toutes les sociétés; L’éducation est un droit humain qui doit être accessible à toutes les personnes, sans aucune discrimination. Tous les enfants doivent pouvoir aller à l’école, et ainsi bénéficier des mêmes opportunités de se construire un avenir'
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


class CallProfileEleve extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

    return Container(
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
                  idtypefonction == "EV" ? _profile : Container(),
                  RaisedButton(
                    elevation: 0,
                    padding: EdgeInsets.all(0.0),
                    color: Colors.transparent,
                    disabledColor: Colors.transparent,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Repas()),
                      );
                    },
                    child: Image.asset("images/repas.png"),
                  ),
                ],
              ),
            )
        )
    );
  }
}