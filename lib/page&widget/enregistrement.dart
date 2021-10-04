//package native
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math' show Random;
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
//pakage importer pub get
import 'package:http/http.dart' as http;
import'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
//import 'package:mysql1/mysql1.dart';
import 'package:pam/model/Searchbar.dart';
import 'package:pam/model/parametre.dart';
import 'package:pam/model/parametre.dart';
import 'package:pam/model/parametre.dart';
//import 'package:nfc_in_flutter/nfc_in_flutter.dart';
//import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pam/main.dart';
import 'package:random_string/random_string.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pam/model/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:usb_serial/usb_serial.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

//mes pacakage lassprince
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/model/personne_info.dart';
//import 'package:pam/model/nfc_auth.dart';
//import 'package:pam/components/model.dart';

//mes modeles lass prince
import 'package:pam/model/UserControl.dart';

import 'heroImg.dart';


class AdminAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final id = ModalRoute.of(context).settings.arguments;
    //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Enregistrement"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            //les formulaire
            FormAdd(),
          ],
        ),
      ),
    );
  }
}


class FormAdd extends StatefulWidget {
  @override
  _FormAddState createState() => _FormAddState();
}
class _FormAddState extends State<FormAdd> {
  //variable fournit dans les champs
  final _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  //Les variable dropdown form value
  String _genre;
  //String _id_genre;
  String _user;
  String _niveau;
  String _anneeScol;
  String _type_agriculteur;
  int _id_typefonction;
  int _localite;
  String _dategrossesse;
  int _localites;
  String msg;
  //Ecole Incription
  final _idtypeniveau = TextEditingController();
  final _anneeScolaire = TextEditingController();
  //personne
  TextEditingController _nom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _date_naissance = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _telephone = TextEditingController();
  TextEditingController _adresse = TextEditingController();
  //femme enceite
  TextEditingController _datedebut = TextEditingController();
  //plantation agriculteur
  TextEditingController _descriptionplantation = TextEditingController();
  TextEditingController _groupement = TextEditingController();
  //TextEditingController _coordonnee = TextEditingController();
  TextEditingController _superficie = TextEditingController();
  //TextEditingController _observation = TextEditingController();
  TextEditingController _nbre_femme = TextEditingController();
  TextEditingController _nbre_homme = TextEditingController();
  TextEditingController _agreement = TextEditingController();
  //Travailleur dans une plantation
  String plantation;
  //autre iud
  String _iud = "";
  final format = DateFormat("yyyy-MM-dd");
  String nfc_msg_visible = "false";
  //TextEditingController _iud = TextEditingController()..text = '0011';
  //-----------------------------------------------------------------------
  Position position;
  Future getPosition() async {
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  //***********************************************************************
  //Image picker de la gallery
  File _imagefile;
  String _image;
  String _imageLocation;
  final picker = ImagePicker();
  //*********************************************************/get image
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    _imagefile = File(pickedFile.path);
    _image = basename(_imagefile.path);
    final photo = File("/storage/emulated/0/DCLM/Camera/$_image");
    //state
    setState(() {
      _imagefile = File(pickedFile.path);
      _image = basename(_imagefile.path);
      _imageLocation = pickedFile.path;
    });
    //await photo.delete();
  }
  /////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    _genre = '';
    _localites;
    _niveau = '';
  }
  ///////////////////////////////////////////////////
  bool _eleveIsVisible = false;
  bool _agriIsVisible = false;
  bool _femmeIsVisible = false;
  //type agriculteur
  bool _type_agriculteur_chef = false;
  bool _type_agriculteur_travailleur = false;
  ////////////////////
  @override
  Widget build(BuildContext context) {
    //nfc******************************************************************
    searchuid (uid) async {
      List<Map<String, dynamic>> queryPersonne = await DB.queryWhereUid("personne", uid);
      if(queryPersonne.isNotEmpty){
        if(queryPersonne[0]['iud'] == uid){
          nfc_msg_visible = "exist";
        } else {
          nfc_msg_visible = "exist";
        }
      } else {
        nfc_msg_visible = "true";
      }
    }


    if(mounted) {
      FlutterNfcReader.read().then((response) {
        //print(response.id.substring(2));
        _iud = response.id.substring(2);
        String nfc = _iud.toUpperCase();
        setState(() {
          searchuid(nfc);
        });
      });

    } else {
      FlutterNfcReader.stop().then((response) {
        print(response.status.toString());
      });
    }


    //execution de la fonction
    //**********************************************************************
    getPosition();
    //var
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
    var idpersonnefonction = '';
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
    idpersonnefonction = StorageUtil.getString("idpersonnefonction");
    idtypefonction = StorageUtil.getString("idtypefonction");
    idecole = StorageUtil.getString("idecole");
    ecole = StorageUtil.getString("ecole");
    //////////////////////////////////////////////////////////////////////////
    if (idtypefonction == "DG") {
      //sa va
      _eleveIsVisible = true;
    } else {
      _eleveIsVisible = false;
    }
    //agriculteur
    if (idtypefonction == "AA") {
      //sa va
      _agriIsVisible = true;
    } else {
      _agriIsVisible = false;
    }
    //femme enceintes
    if (idtypefonction == "AFE") {
      //sa va
      _femmeIsVisible = true;
    } else {
      _femmeIsVisible = false;
    }
    //Si chef agriculteur
    if (_type_agriculteur == "CA") {
      //sa va
      _type_agriculteur_chef = true;
    } else {
      _type_agriculteur_chef = false;
    }
    //Si Travailleur
    if (_type_agriculteur == "AG") {
      //sa va
      _type_agriculteur_travailleur = true;
    } else {
      _type_agriculteur_travailleur = false;
    }
    //*********************************************************************//
    //Donne de la session en cours
    //ici on reupere les info dans codif where genre
    Future<void> SelectSession() async {
      if(idtypefonction == "AA"){
        List<Map<String, dynamic>> querySession = await DB.queryCampagne();
        return querySession;
      } else if (idtypefonction == "DG"){
        List<Map<String, dynamic>> querySession = await DB.queryAnneeScolaire();
        return querySession;
      }

    }
    final _SESSION = FutureBuilder(
        future: SelectSession(),
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
          return snap.isNotEmpty ?
          Container(
            //color: Colors.indigo,
              margin: EdgeInsets.only(bottom: 30.0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  //height: 50.0,
                  child: Text(
                    "SESSION: ${snap[0]['description']}",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
          ) :
          Container(
            //color: Colors.indigo,
              margin: EdgeInsets.only(bottom: 30.0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  //height: 50.0,
                  child: Text(
                    "SESSION EN COURS DE SYNCHRONISATION",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
          ) ;
        }
    );
    //----------------------------------------------------------------------
    //ici on reupere les info dans codif where genre
    Future<void> SelectCodifGenre() async {
      List<Map<String, dynamic>> queryCodif = await DB.queryCodif("codification", "genre");
      return queryCodif;
    }
    final _genres = FutureBuilder(
        future: SelectCodifGenre(),
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
          return DropDownFormField(
            titleText: 'Genre',
            hintText: 'Personne',
            value: _genre,
            onSaved: (value) {
              setState(() {
                _genre = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _genre = value;
              });
            },
            dataSource: snap,
            textField: 'description',
            valueField: 'idcodification',
            validator: (value) {
              if (_genre == "") {
                return 'Veuiller selectionner le genre';
              }
              return null;
            },
          );
        }
    );
    //******************************************************///
    //************************************************************//
    //ici on reupere les info dans codif where Type niveau
    Future<void> SelectCodifClasse() async {
      List<Map<String, dynamic>> queryCodif = await DB.queryCodif(
          "codification", "niveau");
      return queryCodif;
    }
    final _classe = FutureBuilder(
        future: SelectCodifClasse(),
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
          return DropDownFormField(
            titleText: 'Classe',
            hintText: 'niveau de l\'eleve',
            value: _niveau,
            onSaved: (value) {
              setState(() {
                _niveau = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _niveau = value;
              });
            },
            dataSource: snap,
            textField: 'description',
            valueField: 'idcodification',
            validator: (value) {
              if (_niveau == "") {
                return 'Veuiller selection le niveau de l\'eleve';
              }
              return null;
            },
          );
        }
    );
    //**********************************************************************//
    //Recuperation les info dans codif where Type niveau
    Future<void> SelectCodifAnneeScolaire() async {
      List<Map<String, dynamic>> queryCodif = await DB.queryCodif(
          "codification", "annee scolaire");
      return queryCodif;
    }
    final _annee = FutureBuilder(
        future: SelectCodifAnneeScolaire(),
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
          return DropDownFormField(
            titleText: 'Session',
            hintText: 'Annee scolaire: Ex: 2020-2021',
            value: _anneeScol,
            onSaved: (value) {
              setState(() {
                _anneeScol = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _anneeScol = value;
              });
            },
            dataSource: snap,
            textField: 'description',
            valueField: 'idcodification',
            validator: (value) {
              if (_anneeScol == "") {
                return 'Veuiller Selectionner l\'annee en scolaire ';
              }
              return null;
            },
          );
        }
    );
    //------------------------------------------------type Codif et autre
    //ici on reupere les info dans codif where Type Localiter
    Future<void> SelectLocalite() async {
      List<Map<String, dynamic>> queryCodif = await DB.queryAll("localite");
      return queryCodif;
    }
    final _Localite = FutureBuilder(
        future: SelectLocalite(),
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
          return DropDownFormField(
            titleText: 'Localite',
            hintText: 'zone',
            value: _localites,
            onSaved: (value) {
              setState(() {
                _localites = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _localites = value;
              });
            },
            dataSource: snap,
            textField: 'description',
            valueField: 'id',
            validator: (value) {
              if (_localites == "") {
                return 'Veuiller Slectionner une localite';
              }
              return null;
            },
          );
        }
    );
    //**********************************************************************//
    //Recuperation les info dans codif where Type niveau
    Future<void> SelectAgriculteur() async {
      List<Map<String, dynamic>> queryCodif = await DB.queryparam2Where(
          "codification", "fonction", "agriculteur");
      return queryCodif;
    }
    final _status = FutureBuilder(
        future: SelectAgriculteur(),
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
          return DropDownFormField(
            titleText: 'Status',
            hintText: 'Chef ou travailleur',
            value: _type_agriculteur,
            onSaved: (value) {
              setState(() {
                _type_agriculteur = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _type_agriculteur = value;
              });
            },
            dataSource: snap,
            textField: 'description',
            valueField: 'idcodification',
            validator: (value) {
              if (_type_agriculteur == "") {
                return 'Veuiller choissir';
              }
              return null;
            },
          );
        }
    );
    /////////////////////////////////////////////////////////
    //variable date
    DateTime date;
    //content
    return Padding(
      padding: EdgeInsets.only(
        left: 100.0, right: 100.0, top: 30, bottom: 30.0,),
      child: Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              // Add TextFormFields and RaisedButton here.
              //CardSettingsHeader(label: "Ajouter des membres",),
              //les champs et boutton
              Container(
                //color: Colors.indigo,
                  margin: EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      //height: 50.0,
                      child: Text(
                        "Information d'enregistrement",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
              ),
              _femmeIsVisible == true ? Container() : _SESSION,
              //-------------------------------------------------------
              /*
                DropdownSearch<String>(
                  validator: (v) => v == null ? "required field" : null,
                  hint: "Select a country",
                  mode: Mode.MENU,
                  showSelectedItem: true,
                  items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                  label: "Menu mode *",
                  showClearButton: true,
                  onChanged: print,
                  popupItemDisabled: (String s) => s.startsWith('I'),
                  selectedItem: "Brazil",
                ),*/
              //-------------------------------------------------------
              //------------------------------------------------------
              /*
                DropdownSearch<String>(
                  mode: Mode.BOTTOM_SHEET,
                  maxHeight: 300,
                  items: ["Brazil", "Italia", "Tunisia", 'Canada'],
                  label: "Custom BottomShet mode",
                  onChanged: print,
                  selectedItem: "Brazil",
                  showSearchBox: true,
                  searchBoxDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                    labelText: "Search a country",
                  ),
                  popupTitle: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Country',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  popupShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                ),
                //-------------------------------------------------------
                Divider(),
                //------------------------------------------------------
                DropdownSearch<UserModel>(
                  mode: Mode.BOTTOM_SHEET,
                  isFilteredOnline: true,
                  showClearButton: true,
                  showSearchBox: true,
                  label: 'User *',
                  dropdownSearchDecoration: InputDecoration(
                      filled: true,
                      fillColor:
                      Theme.of(context).inputDecorationTheme.fillColor),
                  autoValidate: true,
                  validator: (UserModel u) =>
                  u == null ? "user field is required " : null,
                  onFind: (String filter) => getData(filter),
                  onChanged: (UserModel data) {
                    print(data);
                  },
                  dropdownBuilder: _customDropDownExample,
                  popupItemBuilder: _customPopupItemBuilderExample,
                ),
                Divider(),
                 */
              /*
                DropdownSearch<UserModel>(
                  items: [
                    UserModel(name: "Offline name1", id: "999"),
                    UserModel(name: "Offline name2", id: "0101")
                  ],
                  maxHeight: 300,
                  onFind: (String filter) => getData(filter),
                  label: "choose a user",
                  onChanged: print,
                  showSearchBox: true,
                ),
                Divider(),
                */
              //-------------------------------------------------------
              TextFormField(
                obscureText: false,
                style: style,
                controller: _nom,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  icon: Icon(Icons.account_circle, color: Colors.blue),
                  hintText: "Entrer le nom",
                  hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                  //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                  enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuiller entrer une information';
                  }
                  return null;
                },
              ),
              SizedBox(height: 25.0),
              TextFormField(
                obscureText: false,
                controller: _prenom,
                style: style,
                decoration: InputDecoration(
                  icon: Icon(Icons.account_box_outlined, color: Colors.blue),
                  hintText: "Entrer le prenom",
                  hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                  enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuiller entrer une information';
                  }
                  return null;
                },
              ),
              SizedBox(height: 25.0),
              _femmeIsVisible == true ?
              TextFormField(
                obscureText: false,
                controller: _age,
                keyboardType: TextInputType.number,
                style: style,
                decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today, color: Colors.blue),
                  hintText: "Age",
                  hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                  enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuiller entrer une information';
                  }
                  return null;
                },
              ) :
              DateTimeField(
                format: format,
                controller: _date_naissance,
                decoration: InputDecoration(
                  icon: Icon(Icons.date_range, color: Colors.blue),
                  hintText: "Entrer la date de naissance",
                  hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                  enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                ),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
                validator: (value) {
                  if (_date_naissance.text.isEmpty) {
                    return 'Veuiller entrer une information';
                  }
                  return null;
                },
              ),
              //
              /*
                DateTimePickerFormField(
                  inputType: InputType.date,
                  format: DateFormat("yyyy-MM-dd"),
                  initialDate: DateTime(2020, 1, 1),
                  controller: _date_naissance,
                  editable: false,
                  decoration: InputDecoration(
                    icon: Icon(Icons.date_range, color: Colors.blue),
                    hintText: "Entrer la date de naissance",
                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                    enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                  ),
                  onChanged: (dt) {
                    setState(() => date = dt);
                    print('Selected date: $date');
                  },
                ),
                */
              _femmeIsVisible == true ? Container() : SizedBox(height: 25.0),
              //////////////////////genre dropdown///////////////
              _femmeIsVisible == true ? Container() : _genres,
              ///////////////////////////////////////////////////
              SizedBox(height: 25.0),
              TextFormField(
                obscureText: false,
                controller: _telephone,
                keyboardType: TextInputType.number,
                style: style,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone, color: Colors.blue),
                  hintText: "Entrer le numero de telephone",
                  hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                  enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuiller entrer une information';
                  }
                  return null;
                },
              ),
              SizedBox(height: 25.0),
              //_Localite,
              //SizedBox(height: 25.0),
              TextFormField(
                obscureText: false,
                controller: _adresse,
                style: style,
                decoration: InputDecoration(
                  icon: Icon(Icons.add_location, color: Colors.blue),
                  hintText: "Entrer l'adresse",
                  hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                  enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuiller entrer une information';
                  }
                  return null;
                },
              ),
              //SizedBox(height: 25.0),
              //_Typefonction,
              /////////////////////////////////////
              SizedBox(height: 25.0),
              /*
                TextFormField(
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  style: style,
                  //enabled: false,
                  controller: _iud,
                  decoration: InputDecoration(
                    icon: Icon(Icons.nfc, color: Colors.blue),
                    hintText: "Bracelet nfc (Veuiller scanner le bracelet)",
                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                    enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Le bracelet n\'est pas scanner, Veuiller ressailler';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25.0),*/
              //visibilite Eleves
              Visibility(
                visible: _eleveIsVisible,
                child: Column(
                  children: <Widget>[
                    //la classe de leleve
                    _classe,
                    SizedBox(height: 25.0),
                    //annee scolaire de l'eleve
                    //_annee,
                    //SizedBox(height: 25.0),
                  ],
                ),
              ),
              ////////////////visibilite agriculteur//////////////
              Visibility(
                visible: _agriIsVisible,
                child: Column(
                  children: <Widget>[
                    //_status,
                    //SizedBox(height: 25.0),
                    //
                    /*
                            TextFormField(
                              obscureText: false,
                              style: style,
                              controller: _descriptionplantation,
                              decoration: InputDecoration(
                                icon: Icon(Icons.landscape, color: Colors.blue),
                                hintText: "plantation",
                                hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veuiller entrer une information';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 25.0),
                            */
                    TextFormField(
                      obscureText: false,
                      style: style,
                      controller: _groupement,
                      decoration: InputDecoration(
                        icon: Icon(Icons.group_add, color: Colors.blue),
                        hintText: "Groupement",
                        hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                        enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Veuiller entrer une information';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    TextFormField(
                      obscureText: false,
                      style: style,
                      controller: _nbre_femme,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(Icons.group_add, color: Colors.blue),
                        hintText: "Vous avez combien de femme au sein de votre groupement ?",
                        hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                        enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Veuiller entrer une information';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    TextFormField(
                      obscureText: false,
                      style: style,
                      controller: _nbre_homme,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(Icons.group_add, color: Colors.blue),
                        hintText: "Vous avez combien d'homme au sein de votre groupement ?",
                        hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                        enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Veuiller entrer une information';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      controller: _superficie,
                      style: style,
                      decoration: InputDecoration(
                        icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                        hintText: "Entrer la superficie de la plantation (m2)",
                        hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                        enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Veuiller entrer une information';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    TextFormField(
                      //keyboardType: TextInputType.number,
                      obscureText: false,
                      controller: _agreement,
                      style: style,
                      decoration: InputDecoration(
                        icon: Icon(Icons.article_sharp, color: Colors.blue),
                        hintText: "Agreement du groupement",
                        hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                        enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Veuiller entrer une information';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    /*
                      TextFormField(
                        obscureText: false,
                        controller: _observation,
                        style: style,
                        decoration: InputDecoration(
                          icon: Icon(Icons.description, color: Colors.blue),
                          hintText: "Observation",
                          hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                          enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Veuiller entrer une information';
                          }
                          return null;
                        },
                      ),
                      */
                    /*
                      Visibility(
                        visible: _type_agriculteur_chef,
                        child: Column(
                          children: <Widget>[],
                        ),
                      ),

                      Visibility(
                        visible: _type_agriculteur_travailleur,
                        child: Column(
                          children: <Widget>[
                            DropdownSearch<UserModel>(
                              showSelectedItem: true,
                              compareFn: (UserModel i, UserModel s) => i.isEqual(s),
                              label: "Plantation",
                              onFind: (String filter) => getData(filter),
                              onChanged: (UserModel data) {
                                print(data);
                              },
                              dropdownBuilder: _customDropDownExample,
                              popupItemBuilder: _customPopupItemBuilderExample2,
                              validator: (value) {
                                if (plantation == null) {
                                  return 'Veuiller Selectionner une plantation';
                                }
                                return null;
                              },
                            ),
                            /*
                            RaisedButton(
                              color: Colors.green,
                              elevation: 5,
                              hoverElevation: 10,
                              padding: EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: Text('Plantation', style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,),),
                              ),
                              onPressed:  () async {
                                final idplantationReturn = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectPlantation()),);
                              },
                            ),
                            */
                            //SizedBox(height: 15.0,),
                          ],
                        ),
                      ),
                      */

                  ],
                ),
              ),
              /////////////////////////////Visibilite femme enceinte
              Visibility(
                visible: _femmeIsVisible,
                child: Column(
                  children: <Widget>[
                    DropDownFormField(
                      titleText: 'Status de la femme enceinte',
                      hintText: 'Femme enceinte ou femme allaitante',
                      value: _dategrossesse,
                      onSaved: (value) {
                        setState(() {
                          _dategrossesse = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _dategrossesse = value;
                        });
                      },
                      dataSource: [
                        {
                          "display": "Femme Enceinte",
                          "value": "Femme Enceinte",
                        },
                        {
                          "display": "Femme Allaitante",
                          "value": "Femme Allaitante",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                    //SizedBox(height: 25.0),
                    SizedBox(height: 25.0),
                    //SizedBox(height: 25.0),
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              RaisedButton(
                color: Colors.teal,
                elevation: 5,
                hoverElevation: 10,
                padding: EdgeInsets.all(10.0),
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Image', style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,),),
                  ),
                ),
                onPressed: getImage,
              ),
              _imagefile == null
                  ? Text(
                'Veuillez prendre la photo de l\'utlisateur', style: TextStyle(color: Colors.red,),)
                  : /*Image.file(_image)*/
              Column(
                children: [
                  SizedBox(height: 5.0,),
                  SizedBox(
                    height: 250.0,
                    width: 250.0,
                    child: Image.file(_imagefile),
                  ),
                  SizedBox(height: 10.0,),
                  Text('Photo selectionnée' , style: TextStyle(color: Colors.green,),),
                ],
              ),
              SizedBox(height: 25.0),
              SizedBox(
                //height: 150.0,
                  child: nfc_msg_visible == "false"
                      ? Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("images/scan_nfc.png"),
                        ),
                      ),
                      Text(
                        'Veuillez Scanner le bracelet d\'identification', style: TextStyle(color: Colors.red,),),
                    ],
                  )
                      : (nfc_msg_visible == "exist" ?
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("images/scan_nfc.png"),
                        ),
                      ),
                      Text('Ce bracelet a déjà été utlilisé, Veuillez utiliser un autre bracelet' , style: TextStyle(color: Colors.red,),),
                    ],
                  ) :
                  Text('Bracelet scanné avec succès merci' , style: TextStyle(color: Colors.green,),)
                  )
              ),
              SizedBox(height: 25.0,),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Color(0xff01A0C7),
                child: MaterialButton(
                  minWidth: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () async {
                    //enregistrement ave nfc
                    //_coordonnee = TextEditingController()..text = position.toString();
                    if (nfc_msg_visible == "true") {
                      if (_formKey.currentState.validate()) {
                        //verification des informations
                        var confirm = await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "LES INSFORMATIONS SAISIES SONT-IL CORRECTE ?",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              content: Column(
                                children: [
                                  _imagefile == null
                                      ? Text(
                                    'Veuillez prendre la photo de l\'utlisateur', style: TextStyle(color: Colors.red,),)
                                      :
                                  Column(
                                    children: [
                                      SizedBox(height: 5.0,),
                                      SizedBox(
                                        height: 150.0,
                                        width: 150.0,
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: FileImage(_imagefile),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Nom : ${_nom.text}",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Prenom : ${_prenom.text}",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  _femmeIsVisible == true ? Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Age : ${_age.text} ans",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ) : Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Date naissance : ${_date_naissance.text}",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Telephone : ${_telephone.text}",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Adresse : ${_adresse.text}",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  _eleveIsVisible ? Column(
                                    children: [
                                      Container(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              //height: 50.0,
                                              child: _niveau == "-2" ?
                                              Text(
                                                "Classe : Petite Section",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ) : _niveau == "-1" ?
                                              Text(
                                                "Classe : Moyenne Section",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ) : _niveau == "0" ?
                                              Text(
                                                "Classe : Grande section",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ) : _niveau == "13" ?
                                              Text(
                                                "Classe : Terminale",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ) : _niveau == "1" ?
                                              Text(
                                                "Classe : $_niveau ere Année",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ) :
                                              Text(
                                                "Classe : $_niveau eme Année",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                      SizedBox(height: 15.0,),
                                    ],
                                  ) : _agriIsVisible ? Column(
                                    children: [
                                      Container(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              //height: 50.0,
                                              child: Text(
                                                "Groupement : ${_groupement.text}",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                      SizedBox(height: 15.0,),
                                      Container(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              //height: 50.0,
                                              child: Text(
                                                "Nombre Femme : ${_nbre_femme.text}",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                      SizedBox(height: 15.0,),
                                      Container(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              //height: 50.0,
                                              child: Text(
                                                "Nombre Homme : ${_nbre_homme.text}",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                      SizedBox(height: 15.0,),
                                      Container(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              //height: 50.0,
                                              child: Text(
                                                "Superficie : ${_superficie.text}",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                      SizedBox(height: 15.0,),
                                      Container(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              //height: 50.0,
                                              child: Text(
                                                "Agreement : ${_agreement.text}",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                      SizedBox(height: 15.0,),
                                    ],
                                  ) : _femmeIsVisible ? Column(
                                    children: [
                                      Container(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              //height: 50.0,
                                              child: Text(
                                                "Status : $_dategrossesse",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                      SizedBox(height: 15.0,),
                                    ],
                                  ) : Container(),
                                ],
                              ), //const
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Non, je vais revérifier',style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  onPressed: () {
                                    Navigator.of(context).pop('non');
                                  },
                                ),
                                FlatButton(
                                  child: Text('Oui je confirme',style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  onPressed: () {
                                    Navigator.of(context).pop('oui');
                                  },
                                ),
                              ],
                              //shape: CircleBorder(),
                            );
                          },
                        );
                        if (confirm == "oui"){
                          //Si tout est bon on insert dans la base de donnees
                          //nom de la tablette
                          var _tab = await DB.initTabquery();
                          if(_tab.isNotEmpty){
                            if(_tab[0]["locate"] != "" || _tab[0]["locate"] != null){
                              //
                              //var _locateAgent = await DB.queryWhereidlocalite("localite",idlocalite);
                              var _locate = await DB.queryWherelocate("localite",_tab[0]["locate"]);
                              List<Map<String, dynamic>> queryEcole = await DB.queryWhereidpersonne("ecole", idpersonne);

                              if(_tab[0]["locate"] == idlocalite){
                                var _campagneAgri = await DB.queryCampagne();
                                var _campagneAnneeS = await DB.queryAnneeScolaire();
                                //Verif
                                if(idtypefonction == "AA" && _campagneAgri.isNotEmpty || idtypefonction == "DG" && _campagneAnneeS.isNotEmpty && queryEcole.isNotEmpty || idtypefonction == "AFE"){
                                  //Decomposition de l'annee idtypeannee
                                  String a = _campagneAnneeS[0]['description'];
                                  String anneeSimple = a.substring(5);
                                  //Debut d'enregistrement
                                  String idpersonnegen = Param.device+"-"+randomAlphaNumeric(10);
                                  String idpersonneaddgen = Param.device+"-"+randomAlphaNumeric(10);
                                  String idpersonnetelgen = Param.device+"-"+randomAlphaNumeric(10);
                                  String idpersonnefongen = Param.device+"-"+randomAlphaNumeric(10);
                                  //femme enceinte
                                  String idgrossegen = Param.device+"-"+randomAlphaNumeric(10);
                                  //admin agriculteur
                                  String iddetplantgen = Param.device+"-"+randomAlphaNumeric(10);
                                  String idplangen = Param.device+"-"+randomAlphaNumeric(10);
                                  //Directeur
                                  String idinsgen = Param.device+"-"+randomAlphaNumeric(10);
                                  String idclsgen = Param.device+"-"+randomAlphaNumeric(10);
                                  //
                                  var dateNow = new DateTime.now();
                                  //personne
                                  await DB.insert("personne", {
                                    "id": idpersonnegen,
                                    "nom": _nom.text.toUpperCase(),
                                    "prenom": _prenom.text.toUpperCase(),
                                    "date_naissance": _femmeIsVisible == true ? _age.text : _date_naissance.text,
                                    "idgenre": _femmeIsVisible == true ? "F" : _genre,
                                    "date_creation": dateNow.toString(),
                                    "iud": _iud.toUpperCase(),
                                    "email": "",
                                    "mdp": "",
                                    "image": _image,
                                    "flagtransmis": "",
                                  });
                                  //personne_adresse
                                  await DB.insert("personne_adresse", {
                                    "id": idpersonneaddgen,
                                    "idlocalite": _locate[0]["id"],
                                    "idpersonne": idpersonnegen,
                                    "adresse": _adresse.text,
                                    "flagtransmis": "",
                                  });
                                  //personne_tel
                                  await DB.insert("personne_tel", {
                                    "id": idpersonnetelgen,
                                    "idpersonne": idpersonnegen,
                                    "numero_tel": _telephone.text,
                                    "flagtransmis": "",
                                  });
                                  //Insertion en fonction des admin
                                  //Directeur
                                  if (idtypefonction == "DG") {
                                    await DB.insert("personne_fonction", {
                                      "id": idpersonnefongen,
                                      "idpersonne": idpersonnegen,
                                      "idtypefonction": "EV",
                                      "flagtransmis": "",
                                    });
                                    await DB.insert("inscription", {
                                      "id": idinsgen,
                                      "idpersonne": idpersonnegen,
                                      "idclasse": idclsgen,
                                      "idtypeannee": anneeSimple,
                                      "anneeScolaire": _campagneAnneeS[0]['description'],
                                      "flagtransmis": "",
                                    });
                                    //
                                    await DB.insert("classe", {
                                      "id": idclsgen,
                                      "idecole": idecole,
                                      "idtypeniveau": _niveau,
                                      "anneeScolaire": _campagneAnneeS[0]['description'],
                                      "flagtransmis": "",
                                    });
                                  } else if (idtypefonction == "AA") {
                                    //Admin Agriculteur
                                    await DB.insert("personne_fonction", {
                                      "id": idpersonnefongen,
                                      "idpersonne": idpersonnegen,
                                      "idtypefonction": "CA",
                                      "flagtransmis": "",
                                    });
                                    //Si chef agriculteur
                                    await DB.insert("detenteur_plantation", {
                                      "id": iddetplantgen,
                                      "idplantation": idplangen,
                                      "idpersonne": idpersonnegen,
                                      "flagtransmis": "",
                                    });
                                    //Chef
                                    if(position == null) {
                                      await DB.insert("plantation", {
                                        "id": idplangen,
                                        "description": "",
                                        "groupement": _groupement.text,
                                        "longitude": _locate[0]["longitude"],
                                        "latitude": _locate[0]["latitude"],
                                        "superficie": _superficie.text,
                                        "idlocalite": _locate[0]["id"],
                                        "nbre_femme": _nbre_femme.text,
                                        "nbre_homme": _nbre_homme.text,
                                        "nbre_membre": int.parse(_nbre_homme.text) + int.parse(_nbre_femme.text),
                                        "agreement": _agreement.text,
                                        "observation": "", //_observation.text
                                        "flagtransmis": "",
                                      });
                                    } else {
                                      await DB.insert("plantation", {
                                        "id": idplangen,
                                        "description": "",
                                        "groupement": _groupement.text,
                                        "longitude": position.longitude,
                                        "latitude": position.latitude,
                                        "superficie": _superficie.text,
                                        "idlocalite": _locate[0]["id"],
                                        "nbre_femme": _nbre_femme.text,
                                        "nbre_homme": _nbre_homme.text,
                                        "nbre_membre": int.parse(_nbre_homme.text) + int.parse(_nbre_femme.text),
                                        "observation": "", //_observation.text
                                        "flagtransmis": "",
                                      });
                                    }

                                    if (_type_agriculteur == "CA") {}
                                    //Si Travailleur
                                    if (_type_agriculteur == "AG") {
                                      await DB.insert("detenteur_plantation", {
                                        "id": iddetplantgen,
                                        "idplantation": plantation,
                                        "idpersonne": idpersonnegen,
                                        "flagtransmis": "",
                                      });
                                    }
                                  } else if (idtypefonction == "AFE") {
                                    //Agent Admin femme enceintes
                                    await DB.insert("personne_fonction", {
                                      "id": idpersonnefongen,
                                      "idpersonne": idpersonnegen,
                                      "idtypefonction": "FE",
                                      "flagtransmis": "",
                                    });
                                    await DB.insert("grossesse", {
                                      "id": idgrossegen,
                                      "idpersonne": idpersonnegen,
                                      "status": _dategrossesse,
                                      "ordre": 1,
                                      "flagtransmis": "",
                                    });
                                  }
                                  setState(() {
                                    //On vides les champs a zero
                                    _nom = TextEditingController(text: "");
                                    _prenom = TextEditingController(text: "");
                                    _date_naissance = TextEditingController(text: "");
                                    _age = TextEditingController(text: "");
                                    _telephone = TextEditingController(text: "");
                                    _adresse = TextEditingController(text: "");
                                    _descriptionplantation = TextEditingController(text: "");
                                    _groupement = TextEditingController(text: "");
                                    _superficie = TextEditingController(text: "");
                                    _agreement = TextEditingController(text: "");
                                    _nbre_homme = TextEditingController(text: "");
                                    _nbre_femme = TextEditingController(text: "");
                                    plantation = "";
                                    _dategrossesse = "";
                                    _iud = "";
                                    _genre = "";
                                    _anneeScol = "";
                                    _niveau = "";
                                    _localites = null;
                                    _imagefile = null;
                                    nfc_msg_visible = "false";
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Enregistrement effectué avec succès !",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 24.0
                                  );
                                }else {
                                  if(idtypefonction == "DG" && queryEcole.isEmpty){
                                    Fluttertoast.showToast(
                                        msg: "Pas d'ecole",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 24.0
                                    );
                                  }
                                  if (_campagneAnneeS.isEmpty || _campagneAgri.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Aucune session enregistrer, Veuillez contacter l\'administrateur pour l\'ajout d\'une session !",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 24.0
                                    );
                                  }
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Vous n\'etes pas autoriser a enregistrer dans cet localite !",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 24.0
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Veuillez selectionner une localite !",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 24.0
                              );
                            }

                          }else{
                            Fluttertoast.showToast(
                                msg: "La tablette na pas d\'identifiant ou n\'a pas ete identifier, Veuiller contacter la call center",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 24.0
                            );
                          }
                        } //si il clique sur non !!!
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Veuillez scanner le bracelet de l\'utilisateur",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 24.0
                      );
                    }
                  },
                  child: Text("Inscription",
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ]
        ),
      ),
    );
  }
  //--------------get------------------------------------------------
  Future<List<UserModel>> getData(filter) async {
    var response = await DB.queryPersonDetPlantation();
    var models = UserModel.fromJsonList(response);
    return models;
  }
}