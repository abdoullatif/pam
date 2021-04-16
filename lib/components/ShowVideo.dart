import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pam/components/chewieItem.dart';
import 'package:pam/database/database.dart';
//import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:pam/components/myWidget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

//********************************* One video Acceuil
class ShowOneVideo extends StatefulWidget {
  @override
  _ShowOneVideoState createState() => _ShowOneVideoState();
}
class _ShowOneVideoState extends State<ShowOneVideo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: new Container(
            //margin: EdgeInsets.only(left: 50.0, right: 50.0),
            child: ChewieItem(
              videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
              looping: true,
            ),
          )
      ),
    );
  }
}
//******************************************************
//************************************************** One video Agriculture
class ShowOneVideoAlimentation extends StatefulWidget {
  @override
  _ShowOneVideoAlimentationState createState() => _ShowOneVideoAlimentationState();
}
class _ShowOneVideoAlimentationState extends State<ShowOneVideoAlimentation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: new Container(
            margin: EdgeInsets.only(left: 50.0, right: 50.0),
            child: Card(
              elevation: 10,
              child: ChewieItem(
                videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                looping: true,
              ),
            ),
          ),
      ),
    );
  }
}
//************************************************************************
//************************************************** One video Agriculture
class ShowOneVideoAgriculture extends StatefulWidget {
  @override
  _ShowOneVideoAgricultureState createState() => _ShowOneVideoAgricultureState();
}
class _ShowOneVideoAgricultureState extends State<ShowOneVideoAgriculture> {
  @override
  Widget build(BuildContext context) {
    //Selection de video de presentation agriculture dans la base de donner
    //***********************************************************************
    /*
    Future<List<Map<String, dynamic>>> MediaPresentation() async{
      List<Map<String, dynamic>> queryRows = await DB.queryMediaCateg(categ);
      return queryRows;
    }
    final _plantation = FutureBuilder(
        future: Plantationquery(),
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
                child: new Container(
                  margin: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Card(
                    elevation: 10,
                    child: ChewieItem(
                      videoPlayerController: VideoPlayerController.file(File("/storage/emulated/0/Android/data/com.tulipind.pam/files/Videos/snap[0]["media_file"]")),
                      looping: true,
                    ),
                  ),
                )
            ),
          );
        }
    );*/
    //--------------------------------------------------------------------------
    return Container(
      child: Center(
          child: new Container(
            margin: EdgeInsets.only(left: 50.0, right: 50.0),
            child: Card(
              elevation: 10,
              child: ChewieItem(
                videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                looping: true,
              ),
            ),
          )
      ),
    );
  }
}
//***********************************Affiche les video dans des gridview Agriculture
class ShowVideo extends StatefulWidget {
  @override
  _ShowVideoState createState() => _ShowVideoState();
}
class _ShowVideoState extends State<ShowVideo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width/2,
            child: Card(
              elevation: 10,
              child: ChewieItem(
                videoPlayerController: VideoPlayerController.asset("",),
                looping: true,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width/3,
            child: Card(
              elevation: 10,
              child: ListTile(
                title: Text('Une association pour une meilleur production', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                subtitle: Text('\n Lorem ipsum dolor sit amet, . \n'
                    'Proin gravida dolor sit amet lacus accumsan . \n'
                    'Cum sociis natoque penatibus et magnis dis ,'
                  , style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//**************************************End Video dans des gridview Agriculture
//**************************************Affiche les video dans des gridview Alimentation
class ShowVideo2 extends StatefulWidget {
  @override
  _ShowVideo2State createState() => _ShowVideo2State();
}
class _ShowVideo2State extends State<ShowVideo2> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              //margin: EdgeInsets.only(left: 50.0, right: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/2 + MediaQuery.of(context).size.width/4,
                    child: Card(
                      elevation: 10,
                      child: ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/4,
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        title: Text('Chapitre', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                        subtitle: Text('\npoint1 \n'
                            'point2 \n'
                            'point3 \n'
                          , style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//*************************************************End Video dans des Gridview

//******************************Affiche les video dans des gridview Cooperative
class ShowVideo3 extends StatefulWidget {
  @override
  _ShowVideo3State createState() => _ShowVideo3State();
}
class _ShowVideo3State extends State<ShowVideo3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(left: 50,),
            child: Text("Les articles", style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),),
          ),
          Divider(
            height: 50.0,
            thickness: 3,
            //color: Colors.white70,
            indent: 50.0,
            endIndent: 50.0,
          ),
          Container(
            child: Component1(),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 50.0,left: 50,),
            child: Text("Les vidéos", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
          ),
          Divider(
            height: 50.0,
            thickness: 3,
            //color: Colors.white70,
            indent: 80.0,
            endIndent: 80.0,
          ),
          Container(
            child: Component2(),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 50.0,left: 100,),
            child: Text("Interviews", style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),),
          ),
          Divider(
            height: 50.0,
            thickness: 3,
            //color: Colors.white70,
            indent: 80.0,
            endIndent: 80.0,
          ),
          Container(
            child: Component3(),
          ),
        ],
      )
    );
  }
}
//*******************************************************End CooperativeWindows
//*******************************************************start JeunesseWindows
class ShowVideo4 extends StatefulWidget {
  @override
  _ShowVideo4State createState() => _ShowVideo4State();
}
class _ShowVideo4State extends State<ShowVideo4> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 100,),
              child: Text("Les articles", style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),),
            ),
            Divider(
              height: 50.0,
              thickness: 3,
              //color: Colors.white70,
              indent: 80.0,
              endIndent: 80.0,
            ),
            Container(
              child: Component1Eleve(),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 50.0,left: 100,),
              child: Text("Les vidéos", style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),),
            ),
            Divider(
              height: 50.0,
              thickness: 3,
              //color: Colors.white70,
              indent: 80.0,
              endIndent: 80.0,
            ),
            Container(
              child: Component2Eleve(),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 50.0,left: 100,),
              child: Text("Nos conseils", style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),),
            ),
            Divider(
              height: 50.0,
              thickness: 3,
              //color: Colors.white70,
              indent: 80.0,
              endIndent: 80.0,
            ),
            Container(
              //child: Component3Eleve(),
            ),
          ],
        )
    );
  }
}
//*********************************************************End JeunesseWindows
//**********************************************start SanteWindows
class ShowVideo5 extends StatefulWidget {
  @override
  _ShowVideo5State createState() => _ShowVideo5State();
}
class _ShowVideo5State extends State<ShowVideo5> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 100,),
              child: Text("Les articles", style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),),
            ),
            Divider(
              height: 50.0,
              thickness: 3,
              //color: Colors.white70,
              indent: 80.0,
              endIndent: 80.0,
            ),
            Container(
              child: Component1Sante(),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 50.0,left: 100,),
              child: Text("Les vidéos", style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),),
            ),
            Divider(
              height: 50.0,
              thickness: 3,
              //color: Colors.white70,
              indent: 80.0,
              endIndent: 80.0,
            ),
            Container(
              child: Component2Sante(),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 50.0,left: 100,),
              child: Text("Nos conseils", style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),),
            ),
            Divider(
              height: 50.0,
              thickness: 3,
              //color: Colors.white70,
              indent: 80.0,
              endIndent: 80.0,
            ),
            Container(
              //child: Component3Eleve(),
            ),
          ],
        )
    );
  }
}
//************************************************************End SanteWindows
