import 'package:flutter/material.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';


class Vente extends StatefulWidget {
  @override
  _VenteState createState() => _VenteState();
}

class _VenteState extends State<Vente> {
  final List<Map<String, String>> listOfColumns = [
    {"Date": "AAAAAA", "Agriculteur": "1", "Prix Achat": "Yes", "Quantite Acheter": "Yes"},
    {"Date": "BBBBBB", "Agriculteur": "2", "Prix Achat": "no", "Quantite Acheter": "Yes"},
    {"Date": "CCCCCC", "Agriculteur": "3", "Prix Achat": "Yes", "Quantite Acheter": "Yes"}
  ];
  @override
  Widget build(BuildContext context) {
    // var
    var idpersonne = '';
    var nom = '';
    var prenom = '';
    var date_naissance = '';
    var idgenre = '';
    var date_creation = '';
    var iud = '';
    var email = '';
    var mdp = '';
    var image = '';
    var idadresse = '';
    var idlocalite = '';
    var adresse = '';
    var idpersonne_fonction = '';
    var idtypefonction = '';
    var idecole = '';
    var ecole = '';
    //asynchrone
    idpersonne = StorageUtil.getString("idpersonne");
    nom = StorageUtil.getString("nom");
    prenom = StorageUtil.getString("prenom");
    date_naissance = StorageUtil.getString("date_naissance");
    idgenre = StorageUtil.getString("idgenre");
    date_creation = StorageUtil.getString("date_creation");
    iud = StorageUtil.getString("iud");
    email = StorageUtil.getString("email");
    mdp = StorageUtil.getString("mdp");
    image = StorageUtil.getString("image");
    idlocalite = StorageUtil.getString("idlocalite");
    adresse = StorageUtil.getString("adresse");
    idpersonne_fonction = StorageUtil.getString("idpersonne_fonction");
    idtypefonction = StorageUtil.getString("idtypefonction");
    idecole = StorageUtil.getString("idecole");
    ecole = StorageUtil.getString("ecole");
    //Future builder
    Future<List<Map<String, dynamic>>> historique_vente() async{
      List<Map<String, dynamic>> queryRows = await DB.queryVente(idpersonne);
      return queryRows;
    }
    final _vente = FutureBuilder(
        future: historique_vente(),
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
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Date', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                    DataColumn(label: Text('Agriculteur', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                    DataColumn(label: Text('Prix Achat', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                    DataColumn(label: Text('Culture', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                    DataColumn(label: Text('Quantité Achetée', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                    DataColumn(label: Text('Code du Réçu', style: TextStyle(fontSize: 20.0,color: Colors.indigo),)),
                  ],
                  rows:
                  snap // Loops through dataColumnText, each iteration assigning the value to element
                      .map(
                    ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(element["Date"], style: TextStyle(fontSize: 16.0),)), //Extracting from Map element the value
                        DataCell(Text(element["Agriculteur"], style: TextStyle(fontSize: 16.0),)),
                        DataCell(Text(element["Prix"], style: TextStyle(fontSize: 16.0),)),
                        DataCell(Text(element["Culture"], style: TextStyle(fontSize: 16.0),)),
                        DataCell(Text(element["Quantite"]+" Kg", style: TextStyle(fontSize: 16.0),)),
                        DataCell(Text(element["Code_recu"], style: TextStyle(fontSize: 16.0),)),
                      ],
                    )),
                  )
                      .toList(),
                ),
              ),
            ),
          );
        }
    );
    return Scaffold(
      appBar: AppBar(
          title: Text("Historique d'achat Agriculteur")
      ),
      body: _vente,
    );
  }
}