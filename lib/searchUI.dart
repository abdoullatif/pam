import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pam/database/database.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/main.dart';
import 'package:pam/model/searchControl.dart';

import 'components/userPannel.dart';

class SearchUI extends SearchDelegate<String> {
  //asynchrone
  var id_dg = StorageUtil.getString("idpersonne");
  var idtypefonction = StorageUtil.getString("idtypefonction");

  Future<List> _operation(String input) async{
    if(idtypefonction == "DG"){
      List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
      var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
      List<Map<String, dynamic>> queryRows = await DB.querySearch(_locate[0]["id"].toString(),input,id_dg);
      return queryRows;
    } else if (idtypefonction == "AA"){
      List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
      var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
      List<Map<String, dynamic>> queryRows = await DB.querySearchAgri(_locate[0]["id"].toString(),input);
      return queryRows;
    } else if (idtypefonction == "AFE"){
      List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
      var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
      List<Map<String, dynamic>> queryRows = await DB.querySearchFem(_locate[0]["id"].toString(),input);
      return queryRows;
    } else {}

  }

  @override
  List<Widget> buildActions(BuildContext context) {
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context,null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column(
      children: [
        Text('just a test!'),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    String data = query;
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List>(
            stream: Stream.fromFuture(_operation(data)),
              builder: (context, snap){
              if(snap.hasData) {
                List currentItems = snap.data;
                switch (snap.connectionState) {
                  case ConnectionState.waiting:
                    return Container();
                  default:
                    if (snap.hasError) {
                      return Text('Une erreur c\'est produite');
                    } else {
                      return CustomScrollView(
                        shrinkWrap: true,
                        slivers: [
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return idtypefonction == "DG" ?
                                      Card(
                                      margin: EdgeInsets.only(top: 25.0,),
                                      elevation: 2.0,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.transparent,
                                          backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${currentItems[index]["image"]}')),
                                          //backgroundImage: Image.file(file),
                                        ),
                                        title: Text('${currentItems[index]["nom"]} ${currentItems[index]["prenom"]}'),
                                        subtitle: Text('${currentItems[index]["classe"]}'),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUser(),settings: RouteSettings(arguments: '${currentItems[index]["idpersonne"]}')),);
                                        },
                                      ),
                                    ) :
                                    idtypefonction == "AA" ?
                                    Card(
                                      margin: EdgeInsets.only(top: 25.0,),
                                      elevation: 2.0,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.transparent,
                                          backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${currentItems[index]["image"]}')),
                                          //backgroundImage: Image.file(file),
                                        ),
                                        title: Text('${currentItems[index]["nom"]} ${currentItems[index]["prenom"]}'),
                                        subtitle: Text('${currentItems[index]["fonction"]}'),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUser(),settings: RouteSettings(arguments: '${currentItems[index]["idpersonne"]}')),);
                                        },
                                      ),
                                    ) :
                                    idtypefonction == "AFE" ?
                                    Card(
                                      margin: EdgeInsets.only(top: 25.0,),
                                      elevation: 2.0,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.transparent,
                                          backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/${currentItems[index]["image"]}')),
                                          //backgroundImage: Image.file(file),
                                        ),
                                        title: Text('${currentItems[index]["nom"]} ${currentItems[index]["prenom"]}'),
                                        subtitle: Text('${currentItems[index]["idtypefonction"]}'),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUser(),settings: RouteSettings(arguments: '${currentItems[index]["idpersonne"]}')),);
                                        },
                                      ),
                                    ) : Container();
                                  },
                                childCount: currentItems.length ?? 0,
                              )
                          )
                        ],
                      );
                    }
                }
              }
              else if(query == ""){
                return Column();
              }
              return Container();
              }
          )
        ],
      ),
    );
  }



}