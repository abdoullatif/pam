
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam/database/database.dart';
import 'package:encrypt/encrypt.dart' as myencrypt;



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
                      'Voulez-vous vraiment videz la base de donnee de la tablette ?', style: TextStyle(color: Colors.red,),),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('NON'),
                        onPressed: () {
                          Navigator.of(context).pop('non');
                        },
                      ),
                      FlatButton(
                        child: Text('Supprimer Les Donnees (Excepter les media)'),
                        onPressed: () {
                          Navigator.of(context).pop('oui');
                        },
                      ),
                      FlatButton(
                        child: Text('Supprimer toutes les Donnees + video (all)'),
                        onPressed: (){
                          Navigator.of(context).pop('all');
                        },
                      ),
                    ],
                    //shape: CircleBorder(),
                  );
                },
              );
              //Verif en fonction des data
              if(confirm == "oui"){
                //Troncate sql database exept media, categories, sous-categories

                //Delecte all picture in database

                List<Map<String, dynamic>> queryPersonne = await DB.queryAll("personne");

                if(queryPersonne.isNotEmpty){
                  for (int i = 0; i < queryPersonne.length; i++){
                    File picture = File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${queryPersonne[i]["image"]}');
                    await picture.delete();
                  }
                }

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
                DB.troncatTable("enfant"); // table
                DB.troncatTable("suivit_enfant"); // table
                DB.troncatTable("suivit_grossesse"); // table
                DB.troncatTable("quiz_eleve"); // table
                DB.troncatTable("quiz_femmeEnceinte"); // table
                //DB.troncatTable("media"); // table
                //DB.troncatTable("categories"); // table
                //DB.troncatTable("sous_categories"); // table
                DB.troncatTable("fichier_audio"); // table
                print("Fait!");
                //Message
                Fluttertoast.showToast(
                    msg: "Les données ont été vider avec succès !",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );

              } else if(confirm == "all"){
                //Supprimer les fichier

                //Delecte all picture in database

                List<Map<String, dynamic>> queryPersonne = await DB.queryAll("personne");

                if(queryPersonne.isNotEmpty){
                  for (int i = 0; i < queryPersonne.length; i++){
                    File picture = File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${queryPersonne[i]["image"]}');
                    await picture.delete();
                  }
                }

                //Delecte all media in database

                List<Map<String, dynamic>> queryMedia = await DB.queryAll("media");

                if(queryMedia.isNotEmpty){
                  for (int i = 0; i < queryMedia.length; i++){
                    File media = File("/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/${queryMedia[i]['media_file']}");
                    await media.delete();
                  }
                }

                //Vider toute la base de donnee
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
                DB.troncatTable("enfant"); // table
                DB.troncatTable("suivit_enfant"); // table
                DB.troncatTable("suivit_grossesse"); // table
                DB.troncatTable("quiz_eleve"); // table
                DB.troncatTable("quiz_femmeEnceinte"); // table
                DB.troncatTable("media"); // table
                DB.troncatTable("categories"); // table
                DB.troncatTable("sous_categories"); // table
                DB.troncatTable("fichier_audio"); // table
                print("Fait!");
                //Message
                Fluttertoast.showToast(
                    msg: "La base de donnée a été vider avec succès !",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
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

  //variable
  final _formKey = GlobalKey<FormState>();

  //-----------------------------------------------------------------------------------
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
  Widget build(BuildContext context) {
    //print(Param.mdp);

    //Encrypt Scripting
    final key = myencrypt.Key.fromUtf8('Tulip_Ind*SuperCleSecreteBySooba');
    final iv = myencrypt.IV.fromLength(16);

    final encrypter = myencrypt.Encrypter(myencrypt.AES(key));
    //Encrypt _encrypt

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
                if (_device.text.isEmpty) {
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
                if (_adresse_server.text.isEmpty) {
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
                if (_dbname.text.isEmpty) {
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
                if (_ip_server.text.isEmpty) {
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
                if (_site_commercant.text.isEmpty) {
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
                if (_site_pam.text.isEmpty) {
                  return 'Veuiller entrer l\'adresse url du site du pam ';
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
                if (_user.text.isEmpty) {
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
                if (_mdp.text.isEmpty) {
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

                        if (_formKey.currentState.validate()) {

                          //Cryptage des info parametre
                          final device_encrypt = encrypter.encrypt(_device.text, iv: iv); //_device.text.isNotEmpty ?  : "";
                          final adresse_server_encrypt = encrypter.encrypt(_adresse_server.text, iv: iv); //_adresse_server.text.isNotEmpty ?  : "";
                          final dbname_encrypt = encrypter.encrypt(_dbname.text, iv: iv); //_dbname.text.isNotEmpty ?  : "";
                          final ip_server_encrypt = encrypter.encrypt(_ip_server.text, iv: iv);
                          final site_commercant_encrypt = encrypter.encrypt(_site_commercant.text, iv: iv); //_site_commercant.text.isNotEmpty ?  : "";
                          final site_pam_encrypt = encrypter.encrypt(_site_pam.text, iv: iv); //_site_pam.text.isNotEmpty ?  : "";
                          final user_encrypt = encrypter.encrypt(_user.text, iv: iv); //_user.text.isNotEmpty ?  : "";
                          final mdp_encrypt = encrypter.encrypt(_mdp.text, iv: iv); //_mdp.text.isNotEmpty ?  : "";

                          //print(value);
                          //print(site_commercant_encrypt.base64);

                          //Verification
                          List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
                          if(tab.isNotEmpty){
                            //On modifie les informations present
                            await DB.update("parametre", {
                              "device": device_encrypt.base64, //_device.text
                              "adresse_server": adresse_server_encrypt.base64, //_adresse_server.text
                              "dbname": dbname_encrypt.base64, //_dbname.text
                              "ip_server": ip_server_encrypt.base64, //_ip_server.text
                              "site_commercant": site_commercant_encrypt.base64, //_site_commercant.text
                              "site_pam": site_pam_encrypt.base64, //_site_pam.text
                              "user": user_encrypt.base64, // _user.text,
                              "mdp": mdp_encrypt.base64, //_mdp.text
                            },tab[0]['id']);
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Modification effectuer avec succes !')));
                          } else {
                            // insertion du nom de la tablette
                            await DB.insert("parametre", {
                              "device": device_encrypt.base64,
                              "adresse_server": adresse_server_encrypt.base64,
                              "dbname": dbname_encrypt.base64,
                              "ip_server": ip_server_encrypt.base64,
                              "site_commercant": site_commercant_encrypt.base64,
                              "site_pam": site_pam_encrypt.base64,
                              "langue": "Français",
                              "user": user_encrypt.base64,
                              "mdp": mdp_encrypt.base64,
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

                          //Decryptage
                          final device_decrypted = encrypter.decrypt(myencrypt.Encrypted.fromBase64(tab[0]['device']), iv: iv);
                          final adresse_server_decrypted = encrypter.decrypt(myencrypt.Encrypted.fromBase64(tab[0]['adresse_server']), iv: iv);
                          final dbname_decrypted = encrypter.decrypt(myencrypt.Encrypted.fromBase64(tab[0]['dbname']), iv: iv);
                          final ip_server_decrypted = encrypter.decrypt(myencrypt.Encrypted.fromBase64(tab[0]['ip_server']), iv: iv);
                          final site_commercant_decrypted = encrypter.decrypt(myencrypt.Encrypted.fromBase64(tab[0]['site_commercant']), iv: iv);
                          final site_pam_decrypted = encrypter.decrypt(myencrypt.Encrypted.fromBase64(tab[0]['site_pam']), iv: iv);
                          final user_decrypted = encrypter.decrypt(myencrypt.Encrypted.fromBase64(tab[0]['user']), iv: iv);
                          final mdp_decrypted = encrypter.decrypt(myencrypt.Encrypted.fromBase64(tab[0]['mdp']), iv: iv);

                          //final site_commercant_decrypted = encrypter.decrypt(tab[0]['site_commercant'], iv: iv);

                          setState(() {
                            //_locate = TextEditingController(text: tab[0]['locate']);
                            _device = TextEditingController(text: device_decrypted);
                            _adresse_server = TextEditingController(text: adresse_server_decrypted);
                            _dbname = TextEditingController(text: dbname_decrypted);
                            _ip_server = TextEditingController(text: ip_server_decrypted);
                            _site_commercant = TextEditingController(text: site_commercant_decrypted);
                            _site_pam = TextEditingController(text: site_pam_decrypted);
                            _user = TextEditingController(text: user_decrypted);
                            _mdp = TextEditingController(text: mdp_decrypted);
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