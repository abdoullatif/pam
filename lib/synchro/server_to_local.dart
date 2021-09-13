import 'dart:async';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import 'package:mysql1/mysql1.dart';

class Synchro {
  Database db;
  Context context;
  String localPath;
  String onlinePath;
  String db_name_local;
  String user;
  String db_name_online;
  String online_ip;
  String online_link;
  String password;


  Synchro(
      String db_name_local,
      String localPath,
      String onlinePath,
      String user,
      String password,
      String db_name_online,
      online_ip,
      online_link) {
    // classe();
    this.localPath = localPath;
    this.onlinePath = onlinePath;
    this.db_name_local = db_name_local;
    this.user = user;
    this.password = password;
    this.db_name_online = db_name_online;
    this.online_ip = online_ip;
    this.online_link = online_link;

  }
  connect() async {
     try{
    //192.168.43.8
    //demo_asset_example.db
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, this.db_name_local);

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      print(databasesPath);
      print("error database");
      // Should happen only the first time you launch your application
      //print("Creating new copy from asset");

      // Make sure the parent directory exists
      // try {
     //await Directory(dirname(path)).create(recursive: true);
     // } catch (_) {}

      // Copy from asset
      // ByteData data = await rootBundle.load(join("asset", "sqlite.db"));
     //  List<int> bytes =
      // data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
     // await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening local database");

// open the database

      db = await openDatabase(path);
      //  var date = new DateTime.now().toString();

      // var dateParse = DateTime.parse(date);

      // var formattedDate =
      //  "${dateParse.year}-${dateParse.month}-${dateParse.day} ${dateParse.hour}:${dateParse.minute}:${dateParse.second}.${dateParse.millisecond}";

      // var finalDate = formattedDate.toString();

      List<Map> ids = await db.rawQuery('SELECT * FROM parametre');
      var counting;
      final conn = await MySqlConnection.connect(ConnectionSettings(
          host: this.online_ip,
          port: 3407,
          user: this.user,
          password: this.password,
          db: this.db_name_online));
      // int updateCount = await db.rawUpdate(
      //  'UPDATE `classe` SET  `flagtransmis`=? WHERE id=?', ['', 'lok']);
      //localite

      //final conn = await MySqlConnection.connect(ConnectionSettings(
      // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
      try{
        //vente

        //final conn = await MySqlConnection.connect(ConnectionSettings(
        // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
        var get_annee_scolaire_rows = await conn.query(
            'SELECT * FROM   annee_scolaire ',
            []);

        //var codification_update_time = "";
        // print("flagtransmis" + vente_update_time);
        counting = 0;
        for (var row in get_annee_scolaire_rows) {
          try{
            // print("new" + row['flagtransmis']);
            var id = row['id'];
            int exiting = Sqflite.firstIntValue(await db
                .rawQuery('SELECT COUNT(*) FROM annee_scolaire  where id=?', [id]));
            if (exiting != 0) {
              //update

            } else {
              //insert
              await db.rawQuery(
                  'INSERT INTO `annee_scolaire` (`id`, `description`) VALUES (?,?)',
                  [
                    row['id'],
                    row['description']

                  ]);
              counting++;
            }
          }catch(e){
            print("error from a row "+e.toString());
          }

        }
        //await db.rawQuery('DELETE FROM `vente` WHERE 1', []);
        // List<Map> svente = await db.rawQuery('SELECT * FROM vente');
        //print(svente);

        print('annee_scolaire ${counting}');
        //end quiz_femmeEnceinte
      }catch(e){
        print("error annee_scolaire "+e.toString());
      }


      try{


        //final conn = await MySqlConnection.connect(ConnectionSettings(
        // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
        var get_campagne_agricol_rows = await conn.query(
            'SELECT * FROM   campagne_agricol ',
            []);

        //var codification_update_time = "";
        // print("flagtransmis" + vente_update_time);
        counting = 0;
        for (var row in get_campagne_agricol_rows) {
          try{
            // print("new" + row['flagtransmis']);
            var id = row['id'];
            int exiting = Sqflite.firstIntValue(await db
                .rawQuery('SELECT COUNT(*) FROM campagne_agricol  where id=?', [id]));
            if (exiting != 0) {
              //update

            } else {
              //insert
              await db.rawQuery(
                  'INSERT INTO `campagne_agricol`(`id`, `description`) VALUES (?,?)',
                  [
                    row['id'],
                    row['description']

                  ]);
              counting++;
            }
          }catch(e){
            print("error from a row "+e.toString());
          }

        }
        //await db.rawQuery('DELETE FROM `vente` WHERE 1', []);
        // List<Map> svente = await db.rawQuery('SELECT * FROM vente');
        //print(svente);

        print('campagne_agricol ${counting}');
        //end quiz_femmeEnceinte
      }catch(e){
        print("error campagne_agricol "+e.toString());
      }

      try{
        var get_localite_rows = await conn.query('SELECT * FROM  localite  order by flagtransmis asc', []);

        //var codification_update_time = "";
        // print("flagtransmis" + localite_update_time);
        counting = 0;
        for (var row in get_localite_rows) {

       try{
         // print("new" + row['flagtransmis']);
          var id = row['id'];
          int exiting = Sqflite.firstIntValue(await db
              .rawQuery('SELECT COUNT(*) FROM localite  where id=?', [id]));
         // print(exiting.toString());
          if (exiting != 0) {
            //update
            List<Map> localite_update = await db.rawQuery(
                'SELECT * FROM localite   where id=?', [id]);
            var localite_update_time;
            if (localite_update.length == 0)
              localite_update_time = "";
            else
              localite_update_time = localite_update.first['flagtransmis'];
            if ((localite_update_time).toString().compareTo(row['flagtransmis']) <
                0) {
              counting++;
              print("update"+row['id'].toString());
              await db.rawUpdate(
                  'UPDATE `localite` SET `description`=?,`typelocalite`=?,`idtypelocalite`=?,`longitude`=?,`latitude`=?,`flagtransmis`=?  WHERE id=?',
                  [
                    row['description'],
                    row['typelocalite'],
                    row['idtypelocalite'],
                    row['longitude'],
                    row['latitude'],
                    row['flagtransmis'],
                    row['id']
                  ]);
            }
          } else {
           // print(row['id']);
            //insert
            print("insert");
            await db.rawQuery(
                'INSERT INTO `localite`(`id`, `description`, `typelocalite`, `idtypelocalite`, `longitude`, `latitude`, `flagtransmis`) VALUES (?,?,?,?,?,?,?)',
                [
                  row['id'],
                  row['description'],
                  row['typelocalite'],
                  row['idtypelocalite'],
                  row['longitude'],
                  row['latitude'],
                  row['flagtransmis']
                ]);
            counting++;
          }

        }catch(e){
        print("error from a row "+e.toString());
      }

        }
       //  await db.rawQuery('DELETE FROM `localite` WHERE 1', []);
        // List<Map> slocalite = await db.rawQuery('SELECT * FROM localite');
      // print(slocalite);

        print('localite ${counting}');
        //end localite
      }catch(e){
        print("error localité"+e.toString());
      }

      try{
        //langue

        //final conn = await MySqlConnection.connect(ConnectionSettings(
        // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
        var get_langue_rows = await conn.query('SELECT * FROM  langue  order by flagtransmis asc ', []);

        //var codification_update_time = "";
     //   print("flagtransmis" + langue_update_time);
        counting = 0;
        for (var row in get_langue_rows) {
               try{
            var id = row['id'];
            int exiting = Sqflite.firstIntValue(await db
                .rawQuery('SELECT COUNT(*) FROM langue  where id=?', [id]));
            if (exiting != 0) {
              //update
              List<Map> langue_update = await db.rawQuery(
                  'SELECT * FROM langue  where id=?', [id]);
              var langue_update_time;
              if (langue_update.length == 0)
                langue_update_time = "";
              else
                langue_update_time = langue_update.first['flagtransmis'];

              if ((langue_update_time).toString().compareTo(row['flagtransmis']) <
                  0) {
                counting++;
                print("new" + row['flagtransmis']);
                await db.rawUpdate(
                    'UPDATE `langue` SET `description`=?,`flagtransmis`=? WHERE id=?',
                    [row['description'], row['flagtransmis'], row['id']]);
              }
            } else {
              //insert
              await db.rawQuery(
                  'INSERT INTO `langue`(`id`, `description`, `flagtransmis`) VALUES (?,?,?)',
                  [row['id'], row['description'], row['flagtransmis']]);
              counting++;
            }

        }catch(e){
        print("error from a row "+e.toString());
      }

        }
        // await db.rawQuery('DELETE FROM `langue` WHERE 1', []);
        // List<Map> slangue = await db.rawQuery('SELECT * FROM langue');
       // print(slangue);

        print('langue ${counting}');
        //end langue
      }catch(e){
        print("error langue"+e.toString());
      }









      if (ids.first['locate'] != null && ids.first['locate']
          .toString()
          .isNotEmpty) {
        print(ids.first['locate'].toString());
        try{


          var results = await conn.query(
              'SELECT * FROM classe where (locate=? OR locate=?) order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //print("flagtransmis" + hh);
          counting = 0;
          for (var row in results) {
                try{
              var id = row['idclasse'];
              int exiting = Sqflite.firstIntValue(await db
                  .rawQuery('SELECT COUNT(*) FROM classe  where id=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> lastSynchro = await db.rawQuery(
                    'SELECT * FROM classe  where id=?', [id]);
                var hh;
                if (lastSynchro.length == 0)
                  hh = "";
                else
                  hh = lastSynchro.first['flagtransmis'];
                if ((hh).toString().compareTo(row['flagtransmis']) < 0) {
                  counting++;
                  print("new" + row['flagtransmis']);
                  await db.rawUpdate(
                      'UPDATE `classe` SET `idecole`=?,`idtypeniveau`=?, anneeScolaire=?,`flagtransmis`=? WHERE id=?',
                      [
                        row['idecole'],
                        row['idtypeniveau'],
                        row['anneeScolaire'],
                        row['flagtransmis'],
                        row['idclasse']
                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `classe` (id,`idecole`, `idtypeniveau`, anneeScolaire, `flagtransmis`) '
                        'VALUES (?,?,?,?,?)',
                    [
                      row['idclasse'],
                      row['idecole'],
                      row['idtypeniveau'],
                      row['anneeScolaire'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
          }catch(e){
          print("error from a row "+e.toString());
        }
          }
          //await db.rawQuery('DELETE FROM `classe` WHERE 1', []);
         //  List<Map> last = await db.rawQuery('SELECT * FROM classe ');
         //  print(last);

          print('classe ${counting}');

          //end classe
        }catch(e){
          print("error classe"+e.toString());
        }


        try{
          //codification

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_codification_rows =
          await conn.query('SELECT * FROM  codification order by flagtransmis asc', []);

          //var codification_update_time = "";
          // print("flagtransmis" + codification_update_time);
          counting = 0;
          for (var row in get_codification_rows) {
              try{
            var id = row['id_description'];
            int exiting = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT COUNT(*) FROM codification  where idcodification=?',
                [id]));
            if (exiting != 0) {
              //update
              List<Map> codification_update = await db.rawQuery(
                  'SELECT * FROM codification where idcodification=?',
                  [id]);
              var codification_update_time;
              if (codification_update.length == 0)
                codification_update_time = "";
              else
                codification_update_time = codification_update.first['flagtransmis'];

              if ((codification_update_time)
                  .toString()
                  .compareTo(row['flagtransmis']) <
                  0) {
                counting++;
                print("new" + row['flagtransmis']);
                await db.rawUpdate(
                    'UPDATE `codification` SET `entite`=?,`description`=?,`desc_crt`=?,`flagtransmis`=?,`categories`=? WHERE idcodification=?',
                    [
                      row['entite'],
                      row['description'],
                      row['desc_crt'],
                      row['flagtransmis'],
                      row['categories'],
                      row['id_description']
                    ]);
              }
            } else {
              //insert
              await db.rawQuery(
                  'INSERT INTO `codification`(`entite`, `idcodification`,'
                      ' `description`, `desc_crt`, `flagtransmis`, `categories`) VALUES (?,?,?,?,?,?)',
                  [
                    row['entite'],
                    row['id_description'],
                    row['description'],
                    row['desc_crt'],
                    row['flagtransmis'],
                    row['categories']
                  ]);
              counting++;
            }

          }catch(e){
          print("error from a row "+e.toString());
        }

          }
          // await db.rawQuery('DELETE FROM `codification` WHERE 1', []);
          // List<Map> scodification = await db.rawQuery('SELECT * FROM codification');
          // print(scodification);

          print('codification ${counting}');
          //end codification
        }catch(e){
          print("error codification"+e.toString());
        }



        try{

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_detenteur_culture_rows = await conn.query(
              'SELECT * FROM  detenteur_culture where (locate=? or locate=?) order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_culture_update_time);
          counting = 0;
          for (var row in get_detenteur_culture_rows) {
             try{
              var id = row['iddetenteur_culture'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM detenteur_culture  where id=? ', [id]));
              if (exiting != 0) {
                //update
                List<Map> detenteur_culture_update = await db.rawQuery(
                    'SELECT * FROM detenteur_culture   where id=? ', [id]);
                var detenteur_culture_update_time;
                if (detenteur_culture_update.length == 0)
                  detenteur_culture_update_time = "";
                else
                  detenteur_culture_update_time =
                  detenteur_culture_update.first['flagtransmis'];
                if ((detenteur_culture_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  if (detenteur_culture_update_time!='') {
                    print("update" + row['flagtransmis']);
                    await db.rawUpdate(
                        'UPDATE `detenteur_culture` SET `iddetenteur_plantation`=?,`datedebut`=?,`datefinprevu`=?,'
                            '`superficie`=?,  `idtypeculture`=?, `quantiteprevu`=?, `QteStock`=?, `DateStock`=?, campagneAgricol=?, `flagtransmis`=?  WHERE id=?',
                        [
                          row['iddetenteur_plantation'],
                          row['datedebut'],
                          row['datefinprevu'],
                          row['superficie'],
                          row['typeculture'],
                          row['quantiteprevu'],
                          row['QteStock'],
                          row['DateStock'],
                          row['campagneAgricol'],
                          row['flagtransmis'],
                          row['iddetenteur_culture']
                        ]);
                    counting++;
                  }
                }
              } else {
                //insert
                print("insert " + row['flagtransmis']);
                await db.rawQuery(
                    'INSERT INTO `detenteur_culture`(`id`, `iddetenteur_plantation`,'
                        '`datedebut`, `datefinprevu`, `superficie`, `idtypeculture`, `quantiteprevu`, `QteStock`, `DateStock`, campagneAgricol, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?,?,?,?)',
                    [
                      row['iddetenteur_culture'],
                      row['iddetenteur_plantation'],
                      row['datedebut'],
                      row['datefinprevu'],
                      row['superficie'],
                      row['typeculture'],
                      row['quantiteprevu'],
                      row['QteStock'],
                      row['DateStock'],
                      row['campagneAgricol'],
                      row['flagtransmis']
                    ]);
                counting++;
              }

          }catch(e){
          print("error from a row "+e.toString());
        }

          }
          //await db.rawQuery('DELETE FROM `detenteur_culture` WHERE 1', []);
          // List<Map> sdetenteur_culture =
          //  await db.rawQuery('SELECT * FROM detenteur_culture');
          // print(sdetenteur_culture);

          print('detenteur culture ${counting}');
        }catch(e){
          print("error detenteur culture "+e.toString());
        }

        //end detenteur culture
      try{


        //final conn = await MySqlConnection.connect(ConnectionSettings(
        // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
        var get_detenteur_plantation_rows = await conn.query(
            'SELECT * FROM  detenteur_plantation where (locate=? or locate=?) order by flagtransmis asc',
            [ids.first['locate'], 'all']);

        //var codification_update_time = "";
        // print("flagtransmis" + detenteur_plantation_update_time);
        counting = 0;
        for (var row in get_detenteur_plantation_rows) {
             try{
            var id = row['iddetenteur_plantation'];
            int exiting = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT COUNT(*) FROM detenteur_plantation  where id=?', [id]));
            if (exiting != 0) {
              //update
              List<Map> detenteur_plantation_update = await db.rawQuery(
                  'SELECT * FROM detenteur_plantation   where id=?', [id]);
              var detenteur_plantation_update_time;
              if (detenteur_plantation_update.length == 0)
                detenteur_plantation_update_time = "";
              else
                detenteur_plantation_update_time =
                detenteur_plantation_update.first['flagtransmis'];
              if ((detenteur_plantation_update_time)
                  .toString()
                  .compareTo(row['flagtransmis']) <
                  0) {
                counting++;
                print("new" + row['flagtransmis']);
                await db.rawUpdate(
                    'UPDATE `detenteur_plantation` SET `idplantation`=?,`idpersonne`=?,`flagtransmis`=?  WHERE id=?',
                    [
                      row['idplantation'],
                      row['idpersonne'],
                      row['flagtransmis'],
                      row['iddetenteur_plantation']
                    ]);
              }
            } else {
              //insert
              await db.rawQuery(
                  'INSERT INTO `detenteur_plantation`(id, idplantation, `idpersonne`, `flagtransmis`) VALUES (?,?,?,?)',
                  [
                    row['iddetenteur_plantation'],
                    row['idplantation'],
                    row['idpersonne'],
                    row['flagtransmis']
                  ]);
              counting++;
            }

        }catch(e){
        print("error from a row "+e.toString());
      }

        }
        //await db.rawQuery('DELETE FROM `detenteur_culture` WHERE 1', []);
        // List<Map> sdetenteur_culture =
        //   await db.rawQuery('SELECT * FROM detenteur_plantation');
        // print(sdetenteur_culture);

        print('detenteur plantation ${counting}');
        //end detenteur plantation

      }catch(e){
        print("error detenteur plantation "+e.toString());
      }
        //detenteur plantation
   try{
     //ecole

     //final conn = await MySqlConnection.connect(ConnectionSettings(
     // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
     var get_ecole_rows = await conn.query('SELECT * FROM  ecole order by flagtransmis asc', []);

     //var codification_update_time = "";
     // print("flagtransmis" + ecole_update_time);
     counting = 0;
     for (var row in get_ecole_rows) {
     try{
         // print("new" + row['flagtransmis']);
         var id = row['idecole'];
         int exiting = Sqflite.firstIntValue(await db
             .rawQuery('SELECT COUNT(*) FROM ecole  where id=?', [id]));
         if (exiting != 0) {
           //update
           List<Map> ecole_update = await db.rawQuery(
               'SELECT * FROM ecole where id=?', [id]);
           var ecole_update_time;
           if (ecole_update.length == 0)
             ecole_update_time = "";
           else
             ecole_update_time = ecole_update.first['flagtransmis'];
           if ((ecole_update_time).toString().compareTo(row['flagtransmis']) <
               0) {
             counting++;
             await db.rawUpdate(
                 'UPDATE `ecole` SET `idlocalite`=?,`idpersonne`=?,`nom_ecole`=?,`flagtransmis`=?  WHERE id=?',
                 [
                   row['idlocalite'],
                   row['idpersonne'],
                   row['nom_ecole'],
                   row['flagtransmis'],
                   row['idecole']
                 ]);
           }
         } else {
           //insert
           await db.rawQuery(
               'INSERT INTO `ecole`( `id`,`idlocalite`,  `idpersonne`, `nom_ecole`, `flagtransmis`) VALUES (?,?,?,?,?)',
               [
                 row['idecole'],
                 row['idlocalite'],
                 row['idpersonne'],
                 row['nom_ecole'],
                 row['flagtransmis']
               ]);
           counting++;
         }
     }catch(e){
     print("error from a row "+e.toString());
   }

     }
     // await db.rawQuery('DELETE FROM `ecole` WHERE 1', []);
     // List<Map> secole = await db.rawQuery('SELECT * FROM ecole');
     // print(secole);

     print('ecole ${counting}');
     //end ecole

   }catch(e){
       print("error ecole "+e.toString());
     }

        try{
          //grossesse

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_grossesse_rows = await conn.query(
              'SELECT * FROM  grossesse  where (locate=? or locate=?) order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + grossesse_update_time);
          counting = 0;
          for (var row in get_grossesse_rows) {
               try {
              var id = row['idgrossesse'];
              int exiting = Sqflite.firstIntValue(await db
                  .rawQuery('SELECT COUNT(*) FROM grossesse  where id=? ', [id]));
              if (exiting != 0) {
                List<Map> grossesse_update = await db.rawQuery(
                    'SELECT * FROM grossesse   where id=? ', [id]);
                var grossesse_update_time;
                if (grossesse_update.length == 0)
                  grossesse_update_time = "";
                else
                  grossesse_update_time = grossesse_update.first['flagtransmis'];
                if ((grossesse_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  print("locate " + grossesse_update_time);
                  if (grossesse_update_time!='') {
                    counting++;
                    print("update" + row['flagtransmis']);
                    await db.rawUpdate(
                        'UPDATE `grossesse` SET `idpersonne`=?, `status`=?, `ordre`=?, `flagtransmis`=?  WHERE id=?',
                        [
                          row['idpersonne'],
                          row['status'],
                          row['ordre'],
                          row['flagtransmis'],
                          row['idgrossesse']
                        ]);
                  }
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `grossesse`(`id`, `idpersonne`, `status`, ordre, `flagtransmis`) VALUES (?,?,?,?,?)',
                    [
                      row['idgrossesse'],
                      row['idpersonne'],
                      row['status'],
                      row['ordre'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
          }catch(e){
          print("error from a row "+e.toString());
        }

          }
          //await db.rawQuery('DELETE FROM `grossesse` WHERE 1', []);
          //List<Map> sgrossesse = await db.rawQuery('SELECT * FROM grossesse');
          // print(sgrossesse);

          print('grossesse ${counting}');


        }catch(e){
          print("error grossesse "+e.toString());
        }

     try{
       //inscription

       //final conn = await MySqlConnection.connect(ConnectionSettings(
       // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
       var get_inscription_rows = await conn.query(
           'SELECT * FROM  inscription  where (locate=? or locate=?)   order by flagtransmis asc',
           [ids.first['locate'], 'all']);

       //var codification_update_time = "";
       //  print("flagtransmis" + inscription_update_time);
       counting = 0;
       for (var row in get_inscription_rows) {
           try {
             int inscrit = Sqflite.firstIntValue(await db.rawQuery(
                 'SELECT COUNT(*) FROM inscription  where (idpersonne=? and anneeScolaire=?)', [row['idpersonne'],row['anneeScolaire']]));
             if (inscrit == 0) {
             var id = row['idinscription'];
             int exiting = Sqflite.firstIntValue(await db.rawQuery(
                 'SELECT COUNT(*) FROM inscription  where id=?', [id]));
             if (exiting != 0) {
               //update
               List<Map> inscription_update = await db.rawQuery(
                   'SELECT * FROM inscription  where id=?', [id]);
               var inscription_update_time;
               if (inscription_update.length == 0)
                 inscription_update_time = "";
               else
                 inscription_update_time =
                 inscription_update.first['flagtransmis'];
               if ((inscription_update_time)
                   .toString()
                   .compareTo(row['flagtransmis']) <
                   0) {
                 counting++;
                 print("new" + row['flagtransmis']);
                 await db.rawUpdate(
                     'UPDATE `inscription` SET `idpersonne`=?,`idclasse`=?,`idtypeannee`=?, anneeScolaire=?,`flagtransmis`=?  WHERE id=?',
                     [
                       row['idpersonne'],
                       row['idclasse'],
                       row['idtypeannee'],
                       row['anneeScolaire'],
                       row['flagtransmis'],
                       row['idinscription']
                     ]);
               }
             } else {
               //insert
               await db.rawQuery(
                   'INSERT INTO `inscription`(`id`, `idpersonne`, `idclasse`, `idtypeannee`, anneeScolaire, `flagtransmis`) VALUES (?,?,?,?,?,?)',
                   [
                     row['idinscription'],
                     row['idpersonne'],
                     row['idclasse'],
                     row['idtypeannee'],
                     row['anneeScolaire'],
                     row['flagtransmis']
                   ]);
               counting++;
             }
             }
           }catch(e){
             print("error from a row "+e.toString());
           }

       }
       //await db.rawQuery('DELETE FROM `inscription` WHERE 1', []);
       // List<Map> sinscription = await db.rawQuery('SELECT * FROM inscription');
       // print(sinscription);

       print('inscription ${counting}');
       //end inscription
      }catch(e){
       print("error inscription "+e.toString());
     }

        try {
          //personne

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_personne_rows = await conn.query(
              'SELECT * FROM  personne  where (locate=? or locate=?) order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + personne_update_time);
          counting = 0;
          for (var row in get_personne_rows) {
            try {
              var id = row['idpersonne'];
              int exiting = Sqflite.firstIntValue(await db
                  .rawQuery('SELECT COUNT(*) FROM personne  where id=?', [id]));
             // print("exist" + exiting.toString());
              if (exiting != 0) {
                //update
                List<Map> personne_update = await db.rawQuery(
                    'SELECT * FROM personne where id=?', [id]);
                var personne_update_time;
                if (personne_update.length == 0)
                  personne_update_time = "";
                else
                  personne_update_time = personne_update.first['flagtransmis'];

                if ((personne_update_time).toString().compareTo(
                    row['flagtransmis']) <
                    0) {
                  if (personne_update_time!='') {
                  print("downloading  image updaded..." +
                      row['nom']);

                  var imageName;
                  if (row['image'].toString().startsWith("\\"))
                    imageName =
                        row['image'].toString().replaceFirst(
                            new RegExp(r"\\"), "");
                  else
                    imageName = row['image'];
                  // print(imageName);
                  Response response = await Dio().download(
                      this.online_link + this.onlinePath + imageName,
                      this.localPath + imageName);
                  print("response" + response.statusCode.toString());
                  if (response.statusCode == 200) {
                    print("new" + row['flagtransmis']);

                    await db.rawUpdate(
                        'UPDATE `personne` SET `nom`=?,`prenom`=?,`date_naissance`=?,`idgenre`=?,`date_creation`=?,`iud`=?,'
                            ' `email`=?,`mdp`=?,`image`=?,`flagtransmis`=? WHERE id=?',
                        [
                          row['nom'],
                          row['prenom'],
                          row['date_naissance'],
                          row['idgenre'],
                          row['date_creation'],
                          row['iud'],
                          row['email'],
                          row['mdp'],
                          imageName,
                          row['flagtransmis'],
                          row['idpersonne']
                        ]);
                    counting++;
                  }
                }
                }
              } else {
                print("downloading personne  image..." + row['nom']);
                //insert
                var imageName;
                if (row['image'].toString().startsWith("\\"))
                  imageName =
                      row['image'].toString().replaceFirst(
                          new RegExp(r"\\"), "");
                else
                  imageName = row['image'];
                // print(imageName);
                Dio dio = new Dio();
                print(this.online_link + this.onlinePath + imageName);
                (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
                    (HttpClient client) {
                  client.badCertificateCallback =
                      (X509Certificate cert, String host, int port) => true;
                  return client;
                };
                Response response = await Dio().download(
                    this.online_link + this.onlinePath + imageName,
                    this.localPath + imageName);
                print("response" + response.statusCode.toString());
                if (response.statusCode == 200) {

                  print("new" + row['flagtransmis']);
                  await db.rawQuery(
                      'INSERT INTO `personne`(`id`,`nom`, `prenom`, `date_naissance`, `idgenre`, '
                          ' `date_creation`, `iud`, `email`, `mdp`, `image`, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?,?,?,?)',
                      [
                        row['idpersonne'],
                        row['nom'],
                        row['prenom'],
                        row['date_naissance'],
                        row['idgenre'],
                        row['date_creation'],
                        row['iud'],
                        row['email'],
                        row['mdp'],
                        imageName,
                        row['flagtransmis']
                      ]);
                  counting++;
                }
              }
            }catch(e){
              print('personne error from a row '+e.toString());
            }
            // await db.rawQuery('DELETE FROM `personne` WHERE 1', []);
            // List<Map> spersonne = await db.rawQuery('SELECT * FROM personne');
            //print(spersonne);


          }


          print('personne ${counting}');
          //end personne

        }catch(e){
          print("error personne "+e.toString());
        }

        try{

          //personne_adresse

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_personne_adresse_rows = await conn.query(
              'SELECT * FROM  personne_adresse  where (locate=? or locate=?) order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + personne_adresse_update_time);
          counting = 0;
          for (var row in get_personne_adresse_rows) {
               try{
              var id = row['idpersonne_adresse'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM personne_adresse  where id=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> personne_adresse_update = await db.rawQuery(
                    'SELECT * FROM personne_adresse   where id=?', [id]);
                var personne_adresse_update_time;
                if (personne_adresse_update.length == 0)
                  personne_adresse_update_time = "";
                else
                  personne_adresse_update_time =
                  personne_adresse_update.first['flagtransmis'];
                if ((personne_adresse_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  print("new" + row['flagtransmis']);
                  await db.rawUpdate(
                      'UPDATE `personne_adresse` SET `idpersonne`=?,`idlocalite`=?,`adresse`=?,`flagtransmis`=? WHERE id=?',
                      [
                        row['idpersonne'],
                        row['idlocalite'],
                        row['adresse'],
                        row['flagtransmis'],
                        row['idpersonne_adresse']
                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `personne_adresse`(id,`idpersonne`, `idlocalite`, `adresse`, `flagtransmis`) VALUES (?,?,?,?,?)',
                    [
                      row['idpersonne_adresse'],
                      row['idpersonne'],
                      row['idlocalite'],
                      row['adresse'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
               }catch(e){
                 print("error from a row "+e.toString());
               }

          }
          // await db.rawQuery('DELETE FROM `personne_adresse` WHERE 1', []);
          //List<Map> spersonne_adresse =
          // await db.rawQuery('SELECT * FROM personne_adresse');
          //print(spersonne_adresse);

          print('personne_adresse ${counting}');
          //end personne adresse

        }catch(e){
          print("error personne_adresse "+e.toString());
        }




      try{
        //personne_fonction

        //final conn = await MySqlConnection.connect(ConnectionSettings(
        // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
        var get_personne_fonction_rows = await conn.query(
            'SELECT * FROM  personne_fonction  where (locate=? or locate=?)  order by flagtransmis asc',
            [ids.first['locate'], 'all']);

        //var codification_update_time = "";
        //print("flagtransmis" + personne_fonction_update_time);
        counting = 0;
        for (var row in get_personne_fonction_rows) {
           try{
            var id = row['idpersonne_fonction'];
            int exiting = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT COUNT(*) FROM personne_fonction  where id=?', [id]));
            if (exiting != 0) {
              //update
              List<Map> personne_fonction_update = await db.rawQuery(
                  'SELECT * FROM personne_fonction   where id=?', [id]);
              var personne_fonction_update_time;
              if (personne_fonction_update.length == 0)
                personne_fonction_update_time = "";
              else
                personne_fonction_update_time =
                personne_fonction_update.first['flagtransmis'];
              if ((personne_fonction_update_time)
                  .toString()
                  .compareTo(row['flagtransmis']) <
                  0) {
                counting++;
                print("new" + row['flagtransmis']);
              await db.rawUpdate(
                  'UPDATE `personne_fonction` SET `idpersonne`=?, `idtypefonction`=?,`flagtransmis`=? WHERE id=?',
                  [
                    row['idpersonne'],
                    row['idtypefonction'],
                    row['flagtransmis'],
                    row['idpersonne_fonction']
                  ]);
            }
            } else {
              //insert
              await db.rawQuery(
                  'INSERT INTO `personne_fonction`(`id`, `idpersonne`,  `idtypefonction`, `flagtransmis`) VALUES (?,?,?,?)',
                  [
                    row['idpersonne_fonction'],
                    row['idpersonne'],
                    row['idtypefonction'],
                    row['flagtransmis']
                  ]);
              counting++;
            }
           }catch(e){
             print("error from a row "+e.toString());
           }
        }
        //await db.rawQuery('DELETE FROM `personne_fonction` WHERE 1', []);
        // List<Map> spersonne_fonction =
        // await db.rawQuery('SELECT * FROM personne_fonction');
        //print(spersonne_fonction);

        print('personne_fonction ${counting}');
        //end personne_fonction


      }catch(e){
       print("error personne_fonction "+e.toString());
     }

    try{
      //personne_tel

      //final conn = await MySqlConnection.connect(ConnectionSettings(
      // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
      var get_personne_tel_rows = await conn.query(
          'SELECT * FROM  personne_tel  where (locate=? or locate=?) order by flagtransmis asc',
          [ids.first['locate'], 'all']);

      //var codification_update_time = "";
      // print("flagtransmis" + personne_tel_update_time);
      counting = 0;
      for (var row in get_personne_tel_rows) {
             try{
          var id = row['idpersonne_tel'];
          int exiting = Sqflite.firstIntValue(await db.rawQuery(
              'SELECT COUNT(*) FROM personne_tel  where id=?', [id]));
          if (exiting != 0) {
            //update
            List<Map> personne_tel_update = await db.rawQuery(
                'SELECT * FROM personne_tel  where id=?', [id]);
            var personne_tel_update_time;
            if (personne_tel_update.length == 0)
              personne_tel_update_time = "";
            else
              personne_tel_update_time = personne_tel_update.first['flagtransmis'];
            if ((personne_tel_update_time)
                .toString()
                .compareTo(row['flagtransmis']) <
                0) {
              counting++;
              print("new" + row['flagtransmis']);
              await db.rawUpdate(
                  'UPDATE `personne_tel` SET `idpersonne`=?,`numero_tel`=?,`flagtransmis`=? WHERE id=?',
                  [
                    row['idpersonne'],
                    row['numero_tel'],
                    row['flagtransmis'],
                    row['idpersonne_tel']
                  ]);
            }
          } else {
            //insert
            await db.rawQuery(
                'INSERT INTO `personne_tel`(`id`, `idpersonne`,  `numero_tel`, `flagtransmis`) VALUES (?,?,?,?)',
                [
                  row['idpersonne_tel'],
                  row['idpersonne'],
                  row['numero_tel'],
                  row['flagtransmis']
                ]);
            counting++;
          }
             }catch(e){
               print("error from a row "+e.toString());
             }

      }
      // await db.rawQuery('DELETE FROM `personne_tel` WHERE 1', []);
      // List<Map> spersonne_tel = await db.rawQuery('SELECT * FROM personne_tel');
      // print(spersonne_tel);

      print('personne_tel ${counting}');
      //end personne_tel

    }catch(e){
       print("error personne_tel "+e.toString());
     }

      try{
        //plantation

        //final conn = await MySqlConnection.connect(ConnectionSettings(
        // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
        var get_plantation_rows = await conn.query(
            'SELECT * FROM  plantation  where (locate=? or locate=?) order by flagtransmis asc',
            [ids.first['locate'], 'all']);

        //var codification_update_time = "";
        //print("flagtransmis" + plantation_update_time);
        counting = 0;
        for (var row in get_plantation_rows) {
            try{
            var id = row['idplantation'];
            int exiting = Sqflite.firstIntValue(await db
                .rawQuery('SELECT COUNT(*) FROM plantation  where id=?', [id]));
            if (exiting != 0) {
              //update
              List<Map> plantation_update = await db.rawQuery(
                  'SELECT * FROM plantation  where id=?', [id]);
              var plantation_update_time;
              if (plantation_update.length == 0)
                plantation_update_time = "";
              else
                plantation_update_time = plantation_update.first['flagtransmis'];
              if ((plantation_update_time)
                  .toString()
                  .compareTo(row['flagtransmis']) <
                  0) {
                counting++;
                print("new" + row['flagtransmis']);

                await db.rawUpdate(
                    'UPDATE `plantation` SET `description`=?,`superficie`=?,`idlocalite`=?,`observation`=?,'
                        '`flagtransmis`=?,`groupement`=?,`longitude`=?,`latitude`=?,`nbre_femme`=?,`nbre_homme`=?,`nbre_membre`=?,`agreement`=?  WHERE id=?',
                    [
                      row['description'],

                      row['superficie'],
                      row['idlocalite'],
                      row['observation'],
                      row['flagtransmis'],
                      row['groupement'],
                      row['longitude'],
                      row['latitude'],
                      row['nbre_femme'],
                      row['nbre_homme'],
                      row['nbre_membre'],
                      row['agreement'],
                      row['idplantation']
                    ]);
              }
            } else {
              //insert

              await db.rawQuery(
                  'INSERT INTO `plantation`(`id`,`description`,  `superficie`, `idlocalite`, `observation`,'
                      ' `flagtransmis`, `groupement`, `longitude`, `latitude`, nbre_femme, nbre_homme, nbre_membre,agreement) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
                  [
                    row['idplantation'],
                    row['description'],

                    row['superficie'],
                    row['idlocalite'],
                    row['observation'],
                    row['flagtransmis'],
                    row['groupement'],
                    row['longitude'],
                    row['latitude'],
                   row['nbre_femme'],
                   row['nbre_homme'],
                  row['nbre_membre'],
                    row['agreement']
                  ]);
              counting++;
            }

            }catch(e){
              print("error from a row "+e.toString());
            }

        }
        //await db.rawQuery('DELETE FROM `plantation` WHERE 1', []);
        //List<Map> splantation = await db.rawQuery('SELECT * FROM plantation');
        // print(splantation);

        print('plantation ${counting}');
        //end plantation
      }catch(e){
       print("error plantation "+e.toString());
     }


     try{
       //suivit_grossesse

       //final conn = await MySqlConnection.connect(ConnectionSettings(
       // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
       var get_suivit_grossesse_rows = await conn.query(
           'SELECT * FROM  suivit_grossesse  where (locate=? or locate=?) order by flagtransmis asc',
           [ids.first['locate'], 'all']);

       //var codification_update_time = "";
       //print("flagtransmis" + suivit_grossesse_update_time);
       counting = 0;
       for (var row in get_suivit_grossesse_rows) {
            try {
              var id = row['idsuivit_grossesse'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM suivit_grossesse  where id=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> suivit_grossesse_update = await db.rawQuery(
                    'SELECT * FROM suivit_grossesse where  id=?', [id]);
                var suivit_grossesse_update_time;
                if (suivit_grossesse_update.length == 0)
                  suivit_grossesse_update_time = "";
                else
                  suivit_grossesse_update_time =
                  suivit_grossesse_update.first['flagtransmis'];
                if ((suivit_grossesse_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  print("new" + row['flagtransmis']);
                  await db.rawUpdate(
                      'UPDATE `suivit_grossesse` SET `idgrossesse`=?,`idpersonne`=?,`datesuivit`=?,`poids`=?,`taille`=?,'
                          '`pb`=?,`imc`=?,`status`=?,`flagtransmis`=?  WHERE id=?',
                      [
                        row['idgrossesse'],
                        row['idpersonne'],
                        row['datesuivit'],
                        row['poids'],
                        row['taille'],
                        row['pb'],
                        row['imc'],
                        row['status'],
                        row['flagtransmis'],
                        row['idsuivit_grossesse']
                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `suivit_grossesse`(`id`, `idgrossesse`, `idpersonne`, `datesuivit`, `poids`,'
                        ' `taille`, `pb`, `imc`, `status`, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?,?,?)',
                    [
                      row['idsuivit_grossesse'],
                      row['idgrossesse'],
                      row['idpersonne'],
                      row['datesuivit'],
                      row['poids'],
                      row['taille'],
                      row['pb'],
                      row['imc'],
                      row['status'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
            }catch(e){
              print("error from a row "+e.toString());
            }

       }
       // await db.rawQuery('DELETE FROM `suivit_grossesse` WHERE 1', []);
       // List<Map> ssuivit_grossesse =
       //  await db.rawQuery('SELECT * FROM suivit_grossesse');
       //  print(ssuivit_grossesse);

       print('suivit_grossesse ${counting}');
       //end suivit_grossesse

     }catch(e){
       print("error suivit_grossesse "+e.toString());
     }

        try{
          //suivit_repas

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_suivit_repas_rows = await conn.query(
              'SELECT * FROM  suivit_repas  where (locate=? or locate=?) order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + suivit_repas_update_time);
          counting = 0;
          for (var row in get_suivit_repas_rows) {
               try{
              // print("new" + row['flagtransmis']);
              var id = row['id'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM suivit_repas  where id=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> suivit_repas_update = await db.rawQuery(
                    'SELECT * FROM suivit_repas  where id=?  ', [id]);

                var suivit_repas_update_time;
                if (suivit_repas_update.length == 0)
                  suivit_repas_update_time = "";
                else
                  suivit_repas_update_time = suivit_repas_update.first['flagtransmis'];

                if ((suivit_repas_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  if(suivit_repas_update_time!='') {
                    counting++;
                    await db.rawUpdate(
                        'UPDATE `suivit_repas` SET `idpersonne`=?,`present`=?,`manger`=?,`date`=?,`nbscan`=?, anneeScolaire=?,`flagtransmis`=?  WHERE (id=? and flagtransmis<>"")',
                        [
                          row['idpersonne'],
                          row['present'],
                          row['manger'],
                          row['date'],
                          row['nbscan'],
                          row['anneeScolaire'],
                          row['flagtransmis'],
                          row['id']
                        ]);
                  }
              }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `suivit_repas`(`id`, `idpersonne`, `present`, `manger`, `date`, `nbscan`, anneeScolaire, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?)',
                    [
                      row['id'],
                      row['idpersonne'],
                      row['present'],
                      row['manger'],
                      row['date'],
                      row['nbscan'],
                      row['anneeScolaire'],
                      row['flagtransmis']
                    ]);
              }
               }catch(e){
                 print("error from a row "+e.toString());
               }

          }
          //await db.rawQuery('DELETE FROM `suivit_repas` WHERE 1', []);
          // List<Map> ssuivit_repas = await db.rawQuery('SELECT * FROM suivit_repas');
          // print(ssuivit_repas);

          print('suivit_repas ${counting}');
          //end suivit_repas
        }catch(e){
          print("error suivit_repas "+e.toString());
        }

        try{

          //suivit_poids_eleve

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_suivit_poids_eleve_rows = await conn.query(
              'SELECT * FROM  suivit_poids_eleve  where (locate=? or locate=?)  order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          //print("flagtransmis" + suivit_poids_eleve_update_time);
          counting = 0;
          for (var row in get_suivit_poids_eleve_rows) {
              try{
              var id = row['id'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM suivit_poids_eleve  where id=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> suivit_poids_eleve_update = await db.rawQuery(
                    'SELECT * FROM suivit_poids_eleve  where id=? ', [id]);
                var suivit_poids_eleve_update_time;
                if (suivit_poids_eleve_update.length == 0)
                  suivit_poids_eleve_update_time = "";
                else
                  suivit_poids_eleve_update_time =
                  suivit_poids_eleve_update.first['flagtransmis'];
                if ((suivit_poids_eleve_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  print("new" + row['flagtransmis']);
                  await db.rawUpdate(
                      'UPDATE `suivit_poids_eleve` SET `idpersonne`=?,idecole=?,`datesuivit`=?,`poids`=?, `taille`=?, anneeScolaire=?,`flagtransmis`=? WHERE id=?',
                      [
                        row['idpersonne'],
                        row['idecole'],
                        row['datesuivit'],
                        row['poids'],
                        row['taille'],
                        row['anneeScolaire'],
                        row['flagtransmis'],
                        row['id']
                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `suivit_poids_eleve`(`id`, `idpersonne`,idecole, `datesuivit`, `poids`, taille, anneeScolaire, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?)',
                    [
                      row['id'],
                      row['idpersonne'],
                      row['idecole'],
                      row['datesuivit'].toString(),
                      row['poids'],
                      row['taille'],
                      row['anneeScolaire'],
                      row['flagtransmis']
                    ]);
              }
              }catch(e){
                print("error from a row "+e.toString());
              }

          }
          //await db.rawQuery('DELETE FROM `suivit_poids_eleve` WHERE 1', []);
          // List<Map> ssuivit_poids_eleve =
          //  await db.rawQuery('SELECT * FROM suivit_poids_eleve');
          // print(ssuivit_poids_eleve);

          print('suivit_poids_eleve ${counting}');
          //end suivit_poids_eleve

        }catch(e){
          print("error suivit_poids_eleve "+e.toString());
        }


        try{
          //vente

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_vente_rows = await conn.query(
              'SELECT * FROM  vente  where (locate=? or locate=?) order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + vente_update_time);
          counting = 0;
          for (var row in get_vente_rows) {
              try{
              // print("new" + row['flagtransmis']);
              var id = row['id'];
              int exiting = Sqflite.firstIntValue(await db
                  .rawQuery('SELECT COUNT(*) FROM vente  where id=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> vente_update = await db.rawQuery(
                    'SELECT * FROM vente   where id=?', [id]);
                var vente_update_time;
                if (vente_update.length == 0)
                  vente_update_time = "";
                else
                  vente_update_time = vente_update.first['flagtransmis'];
                if ((vente_update_time).toString().compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `vente` SET `idagent`=?,`iduser`=?,`qtevendu`=?,`iddetenteur_culture`=?,`datevente`=?,`prixvente`=?, code_recu=?,`flagtransmis`=? WHERE id=?',
                      [
                        row['idagent'],
                        row['iduser'],
                        row['qtevendu'],
                        row['iddetenteur_culture'],
                        row['datevente'],
                        row['prixvente'],
                        row['code_recu'],
                        row['flagtransmis'],
                        row['id']
                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `vente`(`id`, `idagent`, `iduser`, `qtevendu`, `iddetenteur_culture`,'
                        ' `datevente`, `prixvente`, code_recu, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?,?)',
                    [
                      row['id'],
                      row['idagent'],
                      row['iduser'],
                      row['qtevendu'],
                      row['iddetenteur_culture'],
                      row['datevente'],
                      row['prixvente'],
                      row['code_recu'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
              }catch(e){
                print("error from a row "+e.toString());
              }

          }
          //await db.rawQuery('DELETE FROM `vente` WHERE 1', []);
          // List<Map> svente = await db.rawQuery('SELECT * FROM vente');
          //print(svente);

          print('vente ${counting}');
          //end vente
        }catch(e){
          print("error vente "+e.toString());
        }


        //get children
        try{


          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_enfant_rows = await conn.query(
              'SELECT * FROM  enfant  where (locate=? or locate=?) order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + vente_update_time);
          counting = 0;
          for (var row in get_enfant_rows) {
            try{
              // print("new" + row['flagtransmis']);
              var id = row['idEnfant'];
              int exiting = Sqflite.firstIntValue(await db
                  .rawQuery('SELECT COUNT(*) FROM enfant  where id=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> enfant_update = await db.rawQuery(
                    'SELECT * FROM enfant   where id=?', [id]);
                var enfant_update_time;
                if (enfant_update.length == 0)
                  enfant_update_time = "";
                else
                  enfant_update_time = enfant_update.first['flagtransmis'];
                if ((enfant_update_time).toString().compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `enfant` SET `nom`=?,`prenom`=?,`sexe`=?,`dateNaissance`=?,`idgrossesse`=?,`date_limit`=?,`flagtransmis`=? WHERE id=?',
                      [
                        row['nom'],
                        row['prenom'],
                        row['sexe'],
                        row['dateNaissance'],
                        row['idgrossesse'],
                        row['date_limit'],
                        row['flagtransmis'],
                        row['idEnfant']
                      ]);
                }
              } else {


                //insert
                await db.rawQuery(
                    'INSERT INTO `enfant`(`id`, `nom`, `prenom`, `sexe`, `dateNaissance`,'
                        ' `idgrossesse`, `date_limit`,  `flagtransmis`) VALUES (?,?,?,?,?,?,?,?)',
                    [
                      row['idEnfant'],
                      row['nom'],
                      row['prenom'],
                      row['sexe'],
                      row['dateNaissance'],
                      row['idgrossesse'],
                      row['date_limit'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
            }catch(e){
              print("error from a row "+e.toString());
            }

          }
          //await db.rawQuery('DELETE FROM `vente` WHERE 1', []);
          // List<Map> svente = await db.rawQuery('SELECT * FROM vente');
          //print(svente);

          print('enfant ${counting}');
          //end vente
        }catch(e){
          print("error enfant "+e.toString());
        }


        try{

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_suivit_enfant_rows = await conn.query(
              'SELECT * FROM  suivit_enfant  where (locate=? or locate=?) order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + vente_update_time);
          counting = 0;
          for (var row in get_suivit_enfant_rows) {
            try{
              // print("new" + row['flagtransmis']);
              var id = row['idSuivitEnfant'];
              int exiting = Sqflite.firstIntValue(await db
                  .rawQuery('SELECT COUNT(*) FROM suivit_enfant  where id=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> suivit_enfant_update = await db.rawQuery(
                    'SELECT * FROM suivit_enfant   where id=?', [id]);
                var suivit_enfant_update_time;
                if (suivit_enfant_update.length == 0)
                  suivit_enfant_update_time = "";
                else
                  suivit_enfant_update_time = suivit_enfant_update.first['flagtransmis'];
                if ((suivit_enfant_update_time).toString().compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `suivit_enfant` SET idEnfant,`poids`=?,`taille`=?,`dateSuivit`=?,`flagtransmis`=? WHERE id=?',
                      [
                        row['idEnfant'],
                        row['poids'],
                        row['taille'],
                        row['dateSuivit'],
                        row['flagtransmis'],
                        row['idSuivitEnfant']
                      ]);
                }
              } else {




                //insert
                await db.rawQuery(
                    'INSERT INTO `suivit_enfant`(`id`,idEnfant, `poids`, `taille`, `dateSuivit`, `flagtransmis`) VALUES (?,?,?,?,?,?)',
                    [
                      row['idSuivitEnfant'],
                      row['idEnfant'],
                      row['poids'],
                      row['taille'],
                      row['dateSuivit'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
            }catch(e){
              print("error from a row "+e.toString());
            }

          }

          print('suivit_enfant ${counting}');
          //end vente
        }catch(e){
          print("error suivit_enfant "+e.toString());
        }


   /*
        try{
          //vente

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_quiz_eleve_rows = await conn.query(
              'SELECT * FROM  quiz_eleve  where (locate=? or locate=?) order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + vente_update_time);
          counting = 0;
          for (var row in get_quiz_eleve_rows) {
            try{
              // print("new" + row['flagtransmis']);
              var id = row['id'];
              int exiting = Sqflite.firstIntValue(await db
                  .rawQuery('SELECT COUNT(*) FROM quiz_eleve  where id=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> quiz_eleve_update = await db.rawQuery(
                    'SELECT * FROM quiz_eleve   where id=?', [id]);
                var quiz_eleve_update_time;
                if (quiz_eleve_update.length == 0)
                  quiz_eleve_update_time = "";
                else
                  quiz_eleve_update_time = quiz_eleve_update.first['flagtransmis'];
                if ((quiz_eleve_update_time).toString().compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `quiz_eleve` SET `idpersonne`=?,`quiz1`=?,`quiz2`=?,`quiz3`=?,`quiz4`=?,`quiz5`=?, quiz6=?, `quiz7`=?,`datequiz`=?, typequiz=?, anneeScolaire=?,`flagtransmis`=? WHERE id=?',
                      [

                        row['idpersonne'],
                        row['quiz1'],
                        row['quiz2'],
                        row['quiz3'],
                        row['quiz4'],
                        row['quiz5'],
                        row['quiz6'],
                        row['quiz7'],
                        row['datequiz'],
                        row['typequiz'],
                        row['anneeScolaire'],
                        row['flagtransmis'],
                        row['id']
                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `quiz_eleve`(`id`, `idpersonne`, `quiz1`, `quiz2`, `quiz3`,'
                        ' `quiz4`, `quiz5`, quiz6,`quiz7`, `datequiz`, typequiz, anneeScolaire, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
                    [
                      row['id'],
                      row['idpersonne'],
                      row['quiz1'],
                      row['quiz2'],
                      row['quiz3'],
                      row['quiz4'],
                      row['quiz5'],
                      row['quiz6'],
                      row['quiz7'],
                      row['datequiz'],
                      row['typequiz'],
                      row['anneeScolaire'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
            }catch(e){
              print("error from a row "+e.toString());
            }

          }
          //await db.rawQuery('DELETE FROM `vente` WHERE 1', []);
          // List<Map> svente = await db.rawQuery('SELECT * FROM vente');
          //print(svente);

          print('quiz_eleve ${counting}');
          //end quiz_eleve
        }catch(e){
          print("error quiz_eleve "+e.toString());
        }


        try{
          //vente

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_quiz_femmeEnceinte_rows = await conn.query(
              'SELECT * FROM  quiz_femmeEnceinte  where (locate=? or locate=?) order by flagtransmis asc',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + vente_update_time);
          counting = 0;
          for (var row in get_quiz_femmeEnceinte_rows) {
            try{
              // print("new" + row['flagtransmis']);
              var id = row['id'];
              int exiting = Sqflite.firstIntValue(await db
                  .rawQuery('SELECT COUNT(*) FROM quiz_femmeEnceinte  where id=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> quiz_femmeEnceinte_update = await db.rawQuery(
                    'SELECT * FROM quiz_femmeEnceinte   where id=?', [id]);
                var quiz_femmeEnceinte_update_time;
                if (quiz_femmeEnceinte_update.length == 0)
                  quiz_femmeEnceinte_update_time = "";
                else
                  quiz_femmeEnceinte_update_time = quiz_femmeEnceinte_update.first['flagtransmis'];
                if ((quiz_femmeEnceinte_update_time).toString().compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `quiz_femmeEnceinte` SET `idpersonne`=?,`quiz1`=?,`quiz2`=?,`quiz3`=?,`quiz4`=?,`quiz5`=?, quiz6=?, `quiz7`=?, `quiz8`=?,`datequiz`=?, typequiz=?,`flagtransmis`=? WHERE id=?',
                      [

                        row['idpersonne'],
                        row['quiz1'],
                        row['quiz2'],
                        row['quiz3'],
                        row['quiz4'],
                        row['quiz5'],
                        row['quiz6'],
                        row['quiz7'],
                        row['quiz8'],
                        row['datequiz'],
                        row['typequiz'],
                        row['flagtransmis'],
                        row['id']
                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `quiz_femmeEnceinte`(`id`, `idpersonne`, `quiz1`, `quiz2`, `quiz3`,'
                        ' `quiz4`, `quiz5`, quiz6,`quiz7`,`quiz8`, `datequiz`, typequiz, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
                    [
                      row['id'],
                      row['idpersonne'],
                      row['quiz1'],
                      row['quiz2'],
                      row['quiz3'],
                      row['quiz4'],
                      row['quiz5'],
                      row['quiz6'],
                      row['quiz7'],
                      row['quiz8'],
                      row['datequiz'],
                      row['typequiz'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
            }catch(e){
              print("error from a row "+e.toString());
            }

          }
          //await db.rawQuery('DELETE FROM `vente` WHERE 1', []);
          // List<Map> svente = await db.rawQuery('SELECT * FROM vente');
          //print(svente);

          print('quiz_femmeEnceinte ${counting}');
          //end quiz_femmeEnceinte
        }catch(e){
          print("error quiz_femmeEnceinte "+e.toString());
        }
        */







        // int updateCount = await db.rawUpdate(
        //  'UPDATE `classe` SET  `flagtransmis`=? WHERE id=?', ['', 'lok']);
        print("local to server start");
        //classe
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
        final String finalDate = formatter.format(now);
        print(finalDate);
        var count = 0;



        try{
          List<Map> list =
          await db.rawQuery('SELECT * FROM classe where flagtransmis=""');
          //print(list);


          for (var row in list) {
            try{
            var results = await conn.query(
                'INSERT INTO `classe`(`idecole`, `idclasse`, `idtypeniveau`, anneeScolaire, `flagtransmis`, `locate`) '
                    'VALUES (?,?,?,?,?,?)',
                [
                  row['idecole'],
                  row['id'],
                  row['idtypeniveau'],
                  row['anneeScolaire'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate('UPDATE `classe` SET  `flagtransmis`=? WHERE id=?',
                [finalDate, row['id']]);
            count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('classe${count}');
          //end classe

        }catch(e){
          print("local to server error "+e.toString());

        }

        try{
          //detenteur culture
          List<Map> detenteur_culture = await db
              .rawQuery('SELECT * FROM detenteur_culture where flagtransmis=""');
          // print(detenteur_culture);
          count = 0;

          for (var row in detenteur_culture) {
            try{
              var id = row['id'];
              var exiting=  await conn.query(
                  'SELECT * FROM detenteur_culture  where iddetenteur_culture=? ' , [id]);
              print( "existing"+exiting.length.toString());
              if (exiting.length!= 0) {
                await conn.query(
                    'UPDATE `detenteur_culture` SET `iddetenteur_plantation`=?,`datedebut`=?,`datefinprevu`=?,`superficie`=?,`typeculture`=?,`quantiteprevu`=?,`QteStock`=?,`DateStock`=?, campagneAgricol=?,`flagtransmis`=?  WHERE iddetenteur_culture=? ',
                    [

                      row['iddetenteur_plantation'],
                      row['datedebut'],
                      row['datefinprevu'],
                      row['superficie'],
                      row['idtypeculture'],
                      row['Quantiteprevu'],
                      row['QteStock'],
                      row['DateStock'],
                      row['campagneAgricol'],
                      finalDate,
                      row['id']
                    ]);
                await db.rawUpdate(
                    'UPDATE `detenteur_culture` SET  `flagtransmis`=? WHERE id=?',
                    [finalDate, row['id']]);
                count++;
              } else {
                await conn.query(
                    'INSERT INTO `detenteur_culture`( `iddetenteur_culture`, `iddetenteur_plantation`, `datedebut`, `datefinprevu`,'
                        ' `superficie`, `typeculture`, `quantiteprevu`, `QteStock`,`DateStock`, campagneAgricol, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
                    [
                      row['id'],
                      row['iddetenteur_plantation'],
                      row['datedebut'],
                      row['datefinprevu'],
                      row['superficie'],
                      row['idtypeculture'],
                      row['Quantiteprevu'],
                      row['QteStock'],
                      row['DateStock'],
                      row['campagneAgricol'],
                      finalDate,
                      ids.first['locate']
                    ]);

                await db.rawUpdate(
                    'UPDATE `detenteur_culture` SET  `flagtransmis`=? WHERE id=?',
                    [finalDate, row['id']]);
                count++;
              }
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('detenteur culture ${count}');
          //end detenteur culture

        }catch(e){
          print("local to server error "+e.toString());
        }
        try{

          //detenteur plantation
          List<Map> detenteur_plantation = await db.rawQuery(
              'SELECT * FROM detenteur_plantation where flagtransmis=""');
          // print(detenteur_plantation);
          count = 0;

          for (var row in detenteur_plantation) {
            try{
            await conn.query(
                'INSERT INTO `detenteur_plantation`( `iddetenteur_plantation`, `idplantation`,'
                    ' `idpersonne`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?)',
                [
                  row['id'],
                  row['idplantation'],
                  row['idpersonne'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `detenteur_plantation` SET  `flagtransmis`=? WHERE id=?',
                [finalDate, row['id']]);
            count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('detenteur plantation ${count}');
          //end detenteur plantation

        }catch(e){
          print("local to server error "+e);
        }
        try{
          //grossesse
          List<Map> grossesse =
          await db.rawQuery('SELECT * FROM grossesse where flagtransmis=""');
          //print(grossesse);
          count = 0;

          for (var row in grossesse) {

            try {
              var id = row['id'];
              var exiting=  await conn.query(
                  'SELECT * FROM grossesse  where idgrossesse=?'  , [id]);
              print( "existing"+exiting.length.toString());
              if (exiting.length!= 0) {
                print("update");
                await conn.query(
                    'UPDATE `grossesse` SET `idpersonne`=?,`status`=?,`ordre`=?,`flagtransmis`=?  WHERE idgrossesse=? ',
                    [

                      row['idpersonne'],
                      row['status'],
                      row['ordre'],
                      finalDate,
                      row['id']
                    ]);
                count++;
                await db.rawUpdate(
                    'UPDATE `grossesse` SET  `flagtransmis`=? WHERE id=?',
                    [finalDate, row['id']]);
              } else {
                print("insert");
              await conn.query(
                  'INSERT INTO `grossesse`(`idgrossesse`, `idpersonne`, `status`, ordre, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?)',
                  [
                    row['id'],
                    row['idpersonne'],
                    row['status'],
                    row['ordre'],
                    finalDate,
                    ids.first['locate']
                  ]);

              await db.rawUpdate(
                  'UPDATE `grossesse` SET  `flagtransmis`=? WHERE id=?',
                  [finalDate, row['id']]);
              count++;
            }
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('grossesse ${count}');
          //end grossesse

        }catch(e){
          print("local to server error "+e.toString());
        }

        try{
          //inscription
          List<Map> inscription = await db
              .rawQuery('SELECT * FROM inscription where flagtransmis=""');
          // print(inscription);
          count = 0;

          for (var row in inscription) {
            try{

              var exiting=  await conn.query(
                  'SELECT * FROM inscription  where (idpersonne=? and anneeScolaire=?)'  , [row['idpersonne'],row['anneeScolaire']]);
              print( "existing"+exiting.length.toString());
              if (exiting.length== 0) {
            await conn.query(
                'INSERT INTO `inscription`( `idinscription`, `idpersonne`, `idclasse`,'
                    '`idtypeannee`,anneeScolaire , `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?,?)',
                [
                  row['id'],
                  row['idpersonne'],
                  row['idclasse'],
                  row['idtypeannee'],
                  row['anneeScolaire'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `inscription` SET  `flagtransmis`=? WHERE id=?',
                [finalDate, row['id']]);
            count++;
              }
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('inscription ${count}');
          //end inscription


        }catch(e){
          print("local to server error "+e.toString());
        }

        try{

          //personne
          List<Map> personne =
          await db.rawQuery('SELECT * FROM personne where flagtransmis=""');
          //print(personne);
          count = 0;
          for (var row in personne) {

            try {
              var id = row['id'];
              var exiting=  await conn.query(
                  'SELECT * FROM personne  where idpersonne=?'  , [id]);
              print( "existing"+exiting.length.toString());
              if (exiting.length!= 0) {
                print("update");
                await conn.query(
                    'UPDATE `personne` SET `mdp`=?,`flagtransmis`=?  WHERE idpersonne=? ',
                    [
                      row['mdp'],
                      finalDate,
                      row['id'],

                    ]);
                await conn.query(
                    'UPDATE `users` SET `mdp_usr_pm`=?  WHERE email_usr_pm=? ',
                    [
                      row['mdp'],
                      row['email']

                    ]);
                count++;
                await db.rawUpdate(
                    'UPDATE `personne` SET  `flagtransmis`=? WHERE id=?',
                    [finalDate, row['id']]);
              }
              else{
              final dio = Dio();

              dio.options.headers = {
                'Content-Type': 'application/x-www-form-urlencoded'
              };
              print(this.localPath);
              // Directory appDocDirectory = await getApplicationDocumentsDirectory();
              final file = await MultipartFile.fromFile(
                  this.localPath + row['image'],
                  filename: row['image']);

              final formData = FormData.fromMap({
                'file': file,
                'online_path': this.onlinePath
              }); // 'file' - this is an api key, can be different
              print(this.online_link);
              var response = await dio.post(
                // or dio.post
                  this.online_link + "upload.php",
                  data: formData,
                  options:
                  Options(contentType: Headers.formUrlEncodedContentType));
              // print("response " + response.);

              if (response.statusCode == 200) {
                await conn.query(
                    'INSERT INTO `personne`(`idpersonne`, `nom`, `prenom`, `date_naissance`, `idgenre`,'
                        ' `date_creation`, `iud`, `email`, `mdp`, `image`, `flagtransmis`, `locate`)'
                        'VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
                    [
                      row['id'],
                      row['nom'],
                      row['prenom'],
                      row['date_naissance'],
                      row['idgenre'],
                      row['date_creation'],
                      row['iud'],
                      row['email'],
                      row['mdp'],
                      row['image'],
                      finalDate,
                      ids.first['locate']
                    ]);

                await db.rawUpdate(
                    'UPDATE `personne` SET  `flagtransmis`=? WHERE id=?',
                    [finalDate, row['id']]);
                count++;
              }
            }
            } catch (err) {
              print('uploading error: $err');
            }
          }
          // await db.rawQuery('DELETE FROM `personne` WHERE 1', []);
          print('personne ${count}');
          //end personne

        }catch(e){
          print("local to server error "+e.toString());
        }


       try{

         //personne_adresse
         List<Map> personne_adresse = await db
             .rawQuery('SELECT * FROM personne_adresse where flagtransmis=""');
         //print(personne_adresse);
         count = 0;

         for (var row in personne_adresse) {
           try{
           await conn.query(
               'INSERT INTO `personne_adresse`( `idpersonne`, `idpersonne_adresse`, `idlocalite`,'
                   ' `adresse`, `flagtransmis`,  `locate`) VALUES (?,?,?,?,?,?)',
               [
                 row['idpersonne'],
                 row['id'],
                 row['idlocalite'],
                 row['adresse'],
                 finalDate,
                 ids.first['locate']
               ]);

           await db.rawUpdate(
               'UPDATE `personne_adresse` SET  `flagtransmis`=? WHERE id=?',
               [finalDate, row['id']]);
           count++;
           }catch(e){
             print("error from a row "+e.toString());
           }
         }

         print('personne adresse ${count}');
         //end personne adresse

       }catch(e){
         print("local to server error "+e.toString());
       }


        try{

          List<Map> personne_fonction = await db
              .rawQuery('SELECT * FROM personne_fonction where flagtransmis=""');
          //print(personne_fonction);
          count = 0;

          for (var row in personne_fonction) {
            try{
            await conn.query(
                'INSERT INTO `personne_fonction`( `idpersonne`, `idpersonne_fonction`,'
                    ' `idtypefonction`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?)',
                [
                  row['idpersonne'],
                  row['id'],
                  row['idtypefonction'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `personne_fonction` SET  `flagtransmis`=? WHERE id=?',
                [finalDate, row['id']]);
            count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('personne_fonction ${count}');
          //end personne_fonction

        }catch(e){
          print("local to server error "+e.toString());
        }


        try{
          //personne_tel
          List<Map> personne_tel = await db
              .rawQuery('SELECT * FROM personne_tel where flagtransmis=""');
          // print(personne_tel);
          count = 0;

          for (var row in personne_tel) {
            try{
            await conn.query(
                'INSERT INTO `personne_tel`(`idpersonne`, `idpersonne_tel`, `numero_tel`,'
                    ' `flagtransmis`, `locate`) VALUES (?,?,?,?,?)',
                [
                  row['idpersonne'],
                  row['id'],
                  row['numero_tel'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `personne_tel` SET  `flagtransmis`=? WHERE id=?',
                [finalDate, row['id']]);
            count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('personne_tel ${count}');

          //end personne_tel

        }catch(e){
          print("local to server error "+e.toString());
        }

        try{

          //plantation
          List<Map> plantation =
          await db.rawQuery('SELECT * FROM plantation where flagtransmis=""');
          //  print(plantation);
          count = 0;

          for (var row in plantation) {
            try{

            await conn.query(
                'INSERT INTO `plantation`(`idplantation`, `description`, `superficie`,'
                    '`idlocalite`, `observation`, `flagtransmis`, `locate`, `groupement`,'
                    ' `longitude`, `latitude`, nbre_femme, nbre_homme, nbre_membre,agreement) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
                [
                  row['id'],
                  row['description'],

                  row['superficie'],
                  row['idlocalite'],
                  row['observation'],
                  finalDate,
                  ids.first['locate'],
                  row['groupement'],
                  row['longitude'],
                  row['latitude'],
                  row['nbre_femme'],
                  row['nbre_homme'],
                  row['nbre_membre'],
                  row['agreement']
                ]);

            await db.rawUpdate(
                'UPDATE `plantation` SET  `flagtransmis`=? WHERE id=?',
                [finalDate, row['id']]);
            count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('plantation ${count}');
          //end plantation

        }catch(e){
          print("local to server error "+e);
        }

        try{
          //plantation
          List<Map> suivit_grossesse = await db
              .rawQuery('SELECT * FROM suivit_grossesse where flagtransmis=""');
          //print(suivit_grossesse);
          count = 0;

          for (var row in suivit_grossesse) {
            try{
            await conn.query(
                'INSERT INTO `suivit_grossesse`(`idsuivit_grossesse`, `idgrossesse`, `idpersonne`,'
                    '`datesuivit`, `poids`, `taille`, `pb`, `imc`, `flagtransmis`,'
                    ' `locate`) VALUES (?,?,?,?,?,?,?,?,?,?)',
                [
                  row['id'],
                  row['idgrossesse'],
                  row['idpersonne'],
                  row['datesuivit'],
                  row['poids'],
                  row['taille'],
                  row['pb'],
                  row['imc'],
                  finalDate,
                  ids.first['locate'],
                ]);

            await db.rawUpdate(
                'UPDATE `suivit_grossesse` SET  `flagtransmis`=? WHERE id=?',
                [finalDate, row['id']]);
            count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('suivit_grossesse ${count}');
          //end suivit_grossesse

        }catch(e){
          print("local to server error "+e.toString());
        }

        try{

          List<Map> suivit_repas = await db
              .rawQuery('SELECT * FROM suivit_repas where flagtransmis=""');

          //var codification_update_time = "";
          // print("flagtransmis" + suivit_repas_update_time);
          counting = 0;
          for (var row in suivit_repas) {
              try{
            counting++;
            // print("new" + row['flagtransmis']);
            var id = row['id'];
            var exiting=  await conn.query(
                'SELECT * FROM suivit_repas  where id=? ' , [id]);
            print( "existing"+exiting.length.toString());
            if (exiting.length!= 0) {
              await conn.query(
                  'UPDATE `suivit_repas` SET `present`=?,`manger`=?,`date`=?,`nbscan`=?, anneeScolaire=?,`flagtransmis`=?  WHERE id=? ',
                  [

                  row['present'],
                  row['manger'],
              row['date'],
              row['nbscan'],
                    row['anneeScolaire'],
              //update
                    finalDate,
                    row['id']
                  ]);
              await db.rawUpdate(
                  'UPDATE `suivit_repas` SET  `flagtransmis`=? WHERE id=?',
                  [finalDate, row['id']]);
            } else {
              //insert
              await conn.query(
                  'INSERT INTO `suivit_repas`(`id`, `idpersonne`, `present`, `manger`, `date`,'
                      ' `nbscan`, anneeScolaire, `flagtransmis`,`locate`) VALUES (?,?,?,?,?,?,?,?,?)',
                  [
                    row['id'],
                    row['idpersonne'],
                    row['present'],
                    row['manger'],
                    row['date'],
                    row['nbscan'],
                    row['anneeScolaire'],
                    finalDate,
                    ids.first['locate'],
                  ]);

              await db.rawUpdate(
                  'UPDATE `suivit_repas` SET  `flagtransmis`=? WHERE id=?',
                  [finalDate, row['id']]);
            }

              }catch(e){
                print("error from a row "+e.toString());
              }

          }
          //await db.rawQuery('DELETE FROM `suivit_repas` WHERE 1', []);
          // List<Map> ssuivit_repas = await db.rawQuery('SELECT * FROM suivit_repas');
          // print(ssuivit_repas);

          print('suivit_repas ${counting}');

        }catch(e){
          print("local to server error "+e.toString());
        }

        try{
          //vente
          List<Map> vente =
          await db.rawQuery('SELECT * FROM vente where flagtransmis=""');
          //print(vente);
          count = 0;

          for (var row in vente) {
            try{
            await conn.query(
                'INSERT INTO `vente`(id, `idagent`, `iduser`, `qtevendu`, `iddetenteur_culture`,'
                    '`datevente`, `prixvente`, code_recu, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?,?,?,?,?)',
                [
                  row['id'],
                  row['idagent'],
                  row['iduser'],
                  row['qtevendu'],
                  row['iddetenteur_culture'],
                  row['datevente'],
                  row['prixvente'],
                  row['code_recu'],
                  finalDate,
                  ids.first['locate'],
                ]);

            await db.rawUpdate('UPDATE `vente` SET  `flagtransmis`=? WHERE id=?',
                [finalDate, row['id']]);
            count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('vente ${count}');
          //end vente

        }catch(e){
          print("local to server error "+e.toString());
        }


        try{

          List<Map> suivit_poids_eleve = await db
              .rawQuery('SELECT * FROM suivit_poids_eleve where flagtransmis=""');
          //print(vente);
          count = 0;

          for (var row in suivit_poids_eleve) {
            try{
            await conn.query(
                'INSERT INTO `suivit_poids_eleve`(`id`, `idpersonne`,idecole, `datesuivit`, `poids`,taille, anneeScolaire, `flagtransmis`,locate) VALUES (?,?,?,?,?,?,?,?)',
                [
                  row['id'],
                  row['idpersonne'],
                  row['idecole'],
                  row['datesuivit'],
                  row['poids'],
                  row['taille'],
                  row['anneeScolaire'],
                  finalDate,
                  ids.first['locate'],
                ]);

            await db.rawUpdate(
                'UPDATE `suivit_poids_eleve` SET  `flagtransmis`=? WHERE id=?',
                [finalDate, row['id']]);
            count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('suivit_poids_eleve ${count}');
          //end suivit_poids_eleve

        }catch(e){
          print("local to server error "+e.toString());
        }



        try{

          List<Map> quiz_eleve = await db
              .rawQuery('SELECT * FROM quiz_eleve where flagtransmis=""');
          //print(vente);
          count = 0;

          for (var row in quiz_eleve) {
            try{
              await conn.query(
                  'INSERT INTO `quiz_eleve`(`id`, `idecole`,quiz1, `quiz2`, `quiz3`, quiz4, `quiz5`, `quiz6`,quiz7, `datequiz`, `typequiz`, anneeScolaire, `flagtransmis`,locate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
                  [
                    row['id'],
                    row['idecole'],
                    row['quiz1'],
                    row['quiz2'],
                    row['quiz3'],
                    row['quiz4'],
                    row['quiz5'],
                    row['quiz6'],
                    row['quiz7'],
                    row['datequiz'],
                    row['typequiz'],
                    row['anneeScolaire'],
                    finalDate,
                    ids.first['locate'],
                  ]);

              await db.rawUpdate(
                  'UPDATE `quiz_eleve` SET  `flagtransmis`=? WHERE id=?',
                  [finalDate, row['id']]);
              count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('quiz_eleve ${count}');
          //end quiz_eleve

        }catch(e){
          print("local to server error "+e.toString());
        }

        try{

          List<Map> quiz_femmeEnceinte = await db
              .rawQuery('SELECT * FROM quiz_femmeEnceinte where flagtransmis=""');
          //print(vente);
          count = 0;

          for (var row in quiz_femmeEnceinte) {
            try{
              await conn.query(
                  'INSERT INTO `quiz_femmeEnceinte`(`id`, `idpersonne`,quiz1, `quiz2`, `quiz3`, quiz4, `quiz5`, `quiz6`,quiz7,quiz8, `datequiz`, `typequiz`, `flagtransmis`,locate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
                  [
                    row['id'],
                    row['idpersonne'],
                    row['quiz1'],
                    row['quiz2'],
                    row['quiz3'],
                    row['quiz4'],
                    row['quiz5'],
                    row['quiz6'],
                    row['quiz7'],
                    row['quiz8'],
                    row['datequiz'],
                    row['typequiz'],
                    finalDate,
                    ids.first['locate'],
                  ]);

              await db.rawUpdate(
                  'UPDATE `quiz_femmeEnceinte` SET  `flagtransmis`=? WHERE id=?',
                  [finalDate, row['id']]);
              count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('quiz_femmeEnceinte ${count}');
          //end quiz_femmeEnceinte


        }catch(e){
          print("local to server error "+e.toString());
        }



        try{

          List<Map> enfant = await db
              .rawQuery('SELECT * FROM enfant where flagtransmis=""');

          count = 0;

          for (var row in enfant) {
            try{


              await conn.query(
                  'INSERT INTO `enfant`(`idEnfant`, `nom`,prenom, `sexe`, `dateNaissance`, idgrossesse, `date_limit`,  `flagtransmis`,locate) VALUES (?,?,?,?,?,?,?,?,?)',
                  [
                    row['id'],
                    row['nom'],
                    row['prenom'],
                    row['sexe'],
                    row['dateNaissance'],
                    row['idgrossesse'],
                    row['date_limit'],

                    finalDate,
                    ids.first['locate'],
                  ]);

              await db.rawUpdate(
                  'UPDATE `enfant` SET  `flagtransmis`=? WHERE id=?',
                  [finalDate, row['id']]);
              count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('enfant ${count}');
          //end enfant

        }catch(e){
          print("local to server error "+e.toString());
        }


        try{

          List<Map> suivit_enfant = await db
              .rawQuery('SELECT * FROM suivit_enfant where flagtransmis=""');

          count = 0;

          for (var row in suivit_enfant) {
            try{


              await conn.query(
                  'INSERT INTO `suivit_enfant`(`idSuivitEnfant`,idEnfant, `poids`,taille, `dateSuivit`, `flagtransmis`,locate) VALUES (?,?,?,?,?,?,?)',
                  [
                    row['id'],
                    row['idEnfant'],
                    row['poids'],
                    row['taille'],
                    row['dateSuivit'],
                    finalDate,
                    ids.first['locate'],
                  ]);


              await db.rawUpdate(
                  'UPDATE `suivit_enfant` SET  `flagtransmis`=? WHERE id=?',
                  [finalDate, row['id']]);
              count++;
            }catch(e){
              print("error from a row "+e.toString());
            }
          }

          print('suivit_enfant ${count}');
          //end enfant

        }catch(e){
          print("local to server error "+e.toString());
        }

      }
      await conn.close();
    }

    }catch(e){
       print("error from synchro table"+e.toString());

     }finally{
       //Duration temps = new Duration(hours:0, minutes:1, seconds:00);

       Future.delayed(const Duration(seconds: 300),()=> connect());
     }

  }
  //Duration temps = new Duration(hours:0, minutes:1, seconds:00);
  synchronize() {


      connect();


  }
}
