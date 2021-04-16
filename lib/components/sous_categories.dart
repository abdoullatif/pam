
import 'dart:io';
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:pam/components/video_view.dart';
import 'package:pam/database/database.dart';
import 'package:video_player/video_player.dart';

class SousCat extends StatefulWidget {

  @override
  _SousCatState createState() => _SousCatState();
}

class _SousCatState extends State<SousCat> {
  Future<void> _initializeVideoPlayerFuture;

  VideoPlayerController _controller;
  //VoidCallback _listener;


  @override
  void initState() {
    // TODO: implement initState
    //VideoPlayerController _old = _controller;
    print(_controller);
    if(mounted)
      setState(() {
        _controller = null;
      });
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    //_controller.removeListener(_listener);
  }


  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    //VideoPlayerController _old = _controller;
    print("Sortir des video sous categories");
    if(_controller != null) {
      _controller.dispose();
      _controller = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Uint8List pathThumnail;

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

    final name = ModalRoute.of(context).settings.arguments;
    var idvideo;
    //var lang = "Malinké";
    String categ = "Agriculture";
    String Langue = "Francais";
    //Selection de video de presentation agriculture dans la base de donner
    //***********************************************************************
    Future<List<Map<String, dynamic>>> MediaPresentation() async{
      var _parametre = await DB.initTabquery();
      if(_parametre[0]['langue'] != "" || _parametre[0]['langue'] != null) {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaScateg(categ,name,_parametre[0]['langue']);
        return queryRows;
      } else {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaScateg(categ,name,Langue);
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
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
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
                              child: Text(name, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),),
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

                        //_controller.addListener(_listener);
                        //_controller = VideoPlayerController.file(File("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[index]['media_file']}"));
                        //_controller.initialize(); //_initializeVideoPlayerFuture =
                        //_controller.pause();
                        //_controller.dispose();
                        //_controller.setLooping(true);

                        //pathThumnail = getThumbnail("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[index]['media_file']}")
                        //getThumbnail("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[index]['media_file']}").then((value) => pathThumnail = value);
                        //print(pathThumnail);

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
                              )
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          } else{
            return Column(
              children: <Widget>[
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
                            child: Text(name, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),),
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