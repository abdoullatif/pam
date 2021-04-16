
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:pam/database/database.dart';

class ModifStock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: stock(),
    );
  }
}

class stock extends StatefulWidget {
  @override
  _stockState createState() => _stockState();
}

class _stockState extends State<stock> {
  @override
  Widget build(BuildContext context) {
    //
    final _formKey4 = GlobalKey<FormState>();
    TextEditingController _stock = TextEditingController();
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();
    String id = ModalRoute.of(context).settings.arguments;

    //localite
    Future<void> Stock() async {
      List<Map<String, dynamic>> queryStock = await DB.querydetCult(id);
      return queryStock;
    }
    print(id);

    //
    return FutureBuilder(
        future: Stock(),
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

          _stock = TextEditingController()..text = snap[0]['QteStock'];

          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Form(
                key: _formKey4,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //SizedBox(height: 100.0),
                      Container(
                        //color: Colors.indigo,
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Modifier le stock",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      SizedBox(height: 25.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        controller: _stock,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                          hintText: "Modifier le stock",
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
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xff01A0C7),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () async{
                            if (_formKey4.currentState.validate()) {
                              //verification
                              var _tab = await DB.initTabquery();
                              //String iddetcultgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                              //insertion du nom de la tablette
                              await DB.updateCult("detenteur_culture", {
                                "QteStock": _stock.text,
                                "DateStock": date,
                                "flagtransmis": "",
                              },id);
                              setState(() {
                                _stock = TextEditingController()..text = '';
                              });
                              Scaffold
                                  .of(context)
                                  .showSnackBar(SnackBar(content: Text('Modification effectuer avec succes !')));
                            }
                          },
                          child: Text("Modifier le Stock",
                            textAlign: TextAlign.center,),
                        ),
                      ),
                      SizedBox(height: 25.0),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}

