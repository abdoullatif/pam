import 'dart:async';

import 'package:mysql1/mysql1.dart';


class DbOnline {

  //Variable
  static var conn;

  ///-------------------------------------------------------------------------------------------------------------------
  ///-------------------OPEN Connection --------------------------------------------------------------------------------
  ///-------------------------------------------------------------------------------------------------------------------
  static Future con() async {
    conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'pamgnsupport.com',
      port: 3407,
      user: 'pam_admin_db',
      db: 'pam',
      password: 'Tulip2020',
    ));
    if(conn != null){
      print("Connection reussi");
    } else {
      print("Echec de connection");
    }
  }

  ///------------------------------------------------------------------------------------------------------------------
  ///-------------------------------------Insertion--------------------------------------------------------------------
  ///------------------------------------------------------------------------------------------------------------------


  static setcommande (String idproduit,int quantite,String pu,int pt,String idadmin,String date_commande,String statuts,int idcommercant) async {
    var result  = await conn.query(
      'insert into commande (idproduit,quantite,pu,pt,idadmin,date_commande,statuts,idcommercant)values(?,?,?,?,?,?,?,?)',
      [idproduit,quantite,pu,pt,idadmin,date_commande,statuts,idcommercant]);
    return result;
  }



  ///------------------------------------------------------------------------------------------------------------------
  ///-------------------------------------Select--------------------------------------------------------------------
  ///------------------------------------------------------------------------------------------------------------------


  static Future getUser (String email) async => await conn.query(
      'select * from users where users.email_usr_pm=?', [email]
  );


  static Future getProduit () async => await conn.query(
    'select * from produits'
  );

  static Future getCommercant (int localite, String idproduit) async => await conn.query(
      'select users.id,users.name,users.prenom,contacte,users.localite,stock.idcommercant,stock.idproduit,stock.quantite from users,stock where users.id=stock.idcommercant AND users.localite=? AND stock.idproduit=?', [localite,idproduit]
  );

  static Future getHistorique (String idadmin) async => await conn.query(
      'select * from commande,produits,users where commande.idproduit=produits.idproduit and commande.idadmin=users.id and commande.statuts=\'livree\' and commande.idadmin=?',
    [idadmin]
  );

  static Future getCommandeEnvoyer (String id) async => await conn.query(
      'select commande.id as id_cmd,'
          'commande.idproduit,'
          'commande.idadmin,'
          'commande.quantite,'
          'commande.pu,commande.pt,'
          'commande.statuts,'
          'commande.date_commande,'
          'produits.idproduit,'
          'produits.designation,'
          'produits.pu,'
          'produits.image,users.id,users.name,users.prenom,users.contacte from commande,produits,users where commande.idproduit=produits.idproduit AND users.id=commande.idcommercant AND  commande.statuts in (\'0\',\'ok\',\'rejected\') AND commande.idadmin =?',
          [id]
  );

  static Future getCommandeAccepter (String id) async => await conn.query(
      'select commande.id as id_cmd,'
          'commande.idproduit,'
          'commande.idadmin,'
          'commande.quantite,'
          'commande.pu,commande.pt,'
          'commande.statuts,'
          'commande.date_commande,'
          'produits.idproduit,'
          'produits.designation,'
          'produits.pu,'
          'produits.image,users.id,users.name,users.prenom,users.contacte from commande,produits,users where commande.idproduit=produits.idproduit AND users.id=commande.idcommercant AND  commande.statuts=\'ok\' AND commande.idadmin =?',
      [id]
  );

  static Future getCommandeAccepterr (String idadmin) async => await conn.query(
      'select * from commande where commande.statuts=\'ok\' and commande.idadmin=?',
      [idadmin]
  );

  static Future getNombreCommandeAccepter (String idadmin) async => await conn.query(
      'select count(id) as nombrecommandeaccepter from commande where commande.statuts=\'ok\' and commande.idadmin=?',
      [idadmin]
  );

  static Future getCommandeRefuser (String idadmin) async => await conn.query(
      'select * from commande where commande.statuts=\'refuser\' and commande.idadmin=?',
      [idadmin]
  );


  ///------------------------------------------------------------------------------------------------------------------
  ///-------------------------------------update--------------------------------------------------------------------
  ///------------------------------------------------------------------------------------------------------------------

  static updateCommande (int idcommande) async {
    await conn.query('update commande set statuts=\'livree\' where commande.id = ?',[idcommande]);
  }

  ///------------------------------------------------------------------------------------------------------------------
  ///-------------------------------------DELECT-----------------------------------------------------------------------
  ///------------------------------------------------------------------------------------------------------------------



  static delectCommande (int idcommande) async {
    await conn.query('delete from commande  where commande.id = ?',[idcommande]);
  }


  ///------------------------------------------------------------------------------------------------------------------
  ///-------------------------------------Close CONNECTION-------------------------------------------------------------
  ///------------------------------------------------------------------------------------------------------------------

  static Future closeCon() async {
    await conn.close();
  }

}