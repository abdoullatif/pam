import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pam/database/database.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'video_view.dart';

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