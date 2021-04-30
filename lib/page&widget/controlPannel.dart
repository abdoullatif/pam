import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam/database/database.dart';


class ControlPannel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () async{
              //Dialog
              var confirm = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("ATTENTION"),
                    content: Text(
                      'Voulez-vous vraiment videz toutes la base de donnee de la tablette ?', style: TextStyle(color: Colors.red,),),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('NON'),
                        onPressed: () {
                          Navigator.of(context).pop('non');
                        },
                      ),
                      FlatButton(
                        child: Text('OUI'),
                        onPressed: () {
                          Navigator.of(context).pop('oui');
                        },
                      ),
                    ],
                    //shape: CircleBorder(),
                  );
                },
              );
              //Verif
              if(confirm == "oui"){
                //Troncate sql database
                DB.troncatTable("langue"); // table
                DB.troncatTable("annee_scolaire"); // table
                DB.troncatTable("campagne_agricol"); // table
                DB.troncatTable("personne"); // table
                DB.troncatTable("personne_adresse"); // table
                DB.troncatTable("personne_tel"); // table
                DB.troncatTable("personne_fonction"); // table
                DB.troncatTable("localite"); // table
                DB.troncatTable("codification"); // table
                DB.troncatTable("inscription"); // table
                DB.troncatTable("classe"); // table
                DB.troncatTable("ecole"); // table
                DB.troncatTable("suivit_repas"); // table
                DB.troncatTable("suivit_poids_eleve"); // table
                DB.troncatTable("detail_bon"); // table
                DB.troncatTable("bon"); // table
                DB.troncatTable("detenteur_plantation"); // table
                DB.troncatTable("plantation"); // table
                DB.troncatTable("detenteur_culture"); // table
                DB.troncatTable("vente"); // table
                DB.troncatTable("grossesse"); // table
                DB.troncatTable("suivit_grossesse"); // table
                DB.troncatTable("quiz_eleve"); // table
                DB.troncatTable("quiz_femmeEnceinte"); // table
                DB.troncatTable("media"); // table
                DB.troncatTable("categories"); // table
                DB.troncatTable("sous_categories"); // table
                DB.troncatTable("fichier_audio"); // table
                //Message
                Fluttertoast.showToast(
                    msg: "La base de donnee a ete vider avec succes !", //Présence enregistrée,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                //
              }

            },
            child: Icon(Icons.delete_rounded, color: Colors.white,),
          )
        ],
      ),
      body: SaveIdTab(),
    );
  }
}
////////////////////////////////////////////////////////////////////////

class SaveIdTab extends StatefulWidget {
  @override
  _SaveIdTabState createState() => _SaveIdTabState();
}

class _SaveIdTabState extends State<SaveIdTab> {
  //-----------------------------------------------------------------------------------
  //variable
  final _formKey = GlobalKey<FormState>();

  //TextEditingController _locate = TextEditingController();
  TextEditingController _device = TextEditingController();
  TextEditingController _adresse_server = TextEditingController();
  TextEditingController _ip_server = TextEditingController();
  TextEditingController _site_commercant = TextEditingController();
  TextEditingController _site_pam = TextEditingController();
  TextEditingController _user = TextEditingController();
  TextEditingController _mdp = TextEditingController();
  TextEditingController _dbname = TextEditingController();
  //-------------------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 100.0, right: 100.0, top: 30, bottom: 30.0,),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              //color: Colors.indigo,
                margin: EdgeInsets.only(bottom: 30.0),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 30.0,
                    child: Text("Panneau de configuration", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),),
                  ),
                )
            ),
            TextFormField(
              obscureText: false,
              controller: _device,
              decoration: InputDecoration(
                icon: Icon(Icons.tablet, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Identifiant de la tablette",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  print(value);
                  return 'Veuiller entrer le nom de la tablette';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            //_Localites,
            //SizedBox(height: 25.0),
            /*
            TextFormField(
              obscureText: false,
              controller: _locate,
              decoration: InputDecoration(
                icon: Icon(Icons.add_location, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "localite manuel",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le nom de la localite';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            */
            TextFormField(
              obscureText: false,
              controller: _adresse_server,
              decoration: InputDecoration(
                icon: Icon(Icons.vpn_lock, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Adresse DNS du server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer l\'Adresse DNS du server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _dbname,
              decoration: InputDecoration(
                icon: Icon(Icons.vpn_lock, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Nom de la base de donnee",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer l\'Adresse DNS du server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _ip_server,
              decoration: InputDecoration(
                icon: Icon(Icons.settings, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Adresse ip du server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer l\'Adresse ip du server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _site_commercant,
              decoration: InputDecoration(
                icon: Icon(Icons.web, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Site web pour effectuer des commandes (commercant)",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le Site web pour effectuer des commandes (commercant)';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _site_pam,
              decoration: InputDecoration(
                icon: Icon(Icons.web, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Site web officiel du pam",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le nom de la tablette';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _user,
              decoration: InputDecoration(
                icon: Icon(Icons.edit, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Nom utlilisateur server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le Nom utlilisateur server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _mdp,
              decoration: InputDecoration(
                icon: Icon(Icons.security, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Mot de passe Utilisateur-server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le Mot de passe Utilisateur-server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/2.1,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xff01A0C7),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () async{
                        if (true) {
                          //Verification
                          List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
                          if(tab.isNotEmpty){
                            //On modifie les informations present
                            await DB.update("parametre", {
                              "device": _device.text,
                              "adresse_server": _adresse_server.text,
                              "dbname": _dbname.text,
                              "ip_server": _ip_server.text,
                              "site_commercant": _site_commercant.text,
                              "site_pam": _site_pam.text,
                              "user": _user.text,
                              "mdp": _mdp.text,
                            },tab[0]['id']);
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Modification effectuer avec succes !')));
                          } else {
                            // insertion du nom de la tablette
                            await DB.insert("parametre", {
                              "device": _device.text,
                              "adresse_server": _adresse_server.text,
                              "dbname": _dbname.text,
                              "ip_server": _ip_server.text,
                              "site_commercant": _site_commercant.text,
                              "site_pam": _site_pam.text,
                              "langue": "Français",
                              "user": _user.text,
                              "mdp": _mdp.text,
                            });
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Enregistrement effectuer avec succes !')));
                          }
                        }
                      },
                      child: Text("Enregistrer", textAlign: TextAlign.center,),
                    ),
                  ),
                ),
                VerticalDivider(),
                Container(
                  width: MediaQuery.of(context).size.width/3,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xff01A0C7),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () async{
                        List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
                        if(tab.isNotEmpty){
                          setState(() {
                            //_locate = TextEditingController(text: tab[0]['locate']);
                            _device = TextEditingController(text: tab[0]['device']);
                            _adresse_server = TextEditingController(text: tab[0]['adresse_server']);
                            _dbname = TextEditingController(text: tab[0]['dbname']);
                            _ip_server = TextEditingController(text: tab[0]['ip_server']);
                            _site_commercant = TextEditingController(text: tab[0]['site_commercant']);
                            _site_pam = TextEditingController(text: tab[0]['site_pam']);
                            _user = TextEditingController(text: tab[0]['user']);
                            _mdp = TextEditingController(text: tab[0]['mdp']);
                          });
                        }
                      },
                      child: Text("Voir les info", textAlign: TextAlign.center,),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 35.0),
          ],
        ),
      ),
    );
  }
}