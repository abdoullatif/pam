import 'dart:io' as io;
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:fcharts/fcharts.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:neeko/neeko.dart';
//import 'package:nfc_in_flutter/nfc_in_flutter.dart';
//package BY lassprince
import 'package:pam/components/ShowVideo.dart';
import 'package:pam/components/repas.dart';
import 'package:pam/components/sous_categories.dart';
import 'package:pam/components/videoPlayer.dart';
import 'package:pam/components/video_view.dart';
import 'package:pam/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../main.dart';
import 'package:pam/database/storageUtil.dart';
//importer
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';

import 'chewieItem.dart';
//import 'package:usb_serial/usb_serial.dart';

//**********************************horizontalle liste Listview on Agriculture
class HorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              idtypefonction == "AG" ?_profile : (idtypefonction == "CA" ? _profile : Container()),
              RaisedButton(
                elevation: 0,
                padding: EdgeInsets.all(0.0),
                color: Colors.transparent,
                disabledColor: Colors.transparent,
                onPressed: (){
                  name = "Cereales";
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
    );
  }
}

//-----------------------------------------------------------------------------
//************************************************Sous categories *************

//*******************************************************************************

class Call extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Service Clientel"),
          centerTitle: true,
        ),
        body: Call_C(),
    );
  }
}

class Call_C extends StatefulWidget {
  @override
  _Call_CState createState() => _Call_CState();
}

class _Call_CState extends State<Call_C> {

  //voice recorder var
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;
  Widget _buttonIcon = Icon(Icons.do_not_disturb_on);
  String _alert;
  //audio
  String iud = StorageUtil.getString("iud");
  String _iud = "";
  String nfc = "";
  //
  //
  AudioPlayer player = AudioPlayer();
  //voice recorder fonc
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }
  //void
  void _opt(DragEndDetails details) async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();
          break;
        }
      case RecordingStatus.Stopped:
        {
          await _prepare();
          //await _startRecording();
          break;
        }

      default:
        break;
    }

    //
    setState(() {
      _buttonIcon = _playerIcon(_recording.status);
    });
  }

/*
  //var global
  @override
  String setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    nom_vocal = DateTime.now().millisecondsSinceEpoch.toString()+".wav";
  }
*/
  var nom_v;
  compteur(){
    var nom_vocal = DateTime.now().millisecondsSinceEpoch.toString()+".wav";
    return nom_vocal;
  }

  //Future ini
  Future _init() async {
    nom_v = compteur();
    String customPath = '/'+
        nom_v;
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath;

    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 22050);
    await _recorder.initialized;
  }


  //prepare
  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        _buttonIcon = _playerIcon(_recording.status);
        _alert = "";
      });
    } else {
      setState(() {
        _alert = "Permission Required.";
      });
    }
  }
  //start recorder
  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }
  //stop
  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
    });
  }
  //play
  void _play() {
    player.play(_recording.path, isLocal: true);
  }
  //pause
  void _pause() {
    player.pause();
  }
  //_send
  void _send() async{
    //le boutton d'envois
    //customPath +
    //DateTime.now().millisecondsSinceEpoch.toString()
    //Insert info song
    var _tab = await DB.initTabquery();
    if(_tab.isNotEmpty){
      //var
      var _tab = await DB.initTabquery();
      String idvocalgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
      var dateNow = DateTime.now();
      //String nom_audio = _tab[0]["device"]+"-"+iud+"-"+dateNow;
      //
      var _vocal = await DB.queryVocal(nom_v);
      if (_vocal.isNotEmpty){
        Fluttertoast.showToast(
            msg: "Votre message a deja ete envoyer !",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        print(nfc);
        if (nfc != ""){
          List<Map<String, dynamic>> queryPersonne = await DB.queryWhereUid("personne", nfc);
          if(queryPersonne.isNotEmpty){
            await DB.insert("fichier_audio", {
              "id": idvocalgen,
              "iud": nfc,
              "nom_audio": nom_v,
              "date_audio": dateNow.toString(),
              "flagtransmis": "false",
            });
            Fluttertoast.showToast(
                msg: "Message Envoyer merci !!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );
          } else {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Bracelet non reconnue"),
                  content: Text(
                    'Ce bracet n\'a pas pu etre identifier, Veuillez contacter la call center', style: TextStyle(color: Colors.green,),),
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
        /*
        if(iud == ""){
          //
        } else {
          await DB.insert("fichier_audio", {
            "id": idvocalgen,
            "iud": iud,
            "nom_audio": nom_v,
            "date_audio": dateNow.toString(),
            "flagtransmis": "false",
          });
          Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text(
              'Message Envoyer merci !')));
        }
        */
      }

    }
  }
  //play icon
  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          //Icon(Icons.settings_voice)
          return Image.asset("images/mic_green.png");
        }
      case RecordingStatus.Recording:
        {
          //Icon(Icons.stop)
          return Image.asset("images/mic_red.png");
        }
      case RecordingStatus.Stopped:
        {
          //Icon(Icons.settings_voice)
          return Image.asset("images/mic_green.png");
        }
      default:
        return Icon(Icons.do_not_disturb_on);
    }
  }
  //
  //commence
  @override
  Widget build(BuildContext context) {
    //nfc
    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      _iud = response.id.substring(2);
      nfc = _iud.toUpperCase();
    });

    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                child: Text('Ecouter'),
                disabledTextColor: Colors.white,
                disabledColor: Colors.grey.withOpacity(0.5),
                onPressed: _recording?.status == RecordingStatus.Stopped
                    ? _play
                    : null,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                children: <Widget>[
                  Text('Enregistrement: ${_recording?.duration ?? "-"}'),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    child: _buttonIcon,
                    //onTapDown: _opt,
                    onHorizontalDragDown: (DragDownDetails details) async {
                      switch (_recording.status) {
                        case RecordingStatus.Initialized:
                          {
                            await _startRecording();
                            break;
                          }
                        case RecordingStatus.Recording:
                          {
                            await _stopRecording();
                            break;
                          }
                        case RecordingStatus.Stopped:
                          {
                            await _prepare();
                            await _startRecording();
                            break;
                          }

                        default:
                          break;
                      }

                      //
                      setState(() {
                        _buttonIcon = _playerIcon(_recording.status);
                      });
                    },
                    onHorizontalDragEnd: _opt,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton(
                    child: Text("Envoyer"),
                    disabledTextColor: Colors.white,
                    disabledColor: Colors.grey.withOpacity(0.5),
                    onPressed: _recording?.status == RecordingStatus.Stopped
                        ? _send
                        : null,
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              RaisedButton(
                child: Text("pause"),
                disabledTextColor: Colors.white,
                disabledColor: Colors.grey.withOpacity(0.5),
                onPressed: _recording?.status == RecordingStatus.Stopped
                    ? _pause
                    : null,
              ),
              Text(''),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '${_alert ?? ""}',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//*****************************************************************************
//*****************************************************************************
//--------------------------------------------------Profiles user--------------
//*****************************************************************************
class Profile extends StatelessWidget {
  //String id = "tablette1-25Z717A68H";
  var idpersonne = StorageUtil.getString("idpersonne");
  var idtypefonction = StorageUtil.getString("idtypefonction");

  @override
  Widget build(BuildContext context) {
    //fonction future bulder
    Future<List<Map<String, dynamic>>> userprofil() async{
      if(idtypefonction == "AG" || idtypefonction == "CA"){
        List<Map<String, dynamic>> queryPerson = await DB.queryUserAgri(idpersonne);
        return queryPerson;
      } else if (idtypefonction == "FE" || idtypefonction == "AFE") {
        List<Map<String, dynamic>> queryPerson = await DB.queryUserFemm(idpersonne);
        return queryPerson;
      } else {
        var _campagneAnneeS = await DB.queryAnneeScolaire();
        String a = _campagneAnneeS[0]['description'];
        String anneeSimple = a.substring(5);
        List<Map<String, dynamic>> queryPerson = await DB.queryUserElev(idpersonne,anneeSimple,a);
        return queryPerson;
      }
    }
    final _user = FutureBuilder(
        future: userprofil(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Map<String, dynamic>> snap = snapshot.data;
          //les cultures
          //Cultures
          Future<List<Map<String, dynamic>>> culture() async{
            List<Map<String, dynamic>> queryPerson = await DB.queryCulture(snap[0]['iddetenteur_plantation']);
            return queryPerson;
          }
          final _culture = FutureBuilder(
              future: culture(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Map<String, dynamic>> culture = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erreur de chargement, Veuillez ressaillez"),
                  );
                }
                int n = culture.length;
                final items = List<String>.generate(n, (i) => "Item $i");
                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(top: 25.0,),
                        elevation: 2.0,
                        child: ListTile(
                          title: Text('Culture: ${culture[index]["idtypeculture"]} \nSuperficie: ${culture[index]["superficie"]} metre carre'),
                          subtitle: Text('date de debut: ${culture[index]["debut"]} \nDate de fin prevu: ${culture[index]["fin"]} \nQuantite prevu: ${culture[index]["quantite"]} Kg'),
                        ),
                      );
                    }
                );
              }
          );
          //les agriculteurs
          final _Culture = Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width/3,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //widget
                      Container(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${snap[0]["image"]}')),
                        ),
                      ),
                      Divider(),
                      Container(
                        //color: Colors.indigo,
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Identifiant:  ${snap[0]["id"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "${snap[0]["nom"]} ${snap[0]["prenom"]}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Localite: ${snap[0]["localite"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Adresse: ${snap[0]["adresse"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            //alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Contacte: ${snap[0]["numero"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "date de naissance: ${snap[0]["date_naissance"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Sexe: ${snap[0]["genre"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Inscrit: ${snap[0]["date_creation"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Plantation: ${snap[0]["plantation"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Groupement: ${snap[0]["groupement"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Superficie: ${snap[0]["superficie"]} hectares",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),

                    ],
                  ),
                ),
              ),
              VerticalDivider(),//-------------------------------------------------
              Container(
                margin: EdgeInsets.only(left:50.0, right:50.0),
                //padding: EdgeInsets.only(left: 50, right: 50),
                width: MediaQuery.of(context).size.width/2,
                child: DefaultTabController(
                    length: 1,
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        bottom: TabBar(
                            unselectedLabelColor: Colors.indigo,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.indigo),
                            tabs: [
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(color: Colors.indigo, width: 1)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("MES CULTURE"),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      body: TabBarView(children: [
                        _culture,
                      ]),
                    )),
              ),
            ],
          );
          //Courbe de Repas
          Future<List<Map<String, dynamic>>> repas() async{
            print(snap[0]['idinscription']);
            List<Map<String, dynamic>> queryPerson = await DB.querySuiviRepas(snap[0]['id']);
            return queryPerson;
          }
          final _table_repas = FutureBuilder(
              future: repas(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Map<String, dynamic>> repas_reponse = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erreur de chargement, Veuillez ressaillez"),
                  );
                }
                int n = repas_reponse.length;
                print(repas_reponse);
                final items = List<String>.generate(n, (i) => "Item $i");
                return DataTable(
                  columns: [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Present')),
                    DataColumn(label: Text('Manger')),
                  ],
                  rows:
                  repas_reponse // Loops through dataColumnText, each iteration assigning the value to element
                      .map(
                    ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(element["date"])), //Extracting from Map element the value
                        DataCell(Text(element["present"] == "1" ? "✔": "✖")),
                        DataCell(Text(element["manger"] == "1" ? "✔": "✖")),
                      ],
                    )),
                  ).toList(),
                );
              }
          );
          final _repas = Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width/3,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //widget
                      Container(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${snap[0]["image"]}')),
                        ),
                      ),
                      Divider(),
                      Container(
                        //color: Colors.indigo,
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Identifiant:  ${snap[0]["id"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "${snap[0]["nom"]} ${snap[0]["prenom"]}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Localite: ${snap[0]["localite"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Adresse: ${snap[0]["adresse"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            //alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Contacte: ${snap[0]["numero"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "date de naissance: ${snap[0]["date_naissance"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Sexe: ${snap[0]["genre"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Inscrit: ${snap[0]["date_creation"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Classe: ${snap[0]["niveau"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Session: ${snap[0]["session"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(),//-------------------------------------------------
              Container(
                margin: EdgeInsets.all(50),
                width: MediaQuery.of(context).size.width/2,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //intro
                      Container(
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Emargement",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      _table_repas,
                    ],
                  ),
                ),
              ),
            ],
          );
          //Graphe d'evolution du pods de la femme enceinte
          Future<List<Map<String, dynamic>>> poids_femme() async{
            List<Map<String, dynamic>> queryPerson = await DB.queryPoidsFemme(snap[0]['idgrossesse'],snap[0]['status']);
            return queryPerson;
          }
          final _graphe_femme = FutureBuilder(
              future: poids_femme(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Map<String, dynamic>> poids_reponse = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erreur de chargement, Veuillez ressaillez"),
                  );
                }
                int n = poids_reponse.length;
                List<String> listTab = new List();
                List<List<String>> listTab2 = new List();
                poids_reponse.forEach((element) {element.forEach((key, val) => listTab.add(val));});
                listTab2.add(listTab);
                final items = List<String>.generate(n, (i) => "Item $i");
                // X value -> Y value
                const myData = [
                  ["date1", "10kg"],
                  ["date2", "20kg"],
                  //["date3", "30kg"],
                  //["date4", "40kg"],
                  //["date5", "50kg"],
                  //["date6", "60kg"],
                  //["date7", "70kg"],
                  //["date8", "80kg"],
                  //["date9", "90kg"],
                  //["date10", "100kg"],
                ];
                return Container(
                  height: 300.0,
                  child: LineChart(
                    lines: [
                      new Line<List<String>, String, String>(
                        data: listTab2,
                        xFn: (datum) => datum[0],
                        yFn: (datum) => datum[1],
                      ),
                    ],
                    chartPadding: new EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 30.0),
                  ),
                );
              }
          );
          //les info du graphics femme enceinte /*******************************
          final _grossesse = Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width/3,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //widget
                      Container(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${snap[0]["image"]}')),
                        ),
                      ),
                      Divider(),
                      Container(
                        //color: Colors.indigo,
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Identifiant:  ${snap[0]["id"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "${snap[0]["nom"]} ${snap[0]["prenom"]}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Localite: ${snap[0]["localite"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Adresse: ${snap[0]["adresse"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            //alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Contacte: ${snap[0]["numero"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "date de naissance: ${snap[0]["date_naissance"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Sexe: ${snap[0]["genre"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Inscrit: ${snap[0]["date_creation"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Date debut: ${snap[0]["datedebut"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(),//-------------------------------------------------
              Container(
                margin: EdgeInsets.all(50),
                width: MediaQuery.of(context).size.width/2,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //intro
                      Container(
                        margin: EdgeInsets.only(bottom: 30.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            //height: 50.0,
                            child: Text(
                              "Suivit etat de la femme enceinte",
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //chart
                      _graphe_femme,
                    ],
                  ),
                ),
              ),
            ],
          );
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement, Veuillez ressaillez"),
            );
          }
          if(snap.isNotEmpty){
            return snap[0]["categories"] == "agriculteur" ? _Culture : (snap[0]["fonction"] == "FE" ? _grossesse : _repas);
          } else {
            return Center(
              child: Card(
                child: Text("Information non disponible !"),
              ),
            );
          }
        }
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Mon profile"),
      ),
      body: Center(
        child: _user,
      ),
    );
  }
}
//*****************************horizontalle liste Listview on Alimentation
class HorizontalList2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var name;
    return Container(
        height: 120.0,
        child: Center(
            child: new Container(
              margin: EdgeInsets.only(left: 80.0, right: 80.0),
              padding: EdgeInsets.all(15.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  RaisedButton(
                    elevation: 0,
                    padding: EdgeInsets.all(0.0),
                    color: Colors.transparent,
                    disabledColor: Colors.transparent,
                    onPressed: (){
                      name = "Laitiers";
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                      );
                    },
                    child: Image.asset("images/laitier.png"),
                  ),
                  RaisedButton(
                    elevation: 0,
                    padding: EdgeInsets.all(0.0),
                    color: Colors.transparent,
                    disabledColor: Colors.transparent,
                    onPressed: (){
                      name = "Fruits";
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                      );
                    },
                    child: Image.asset("images/fruit.png"),
                  ),
                  RaisedButton(
                    elevation: 0,
                    padding: EdgeInsets.all(0.0),
                    color: Colors.transparent,
                    disabledColor: Colors.transparent,
                    onPressed: (){
                      name = "Fruits Secs";
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                      );
                    },
                    child: Image.asset("images/fruit_secs.png"),
                  ),
                  RaisedButton(
                    elevation: 0,
                    padding: EdgeInsets.all(0.0),
                    color: Colors.transparent,
                    disabledColor: Colors.transparent,
                    onPressed: (){
                      name = "Legumes";
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                      );
                    },
                    child: Image.asset("images/legume.png"),
                  ),
                  RaisedButton(
                    elevation: 0,
                    padding: EdgeInsets.all(0.0),
                    color: Colors.transparent,
                    disabledColor: Colors.transparent,
                    onPressed: (){
                      name = "Pain";
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                      );
                    },
                    child: Image.asset("images/pain.png"),
                  ),
                  RaisedButton(
                    elevation: 0,
                    padding: EdgeInsets.all(0.0),
                    color: Colors.transparent,
                    disabledColor: Colors.transparent,
                    onPressed: (){
                      name = "Viandes";
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SousCatAlimentation(),settings: RouteSettings(arguments: name),),
                      );
                    },
                    child: Image.asset("images/viande.png"),
                  ),
                ],
              ),
            )

        )

    );
  }
}
//--------------------------------------------------------------------------
/*
class Content2 extends StatelessWidget {
  final String image_location2;

  Content2({
    this.image_location2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Center(
          child: new Container(
            child: Image.asset(image_location2),
          )

      ),
    );
  }
}*/
//**********************************************Sous categories Alimentation
class SousCatAlimentation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final name = ModalRoute.of(context).settings.arguments;
    var idvideo;
    String lang = "Français";
    String categ = "Alimentation";
    //Selection de video de presentation agriculture dans la base de donner
    //***********************************************************************
    Future<List<Map<String, dynamic>>> MediaPresentation() async{
      var _parametre = await DB.initTabquery();
      if(_parametre[0]['langue'] != "" || _parametre[0]['langue'] != null) {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaScategAliment(categ,name,_parametre[0]['langue']);
        return queryRows;
      } else {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaScategAliment(categ,name,lang);
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
                  Center(
                    child: Container(
                      //margin: EdgeInsets.only(left: 50.0, right: 50.0),
                      child: Card(
                        elevation: 10,
                        child: NeekoPlayerWidget(
                          videoControllerWrapper: VideoControllerWrapper(
                              DataSource.file(
                                  File("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${snap[0]['media_file']}"))),
                          actions: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  print("share");
                                })
                          ],
                        ),
                      ),
                    ),
                  )
                ],
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
        child: _Sous_categories,
      ),
    );
  }
}

//*******************************horizontalle liste Listview on Eleve
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
//----------------------------------------------------------------------------
class Repas extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //
    final globalScaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: globalScaffoldKey,
      appBar: AppBar(
        title: Text("Repas"),
      ),
      body: RepasPannel(),
    );
  }
}

//***************************************horizontalle liste Listview on Santer
class CallProfileSante extends StatelessWidget {
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

    return Container(
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
    );
  }
}
//----------------------------------------------------------------------------------
