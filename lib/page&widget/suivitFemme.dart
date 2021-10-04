import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam/database/database.dart';
import 'package:pam/model/donnee_route.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

class SuivitFemme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: suivitFemmeForm(),
    );
  }
}


class suivitFemmeForm extends StatefulWidget {
  @override
  _suivitFemmeFormState createState() => _suivitFemmeFormState();
}

class _suivitFemmeFormState extends State<suivitFemmeForm> {

  //forme
  final _formKey3 = GlobalKey<FormState>();

  //Questionnaire femme enceinte
  String centre_sante;
  String nbre_repas_femme;
  String nbre_fruit_femme;
  //String nbre_legume_femme;
  String nbre_viande_femme;
  String nbre_fonio_femme;
  String _nbre_legume_femme;
  //TextEditingController _nbre_legume_femme = TextEditingController();
  TextEditingController _acces_eau_femme_autre = TextEditingController();

  //String
  String _acces_eau_femme = "";

  bool eau = false;


  @override
  Widget build(BuildContext context) {

    //Condition eau
    if(_acces_eau_femme != "Autre"){
      eau = false;
    } else {
      eau = true;
    }

    //
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();
    //
    final DonneeRoute userInfo = ModalRoute.of(context).settings.arguments;

    return Center(
      child: Container(
        padding: EdgeInsets.only(left:50.0, right: 50.0),
        child: Card(
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.only(left:50.0, right: 50.0),
            child: Form(
              key: _formKey3,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //intro
                    Container(
                        margin: EdgeInsets.only(bottom: 30.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            //height: 10.0,
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
                              "Suivi nutritionnel des femmes enceintes et allaitantes",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                    ),
                    /*
                                        DropDownFormField(
                                          titleText: 'Etes-vous une FA ? FE ? ou les 2 ?',
                                          hintText: 'FA/FE',
                                          value: _type_femme,
                                          onSaved: (value) {
                                            setState(() {
                                              _type_femme = value;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _type_femme = value;
                                            });
                                          },
                                          dataSource: [
                                            {"display": "Femme Enceinte", "value": "Femme Enceinte"},
                                            {"display": "Femme Allaitante", "value": "Femme Allaitante"},
                                            {"display": "Les 2", "value": "Les 2"}
                                          ],
                                          textField: 'display',
                                          valueField: 'value',
                                          validator: (value) {
                                            if (_type_femme == "") {
                                              return 'Veuiller Slectionner une localite';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 25.0),
                                        */
                    DropDownFormField(
                      titleText: 'Est-ce que vous etes rendu au moins une fois au CS pour un CPN/CPP dans le mois ?',
                      hintText: 'Centre de sante',
                      value: centre_sante,
                      onSaved: (value) {
                        setState(() {
                          centre_sante = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          centre_sante = value;
                        });
                      },
                      dataSource: [
                        {"display": "Oui", "value": "Oui"},
                        {"display": "Non", "value": "Non"},
                        {"display": "N/A", "value": "N/A"}
                      ],
                      textField: 'display',
                      valueField: 'value',
                      validator: (value) {
                        if (centre_sante == "") {
                          return 'Veuiller Slectionner une localite';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    DropDownFormField(
                      titleText: 'Combien de fois par jour vous mangez un repas ?',
                      hintText: 'Mange',
                      value: nbre_repas_femme,
                      onSaved: (value) {
                        setState(() {
                          nbre_repas_femme = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          nbre_repas_femme = value;
                        });
                      },
                      dataSource: [
                        {"display": "1", "value": "1"},
                        {"display": "2", "value": "2"},
                        {"display": "3", "value": "3"},
                        {"display": "4", "value": "4"},
                        {"display": "5", "value": "5"},
                        {"display": "6", "value": "6"},
                        {"display": "7", "value": "7"},
                        {"display": "8", "value": "8"},
                        {"display": "9", "value": "9"},
                        {"display": "10", "value": "10"},
                        {"display": "N/A", "value": "N/A"}
                      ],
                      textField: 'display',
                      valueField: 'value',
                      validator: (value) {
                        if (nbre_repas_femme == "") {
                          return 'Veuiller Slectionner une localite';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    DropDownFormField(
                      titleText: 'Combien de fois dans la semaine vous mangez des fruits ?',
                      hintText: 'Mange',
                      value: nbre_fruit_femme,
                      onSaved: (value) {
                        setState(() {
                          nbre_fruit_femme = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          nbre_fruit_femme = value;
                        });
                      },
                      dataSource: [
                        {"display": "1", "value": "1"},
                        {"display": "2", "value": "2"},
                        {"display": "3", "value": "3"},
                        {"display": "4", "value": "4"},
                        {"display": "5", "value": "5"},
                        {"display": "6", "value": "6"},
                        {"display": "7", "value": "7"},
                        {"display": "8", "value": "8"},
                        {"display": "9", "value": "9"},
                        {"display": "10", "value": "10"},
                        {"display": "N/A", "value": "N/A"}
                      ],
                      textField: 'display',
                      valueField: 'value',
                      validator: (value) {
                        if (nbre_fruit_femme == "") {
                          return 'Veuiller Slectionner un nombre';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    DropDownFormField(
                      titleText: 'Combien de fois dans la semaine vous mangez des fruits ?',
                      hintText: 'Mange',
                      value: _nbre_legume_femme,
                      onSaved: (value) {
                        setState(() {
                          _nbre_legume_femme = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _nbre_legume_femme = value;
                        });
                      },
                      dataSource: [
                        {"display": "1", "value": "1"},
                        {"display": "2", "value": "2"},
                        {"display": "3", "value": "3"},
                        {"display": "4", "value": "4"},
                        {"display": "5", "value": "5"},
                        {"display": "6", "value": "6"},
                        {"display": "7", "value": "7"},
                        {"display": "8", "value": "8"},
                        {"display": "9", "value": "9"},
                        {"display": "10", "value": "10"},
                        {"display": "11", "value": "11"},
                        {"display": "12", "value": "12"},
                        {"display": "13", "value": "13"},
                        {"display": "14", "value": "14"},
                        {"display": "15", "value": "15"},
                        {"display": "16", "value": "16"},
                        {"display": "17", "value": "17"},
                        {"display": "18", "value": "18"},
                        {"display": "19", "value": "19"},
                        {"display": "20", "value": "20"},
                        {"display": "N/A", "value": "N/A"}
                      ],
                      textField: 'display',
                      valueField: 'value',
                      validator: (value) {
                        if (_nbre_legume_femme == "") {
                          return 'Veuiller Slectionner un nombre';
                        }
                        return null;
                      },
                    ),
                    /*
                    TextFormField(
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      controller: _nbre_legume_femme,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        //icon: Icon(Icons.show_chart, color: Colors.blue),
                        hintText: "Combien de fois dans la semaine vous mangez des légumes ?",
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
                    */
                    SizedBox(height: 25.0),
                    DropDownFormField(
                      titleText: 'Combien de fois dans la semaine vous mangez de la viande, poisson/oeuf ?',
                      hintText: 'Mange',
                      value: nbre_viande_femme,
                      onSaved: (value) {
                        setState(() {
                          nbre_viande_femme = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          nbre_viande_femme = value;
                        });
                      },
                      dataSource: [
                        {"display": "1", "value": "1"},
                        {"display": "2", "value": "2"},
                        {"display": "3", "value": "3"},
                        {"display": "4", "value": "4"},
                        {"display": "5", "value": "5"},
                        {"display": "6", "value": "6"},
                        {"display": "7", "value": "7"},
                        {"display": "8", "value": "8"},
                        {"display": "9", "value": "9"},
                        {"display": "10", "value": "10"},
                        {"display": "N/A", "value": "N/A"}
                      ],
                      textField: 'display',
                      valueField: 'value',
                      validator: (value) {
                        if (nbre_viande_femme == "") {
                          return 'Veuiller Slectionner un nombre';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    DropDownFormField(
                      titleText: 'Combien de fois dans la semaine vous mangez du riz/fonio ?',
                      hintText: 'Mange',
                      value: nbre_fonio_femme,
                      onSaved: (value) {
                        setState(() {
                          nbre_fonio_femme = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          nbre_fonio_femme = value;
                        });
                      },
                      dataSource: [
                        {"display": "1", "value": "1"},
                        {"display": "2", "value": "2"},
                        {"display": "3", "value": "3"},
                        {"display": "4", "value": "4"},
                        {"display": "5", "value": "5"},
                        {"display": "6", "value": "6"},
                        {"display": "7", "value": "7"},
                        {"display": "8", "value": "8"},
                        {"display": "9", "value": "9"},
                        {"display": "10", "value": "10"},
                        {"display": "N/A", "value": "N/A"}
                      ],
                      textField: 'display',
                      valueField: 'value',
                      validator: (value) {
                        if (nbre_fonio_femme == "") {
                          return 'Veuiller Slectionner un nombre';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    DropDownFormField(
                      titleText: 'D’où l’eau de boisson provient dans ta maison',
                      hintText: 'Eau',
                      value: _acces_eau_femme,
                      onSaved: (value) {
                        setState(() {
                          _acces_eau_femme = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _acces_eau_femme = value;
                        });
                      },
                      dataSource: [
                        {"display": "Eau de puit", "value": "Eau de puit"},
                        {"display": "Puit Local", "value": "Puit Local"},
                        {"display": "Puit Ameliore", "value": "Puit Ameliore"},
                        {"display": "Forage", "value": "Forage"},
                        {"display": "Autre", "value": "Autre"},
                      ],
                      textField: 'display',
                      valueField: 'value',
                      validator: (value) {
                        if (_acces_eau_femme == "") {
                          return 'Veuiller Slectionner une valeur';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    Visibility(
                      visible: eau,
                      child: Column(
                        children: [
                          TextFormField(
                            //keyboardType: TextInputType.number,
                            obscureText: false,
                            controller: _acces_eau_femme_autre,
                            decoration: InputDecoration(
                              //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              //icon: Icon(Icons.show_chart, color: Colors.blue),
                              hintText: "Chez vous, d'où l’eau de boisson provient ?",
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
                        ],
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xff01A0C7),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () async{
                          if (_formKey3.currentState.validate()) {
                            //verification
                            var _tab = await DB.initTabquery();

                            String idquestfemmegen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                            //
                            await DB.insert("quiz_femmeEnceinte", {
                              "id": idquestfemmegen,
                              "idpersonne": userInfo.id,
                              "quiz1": userInfo.status,
                              "quiz2": centre_sante,
                              "quiz3": nbre_repas_femme,
                              "quiz4": nbre_fruit_femme,
                              "quiz5": _nbre_legume_femme,
                              "quiz6": nbre_viande_femme,
                              "quiz7": nbre_fonio_femme,
                              "quiz8": _acces_eau_femme != "Autre" ? _acces_eau_femme : _acces_eau_femme_autre.text,//_acces_eau_femme.text,
                              "datequiz": date,
                              "typequiz": "Mensuel",
                              "flagtransmis": "",
                            });
                            setState(() {
                              centre_sante = '';
                              nbre_repas_femme = '';
                              nbre_fruit_femme = '';
                              _nbre_legume_femme = '';
                              nbre_viande_femme = '';
                              nbre_fonio_femme = '';
                              _acces_eau_femme_autre = TextEditingController()..text = '';
                              _acces_eau_femme = "";
                            });
                            Fluttertoast.showToast(
                                msg: "Enregistrement effectué avec succès !",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 20.0
                            );
                          }
                        },
                        child: Text("Enregistrer",
                          textAlign: TextAlign.center,),
                      ),
                    ),
                    SizedBox(height: 25.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

