import 'package:flutter/material.dart';
import 'package:pam/components/chewieItem.dart';
import 'package:video_player/video_player.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';

//**********************************************Componnent cooperative widget
//////////////////////////////////////////////////////////////////

class VideoCard extends StatefulWidget {
  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 50.0, right: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Card(
                    elevation: 10,
                    child: ChewieItem(
                      videoPlayerController: VideoPlayerController.asset("",),
                      looping: true,
                    ),
                  ),
                  Card(
                    elevation: 10,
                    child: ListTile(
                      title: Text('Une association pour une meilleur production', style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                      subtitle: Text('\n Lorem ipsum dolor sit amet, . \n'
                          'Proin gravida dolor sit amet lacus accumsan . \n'
                          'Cum sociis natoque penatibus et magnis dis ,'
                        , style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                    ),
                  ),
                ],
              ),
            )

        )

    );
  }
}
//////////////////////////////////////////////////////////////////
////////////////////// End Video dans des Gridview //////////
////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
////////////////////// Affiche les video dans des gridview Agriculture //////////
////////////////////////////////////////////////////////////////////

class ShowVideoCard extends StatefulWidget {
  @override
  _ShowVideoCardState createState() => _ShowVideoCardState();
}

class _ShowVideoCardState extends State<ShowVideoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 10,
              //margin: EdgeInsets.only(bottom: 120.0,),
              child: ChewieItem(
                videoPlayerController: VideoPlayerController.asset("",),
                looping: true,
              ),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 10,
              //margin: EdgeInsets.only(bottom: 120.0,),
              child: ChewieItem(
                videoPlayerController: VideoPlayerController.asset("",),
                looping: true,
              ),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 10,
              //margin: EdgeInsets.only(bottom: 120.0,),
              child: ChewieItem(
                videoPlayerController: VideoPlayerController.asset("",),
                looping: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//////////////////////////////////////////////////////////////////
////////////////////// End Video dans des gridview Agriculture//////////
////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
////////////////////////////// component 1 /////////////////////
//////////////////////////////////////////////////////////////////////////

class Component1 extends StatefulWidget {
  @override
  _Component1State createState() => _Component1State();
}

class _Component1State extends State<Component1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      child: Center(
        child: new Container(
          margin: EdgeInsets.only(left: 50.0, right: 50.0),
          child: GridView.count(
            padding: const EdgeInsets.all(0.0),
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              new Card(
                elevation: 10,
                //margin: EdgeInsets.only(top: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Image.asset("images/paysant.png"),
                    const ListTile(
                      //leading: Icon(Icons.video_library),
                      title: Text('Nos paysants', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                      //subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
                    ),
                  ],
                ),
              ),
              new Card(
                elevation: 10,
                //margin: EdgeInsets.only(top: 30.0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    Container(
                      height: 80,
                      //color: Colors.amber[600],
                      child: const ListTile(
                        leading: Icon(Icons.video_library),
                        title: Text('Lorem ipsum dolor sit amet', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      height: 80,
                      //color: Colors.amber[600],
                      child: const ListTile(
                        leading: Icon(Icons.video_library),
                        title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      height: 80,
                      //color: Colors.amber[600],
                      child: const ListTile(
                        leading: Icon(Icons.video_library),
                        title: Text('Lorem ipsum dolor sit amet', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
////////////////////////////// End component 1 /////////////////////
//////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
////////////////////////////// component 2 /////////////////////
//////////////////////////////////////////////////////////////////////////

class Component2 extends StatefulWidget {
  @override
  _Component2State createState() => _Component2State();
}

class _Component2State extends State<Component2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.0,
      child: Center(
          child: new Container(
            margin: EdgeInsets.only(left: 50.0, right: 50.0),
            child: GridView.count(
              padding: const EdgeInsets.all(0.0),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              crossAxisCount: 3,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La semence', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La récolte', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )

      ),
    );
  }
}
///////////////////////////////////////////////////////////////////////////
////////////////////////////// End component 2 /////////////////////
//////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
////////////////////////////// component 3 /////////////////////
//////////////////////////////////////////////////////////////////////////

class Component3 extends StatefulWidget {
  @override
  _Component3State createState() => _Component3State();
}

class _Component3State extends State<Component3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.0,
      child: Center(
        child: new Container(
          margin: EdgeInsets.only(left: 50.0, right: 50.0),
          child: GridView.count(
            padding: const EdgeInsets.all(0.0),
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              new Card(
                elevation: 10,
                //margin: EdgeInsets.only(top: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new ChewieItem(
                      videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                      looping: true,
                    ),
                    const ListTile(
                      //leading: Icon(Icons.video_library),
                      title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                      //subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
                    ),
                  ],
                ),
              ),
              new Card(
                elevation: 10,
                //margin: EdgeInsets.only(top: 30.0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    Container(
                      height: 80,
                      //color: Colors.amber[600],
                      child: const ListTile(
                        leading: Icon(Icons.video_library),
                        title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      height: 80,
                      //color: Colors.amber[600],
                      child: const ListTile(
                        leading: Icon(Icons.video_library),
                        title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      height: 80,
                      //color: Colors.amber[600],
                      child: const ListTile(
                        leading: Icon(Icons.video_library),
                        title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
////////////////////////////// End component 3 /////////////////////
//////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
///////////////////////////Componnent ElevesWindows widget///////////////////////
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
////////////////////////////// component 1  Eleve  /////////////////////
//////////////////////////////////////////////////////////////////////////

class Component1Eleve extends StatefulWidget {
  @override
  _Component1EleveState createState() => _Component1EleveState();
}

class _Component1EleveState extends State<Component1Eleve> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

///////////////////////////////////////////////////////////////////////////
////////////////////////////// End component 1 /////////////////////
//////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
////////////////////// Affiche les video dans des gridview Agriculture //////////
////////////////////////////////////////////////////////////////////

class ShowVideoEleve extends StatefulWidget {
  @override
  _ShowVideoEleveState createState() => _ShowVideoEleveState();
}

class _ShowVideoEleveState extends State<ShowVideoEleve> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      child: Center(
          child: new Container(
            margin: EdgeInsets.only(left: 50.0, right: 50.0),
            child: GridView.count(
              padding: const EdgeInsets.all(0.0),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              crossAxisCount: 3,
              //scrollDirection: ,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )

      ),

    );
  }
}
//////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
////////////////////////////// component 2 /////////////////////
//////////////////////////////////////////////////////////////////////////

class Component2Eleve extends StatefulWidget {
  @override
  _Component2EleveState createState() => _Component2EleveState();
}

class _Component2EleveState extends State<Component2Eleve> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.0,
      child: Center(
          child: new Container(
            margin: EdgeInsets.only(left: 50.0, right: 50.0),
            child: GridView.count(
              padding: const EdgeInsets.all(0.0),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              crossAxisCount: 3,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La semence', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La récolte', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )

      ),
    );
  }
}
///////////////////////////////////////////////////////////////////////////
////////////////////////////// End component 2 /////////////////////
//////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
////////////////////////////// Component 3 /////////////////////
//////////////////////////////////////////////////////////////////////////


class Component3Eleve extends StatefulWidget {
  @override
  _Component3EleveState createState() => _Component3EleveState();
}

class _Component3EleveState extends State<Component3Eleve> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 10,
        //margin: EdgeInsets.only(top: 30.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              height: 80,
              //color: Colors.amber[600],
              child: const ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Container(
              height: 80,
              //color: Colors.amber[600],
              child: const ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Container(
              height: 80,
              //color: Colors.amber[600],
              child: const ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
////////////////////////////// End component 3 /////////////////////
//////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
///////////////////////////Componnent SanteWindows widget///////////////////////
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
////////////////////////////// component 1  SanteWindows  /////////////////////
//////////////////////////////////////////////////////////////////////////

class Component1Sante extends StatefulWidget {
  @override
  _Component1SanteState createState() => _Component1SanteState();
}

class _Component1SanteState extends State<Component1Sante> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

///////////////////////////////////////////////////////////////////////////
////////////////////////////// End component 1 /////////////////////
//////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
////////////////////////////// component 2 SANTE   SANTER  SANTER /////////////////////
//////////////////////////////////////////////////////////////////////////

////////////////////// Affiche les video dans des gridview Agriculture //////////
////////////////////////////////////////////////////////////////////

class ShowVideoSante extends StatefulWidget {
  @override
  _ShowVideoSanteState createState() => _ShowVideoSanteState();
}

class _ShowVideoSanteState extends State<ShowVideoSante> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      child: Center(
          child: new Container(
            margin: EdgeInsets.only(left: 50.0, right: 50.0),
            child: GridView.count(
              padding: const EdgeInsets.all(0.0),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              crossAxisCount: 3,
              //scrollDirection: ,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  margin: EdgeInsets.only(bottom: 120.0,),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("",),
                        looping: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )

      ),

    );
  }
}
//////////////////////////////////////////////////////////////////


class Component2Sante extends StatefulWidget {
  @override
  _Component2SanteState createState() => _Component2SanteState();
}

class _Component2SanteState extends State<Component2Sante> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.0,
      child: Center(
          child: new Container(
            margin: EdgeInsets.only(left: 50.0, right: 50.0),
            child: GridView.count(
              padding: const EdgeInsets.all(0.0),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              crossAxisCount: 3,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La semence', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La récolte', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
                new Card(
                  elevation: 10,
                  //margin: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ChewieItem(
                        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                        looping: true,
                      ),
                      const ListTile(
                        //leading: Icon(Icons.video_library),
                        title: Text('La jachère', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )

      ),
    );
  }
}
///////////////////////////////////////////////////////////////////////////
////////////////////////////// End component 2 /////////////////////
//////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
////////////////////////////// Component 3 /////////////////////
//////////////////////////////////////////////////////////////////////////




class Component3Sante extends StatefulWidget {
  @override
  _Component3SanteState createState() => _Component3SanteState();
}

class _Component3SanteState extends State<Component3Sante> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      child: Center(
        child: new Container(
          margin: EdgeInsets.only(left: 80.0, right: 80.0),
          child: GridView.count(
            padding: const EdgeInsets.all(0.0),
            crossAxisSpacing: 40.0,
            mainAxisSpacing: 40.0,
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              new Card(
                elevation: 10,
                //margin: EdgeInsets.only(top: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new ChewieItem(
                      videoPlayerController: VideoPlayerController.asset("videos/video1.mp4",),
                      looping: true,
                    ),
                    const ListTile(
                      //leading: Icon(Icons.video_library),
                      title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold,),),
                      //subtitle: Text('Descriptions simple', style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
                    ),
                  ],
                ),
              ),
              new Card(
                elevation: 10,
                //margin: EdgeInsets.only(top: 30.0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    Container(
                      height: 80,
                      //color: Colors.amber[600],
                      child: const ListTile(
                        leading: Icon(Icons.video_library),
                        title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      height: 80,
                      //color: Colors.amber[600],
                      child: const ListTile(
                        leading: Icon(Icons.video_library),
                        title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      height: 80,
                      //color: Colors.amber[600],
                      child: const ListTile(
                        leading: Icon(Icons.video_library),
                        title: Text('Les produits laitiers', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Aenean euismod bibendum laoreet.', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
////////////////////////////// End component 3 /////////////////////
//////////////////////////////////////////////////////////////////////////