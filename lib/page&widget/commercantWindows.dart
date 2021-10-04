import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/database_online.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/model/user_data_online.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart' show DateFormat;

import 'commandeAccepter.dart';
import 'commandeEnvoyer.dart';
import 'historiqueCommande.dart';




class produitsCommercant extends StatelessWidget {
  const produitsCommercant({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //Share pref
    //var idpersonne = StorageUtil.getString("idpersonne");

    return Scaffold(
      appBar: AppBar(
        title: Text("Commander un produit"),
          actions: <Widget> [
            FlatButton(
              onPressed: (){
                //Navigation push
                Navigator.push(context, MaterialPageRoute(builder: (context) => CommandeEnvoyer(),settings: RouteSettings(arguments: UserData.id)),);
              },
              child: Text("COMMANDE RECENT", style: TextStyle(color: Colors.white,),),
              color: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            SizedBox(width: 30.0,),
            /*
            FlatButton(
              onPressed: (){
                //Navigation push
                Navigator.push(context, MaterialPageRoute(builder: (context) => CommandeAccepter(),settings: RouteSettings(arguments: UserData.id)),);
              },
              child: Text("COMMANDE ACCEPTER", style: TextStyle(color: Colors.white,),),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            SizedBox(width: 30.0,),
            */
            FlatButton(
              onPressed: (){
                //Navigation push
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoriqueCommande(),settings: RouteSettings(arguments: UserData.id)),);
              },
              child: Text("HISTORIQUE COMMANDE", style: TextStyle(color: Colors.white,),),
              color: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            SizedBox(width: 10.0,),
          ]
      ),
      body: produitsCommercantPannel(),
    );

  }
}


class produitsCommercantPannel extends StatefulWidget {
  const produitsCommercantPannel({Key key}) : super(key: key);

  @override
  _produitsCommercantPannelState createState() => _produitsCommercantPannelState();
}

class _produitsCommercantPannelState extends State<produitsCommercantPannel> {

  //var form
  final _formKey = GlobalKey<FormState>();

  //Share pref
  //var idpersonne = StorageUtil.getString("idpersonne");
  var idlocalite_pref = StorageUtil.getString("idlocalite");
  var email = StorageUtil.getString("email");

  //Connection
  bool connection = false;

  //Variable
  int _counter = 0;

  //Produits
  String idproduit = "";
  String designation = "";
  String pu = "";
  String image = "";
  int idlocalite = 1;

  int total = 0;

  //Date
  var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  //TextEditingController
  TextEditingController _quantite = TextEditingController();
  TextEditingController _prixU = TextEditingController();

  //Methode
  void _incrementCounter() {
    setState(() {
      _counter++;
      total = int.tryParse(_prixU.text) * _counter;
    });
  }
  //
  void _decrementCounter() {
    setState(() {
      if(_counter == 0){
        //nothing rien
      } else {
        _counter--;
        total = int.tryParse(_prixU.text) * _counter;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    //Insert in textEditing
    _quantite = TextEditingController()..text = _counter.toString();

    return FutureBuilder(
        future: DbOnline.con(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Un probleme est survenue, Veuillez vous connecter a internet ou verifier votre connection internet"),
            );
          }

          return FutureBuilder(
              future: DbOnline.getUser(email),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Un probleme est survenue !"),
                  );
                }
                //Data
                var user = snapshot.data;

                if(snapshot.hasData){
                  //Save info
                  for(var row in user){
                    UserData.id = row['id'] ?? 0;
                    UserData.name = row['name'] ?? "";
                    UserData.prenom = row['prenom'] ?? "";
                    UserData.privilege = row['privilege'] ?? "";
                    UserData.email_usr_pm = row['email_usr_pm'] ?? "";
                    UserData.localite = row['localite'] ?? "";
                    UserData.contacte = row['contacte'] ?? "";
                    UserData.mdp_usr_pm = row['mdp_usr_pm'] ?? "";
                  }

                  //Return composant
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                        children: [
                          SizedBox(width: 25,),
                          /*
                          FutureBuilder(
                              future: DbOnline.con(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text("Un probleme est survenue, Veuillez vous connecter a internet ou verifier votre connection internet"),
                                  );
                                }
                                //Return composant
                                return Container();
                              }
                          ),
                          */
                          Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 3,
                            child: Card(
                              elevation: 5,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: 5,),
                                    Text(
                                      'Detail du Produit',
                                      style: TextStyle(color: Colors.black, fontSize: 20),
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                      crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                      children: [
                                        Text(
                                          'Prix unitaire : ',
                                          style: TextStyle(color: Colors.black, fontSize: 20),
                                        ),
                                        Container(
                                          width: 180.0,
                                          child: TextFormField(
                                            obscureText: false,
                                            controller: _prixU,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            autofocus: false,
                                            onChanged: (number) {
                                              setState(() {
                                                if(number == "") number = "0";
                                                //_counter = int.tryParse(number);
                                                //_prixU = TextEditingController()..text = number;
                                                total = _counter * int.tryParse(number);
                                              });
                                            },
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              height: 2.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText: "Montant",
                                              hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
                                            ),
                                            validator: (value) {
                                              String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                                              RegExp regExp = new RegExp(pattern);
                                              if (value.length == 0) {
                                                return 'Veuillez entrer une information';
                                              }
                                              else if (value.isEmpty) {
                                                return 'Veuillez entrer une information';
                                              }
                                              else if (!regExp.hasMatch(value)) {
                                                return 'Veuillez entrer un numbre';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Text(
                                          ' GNF',
                                          style: TextStyle(color: Colors.black, fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    SizedBox(
                                      width: 280,
                                      height: 280,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: CircleAvatar(
                                          radius: 80,
                                          backgroundImage: image != "" ? NetworkImage('$image') : null,
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Text(
                                      '$designation',
                                      style: TextStyle(color: Colors.black, fontSize: 20),
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                      crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                      children: [
                                        TextButton(
                                            onPressed: _decrementCounter,
                                            child: const Icon(Icons.remove,size: 24.0,)
                                        ),
                                        Container(
                                          width: 200.0,
                                          child: TextFormField(
                                            obscureText: false,
                                            controller: _quantite,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            autofocus: false,
                                            onChanged: (number) {
                                              setState(() {
                                                if(number == "") number = "0";
                                                _counter = int.tryParse(number);
                                                total = int.tryParse(number) * int.tryParse(_prixU.text);
                                              });
                                            },
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              height: 2.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText: "Quantite",
                                              hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
                                            ),
                                            validator: (value) {
                                              String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                                              RegExp regExp = new RegExp(pattern);
                                              if (value.length == 0) {
                                                return 'Veuillez entrer une information';
                                              }
                                              else if (value.isEmpty) {
                                                return 'Veuillez entrer une information';
                                              }
                                              else if (!regExp.hasMatch(value)) {
                                                return 'Veuillez entrer un numbre';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: _incrementCounter,
                                            child: const Icon(Icons.add,size: 24.0,)
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Text(
                                      'Prix totale : $total GNF',
                                      style: TextStyle(color: Colors.black, fontSize: 24),
                                    ),
                                    Divider(),
                                    SizedBox(height: 0.0,),
                                    TextButton(
                                      onPressed: () async{

                                        if(_formKey.currentState.validate()){

                                          if(idlocalite_pref != "" || idlocalite_pref != null){
                                            //get id localite
                                            var _locate = await DB.queryWherelocate("localite",idlocalite_pref);
                                            idlocalite = _locate[0]["id"];
                                            //Show alerte
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Align(
                                                    alignment: Alignment.center,
                                                    child: SizedBox(
                                                      //height: 50.0,
                                                      child: Text(
                                                        "COMMERCANT",
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  content: setupAlertDialoadContainer(context, idproduit),
                                                );

                                              },
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Pas connecter !",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 5,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          }

                                        }

                                      },
                                      child: Text("Valider"),
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                                          side: MaterialStateProperty.all(
                                              BorderSide(width: 1, color: Colors.blue)),
                                          foregroundColor: MaterialStateProperty.all(Colors.white),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(vertical: 5, horizontal: 40)),
                                          textStyle:
                                          MaterialStateProperty.all(TextStyle(fontSize: 24))
                                      ),
                                    ),
                                    SizedBox(height: 10.0,),
                                  ],
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.transparent, spreadRadius: 5),
                              ],
                            ),
                            //height: 50,
                          ),
                          SizedBox(width: 5,),
                          FutureBuilder(
                              future: DbOnline.getProduit(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text("Un probleme est survenue, Veuillez vous connecter a internet ou verifier votre connection internet"),
                                  );
                                }
                                //Variable get data
                                var produits = snapshot.data;
                                //print(produits);
                                //Return composant
                                return Container(
                                  margin: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width / 1.7,
                                  child: Card(
                                    elevation: 5,
                                    child: RefreshIndicator(
                                      onRefresh: (){
                                        setState(() {});
                                        return Future.delayed(
                                          Duration(seconds: 0),
                                        );
                                      },
                                      child: GridView.count(
                                          shrinkWrap: true,
                                          crossAxisCount: 3,
                                          //mainAxisSpacing: 40.0,
                                          crossAxisSpacing: 50.0,
                                          //physics: NeverScrollableScrollPhysics(),
                                          children: [
                                            for(var row in produits)
                                              Center(
                                                child: RaisedButton(
                                                    elevation: 0,
                                                    padding: EdgeInsets.all(0.0),
                                                    color: Colors.transparent,
                                                    disabledColor: Colors.transparent,
                                                    onPressed: (){
                                                      //Inserstion des donnees dans les variables
                                                      setState(() {
                                                        //print(row['image'].toString().contains("\\"));
                                                        _prixU = TextEditingController()..text = row['pu'];
                                                        _counter = 0;
                                                        total = 0;
                                                        image = row['image'].toString().contains("\\") ?
                                                        'https://pamgnsupport.com/uploads/${row['image'].toString().substring(1)}' :
                                                        'https://pamgnsupport.com/uploads/${row['image'].toString()}';
                                                        idproduit = row['idproduit'];
                                                        pu = row['pu'];
                                                        designation = row['designation'];
                                                      });
                                                    },
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 130,
                                                          width: 130,
                                                          child: Container(
                                                            padding: EdgeInsets.all(10),
                                                            child: CircleAvatar(
                                                              radius: 80,
                                                              backgroundImage: row['image'].toString().contains("\\") ?
                                                              NetworkImage('https://pamgnsupport.com/uploads/${row['image'].toString().substring(1)}') :
                                                              NetworkImage('https://pamgnsupport.com/uploads/${row['image'].toString()}'),
                                                            ),
                                                          ),
                                                        ),

                                                        Divider(),
                                                        Text(
                                                          '${row['designation']}',
                                                          style: TextStyle(color: Colors.black),
                                                        ),
                                                      ],
                                                    )
                                                ),
                                              )
                                          ]
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(color: Colors.transparent, spreadRadius: 5),
                                    ],
                                  ),
                                  //height: 50,
                                );
                              }
                          ),

                        ],
                      ),
                    ),
                  );

                }

                return Center(
                  child: Text("Vous n'est pas Autoriser !"),
                );


              }
          );

        }
    );

  }

  Widget setupAlertDialoadContainer(context, idproduit) {
    //Date init
    var date = dates.toString();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white,
          height: 400.0, // Change as per your requirement
          width: 300.0, // Change as per your requirement
          child: FutureBuilder(
            future: DbOnline.getCommercant(idlocalite,idproduit),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var commercant = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Erreur de chargement, Veuillez ressaiyez"),
                );
              }

              return Container(
                height: 300.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: ListView(
                  shrinkWrap: true,
                  //itemCount: itemsM.length,
                  children: [
                    for(var row in commercant)
                      Card(
                        elevation: 5.0,
                        child: TextButton(
                          onPressed: (){
                            print("commercant");
                            //Lancement de la commande
                            //If quantite saissi
                            if(_counter != 0){
                              //Insertion dans la bd

                              DbOnline.setcommande(idproduit,_counter,_prixU.text,total,UserData.id.toString(),date,"0",row['id']);

                              //Navigation Pop
                              Navigator.of(context).pop();

                              Fluttertoast.showToast(
                                  msg: "Commande effectuer",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Quantite non valide",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }

                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.transparent,
                              backgroundImage: AssetImage("images/small-logo.png"),
                              //backgroundImage: Image.file(file),
                            ),
                            title: Text('${row['name']} ${row['prenom']}'),
                            subtitle: Text('commercant'), //${row['localite']}
                            trailing: Text('${row['quantite']}'),
                          ),
                        )
                      )
                  ],
                ),
              );

            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(
            onPressed: (){
              Navigator.pop(context);
            },child: Text("Quitter"),),
        )
      ],
    );
  }


}


























































































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

    //Key and encrypt
    final key = encrypt.Key.fromUtf8('Tulip_Ind*SuperCleSecreteBySooba');
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

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

            final site_commercant_decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(snap[0]['site_commercant']), iv: iv);

            return WebView(
              initialUrl: '$site_commercant_decrypted',
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