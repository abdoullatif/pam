import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam/database/database_online.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/model/user_data_online.dart';


class CommandeEnvoyer extends StatelessWidget {
  const CommandeEnvoyer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("COMMANDE RECENT"),
      ),
      body: CommandeEnvoyerPannel(),
    );
  }
}

class CommandeEnvoyerPannel extends StatefulWidget {
  const CommandeEnvoyerPannel({Key key}) : super(key: key);

  @override
  _CommandeEnvoyerPannelState createState() => _CommandeEnvoyerPannelState();
}

class _CommandeEnvoyerPannelState extends State<CommandeEnvoyerPannel> {

  //share prefs
  //var idpersonne = StorageUtil.getString("idpersonne");

  @override
  Widget build(BuildContext context) {
    //var navigate
    int idpersonne_nav = ModalRoute.of(context).settings.arguments;
    return FutureBuilder(
        future: DbOnline.getCommandeEnvoyer(UserData.id.toString()),
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
          //Data
          var historique = snapshot.data;
          print(historique);
          //Return composant
          return Center(
            child: Container(
              height: 800.0, // Change as per your requirement
              width: 800.0, // Change as per your requirement
              child: RefreshIndicator(
                onRefresh: (){
                  setState(() {});
                  return Future.delayed(
                    Duration(seconds: 0),
                  );
                },
                child: ListView(
                  shrinkWrap: true,
                  //itemCount: itemsM.length,
                  children: [
                    for(var row in historique)
                      Card(
                          elevation: 5.0,
                          child: TextButton(
                            onPressed: () async {
                              //Annuler la commande //Show alerte
                              var reponse = await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "COMMANDE",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    content: Text("Voulez vous annuler la commande ou comfirmer la livraison ? \n "
                                        "NB: Vous pouvez comfirmer la livraison seulement si la commande est accepter par le commercant et vous avez recu la livraison"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('ANNULER LA COMMANDE',style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop('annuler');
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('COMFIRMER LA LIVRAISON',style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop('oui');
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('QUITTER'),
                                        onPressed: () {
                                          Navigator.of(context).pop('non');
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              print(reponse);
                              if(reponse == "annuler"){
                                DbOnline.delectCommande(row['id_cmd']);
                                setState(() {
                                  Fluttertoast.showToast(
                                      msg: "Commande annuler !",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                });
                              } else if(reponse == "oui"){
                                if(row['statuts'] == "ok") {
                                  //Commande livree
                                  DbOnline.updateCommande(row['id_cmd']);
                                  setState(() {
                                    Fluttertoast.showToast(
                                        msg: "Commande livrée avec succès !",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  });
                                } else if (row['statuts'] == "rejected") {
                                  Fluttertoast.showToast(
                                      msg: "La commande a été rejéter par le commercant !",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "La commande est en attente de comfirmation par le commercant !",
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
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.transparent,
                                backgroundImage: row['image'].toString().contains("\\") ?
                                NetworkImage('https://pamgnsupport.com/uploads/${row['image'].toString().substring(1)}') :
                                NetworkImage('https://pamgnsupport.com/uploads/${row['image'].toString()}'),
                                //backgroundImage: Image.file(file),
                              ),
                              title: Text('${row['designation']}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),),
                              subtitle: Text('Commercant : ${row['name']} ${row['prenom']}  telephone : ${row['contacte']}\n'
                                  'Prix Unitaire : ${row['pu']} GNF   Prix Total : ${row['pt']} GNF \n'
                                  'Quantite: ${row['quantite']}\n'
                                  'Date de commande : ${row['date_commande']}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),), //
                              trailing: row['statuts'] == "0" ?
                              Text('EN ATTENTE') : row['statuts'] == "ok" ?
                              Text('ACCEPTER',style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),) : row['statuts'] == "rejected" ?
                              Text('REJETER',style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),) : Text('${row['statuts']}'),
                            ),
                          )
                      )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}

