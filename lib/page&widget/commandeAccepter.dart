import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam/database/database_online.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/model/user_data_online.dart';


class CommandeAccepter extends StatelessWidget {
  const CommandeAccepter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("COMMANDE ACCEPTER"),
      ),
      body: CommandeAccepterPannel(),
    );
  }
}

class CommandeAccepterPannel extends StatefulWidget {
  const CommandeAccepterPannel({Key key}) : super(key: key);

  @override
  _CommandeAccepterPannelState createState() => _CommandeAccepterPannelState();
}

class _CommandeAccepterPannelState extends State<CommandeAccepterPannel> {

  //share prefs
  //var idpersonne = StorageUtil.getString("idpersonne");

  @override
  Widget build(BuildContext context) {
    //var navigate
    int idpersonne_nav = ModalRoute.of(context).settings.arguments;
    return FutureBuilder(
        future: DbOnline.getCommandeAccepter(UserData.id.toString()),
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
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "COMMANDE RECU",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  content: Text("Avez-vous recu la commande ?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('OUI J\'AI RECU'),
                                      onPressed: () {
                                        Navigator.of(context).pop('oui');
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('NON'),
                                      onPressed: () {
                                        Navigator.of(context).pop('non');
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            print(reponse);
                            if(reponse == "oui"){
                              //Commande recu
                              DbOnline.updateCommande(row['id_cmd']);
                              setState(() {
                                Fluttertoast.showToast(
                                    msg: "Commande livree avec succes !",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              });
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
                                'Date de commande : ${row['date_commande']}',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),), //
                            trailing: Text('${row['quantite']}'),
                          ),
                        )
                    )
                ],
              ),
            ),
          );
        }
    );
  }
}

