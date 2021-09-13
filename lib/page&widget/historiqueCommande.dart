import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam/database/database_online.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/model/user_data_online.dart';


class HistoriqueCommande extends StatelessWidget {
  const HistoriqueCommande({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Historique des commande"),
      ),
      body: HistoriquePannel(),
    );
  }
}

class HistoriquePannel extends StatefulWidget {
  const HistoriquePannel({Key key}) : super(key: key);

  @override
  _HistoriquePannelState createState() => _HistoriquePannelState();
}

class _HistoriquePannelState extends State<HistoriquePannel> {

  //share prefs
  //var idpersonne = StorageUtil.getString("idpersonne");

  @override
  Widget build(BuildContext context) {
    //var navigate
    int idpersonne_nav = ModalRoute.of(context).settings.arguments;
    return FutureBuilder(
        future: DbOnline.getHistorique(UserData.id.toString()),
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
                            onPressed: null,
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
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),),
                              subtitle: Text('Prix Unitaire : ${row['pu']} GNF   Prix Total : ${row['pt']} GNF \n'
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
                              ),) : row['statuts'] == "livree" ?
                              Text('LIVREE',style: TextStyle(
                                color: Colors.green,
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

