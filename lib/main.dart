//package
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//
import 'dart:async';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:connectivity/connectivity.dart';
import 'package:pam/database/storageUtil.dart';
import 'package:pam/database/database.dart';
import 'package:pam/model/parametre.dart';
import 'package:pam/page&widget/adminWindows.dart';
import 'package:pam/page&widget/agricultureWindows.dart';
import 'package:pam/page&widget/alimentationWindows.dart';
import 'package:pam/page&widget/homePage.dart';
import 'package:pam/page&widget/loginPage.dart';
import 'package:pam/services/notification_service.dart';
//Synchronisation
import 'package:pam/synchro/server_to_local.dart';
import 'package:pam/synchro/records.dart';
import 'package:pam/synchro/Videos.dart';
//
import 'database/database_online.dart';
import 'page&widget/slider.dart';

//bad certificate correction
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

//Variable de synchronisation
var synchronisation;
var records;
var videos;

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  //Notification
  await Param.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await NotificationService().initNotifications(Param.flutterLocalNotificationsPlugin);
  NotificationService().requestIOSPermissions(Param.flutterLocalNotificationsPlugin);
  //
  await DB.init();
  await StorageUtil.getInstance();
  //Key and encrypt
  final key = encrypt.Key.fromUtf8('Tulip_Ind*SuperCleSecreteBySooba');
  final iv = encrypt.IV.fromLength(16);
  //Encrypt
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  //Recuperation des donnees dans la tablette
  List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
  if(tab.isNotEmpty){
    //Decryptage
    final device_decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(tab[0]['device']), iv: iv);
    final adresse_server_decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(tab[0]['adresse_server']), iv: iv);
    final dbname_decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(tab[0]['dbname']), iv: iv);
    final ip_server_decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(tab[0]['ip_server']), iv: iv);
    final site_pam_decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(tab[0]['site_pam']), iv: iv);
    final site_commercant_decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(tab[0]['site_commercant']), iv: iv);
    final user_decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(tab[0]['user']), iv: iv);
    final mdp_decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(tab[0]['mdp']), iv: iv);
    //Parametre
    Param.device = device_decrypted;
    Param.adresse_server = adresse_server_decrypted;
    Param.dbname = dbname_decrypted;
    Param.ip_server = ip_server_decrypted;
    Param.site_pam = site_pam_decrypted;
    Param.site_commercant = site_commercant_decrypted;
    Param.user = user_decrypted;
    Param.mdp = mdp_decrypted;
    //Initialisation Synchronize
    synchronisation = Synchro("/data/user/0/com.tulipind.pam/databasespamdb",
        "/storage/emulated/0/Android/data/com.tulipind.pam/files/Pictures/"
        ,"uploads/",user_decrypted,mdp_decrypted,dbname_decrypted,ip_server_decrypted,adresse_server_decrypted);
    //Synchronisation des records
    records = Records("/data/user/0/com.tulipind.pam/databasespamdb",
        "/storage/emulated/0/Android/data/com.tulipind.pam/files/"
        ,"vocal/",user_decrypted,mdp_decrypted,dbname_decrypted,ip_server_decrypted,adresse_server_decrypted);
    //Synchronisation des videos
    videos = Videos("/data/user/0/com.tulipind.pam/databasespamdb",
        "/storage/emulated/0/Android/data/com.tulipind.pam/files/Video/"
        ,"uploads/",user_decrypted,mdp_decrypted,dbname_decrypted,ip_server_decrypted,adresse_server_decrypted);
    //Execute synchro
    synchronisation.synchronize();
    records.synchronize();
    videos.synchronize();
  } else {print("No parametre connection !");}
  //Systeme
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight,DeviceOrientation.landscapeLeft]).then((_){
    runApp(PamApp());
  });
  //
  //DbOnline.con();
  //
  HttpOverrides.global = new MyHttpOverrides();
}

//Dection Connectivity
synchrData() async {
  //
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network.
    print("Debut de la synchronisation apres 5 minutes via mobile");
    synchronisation.synchronize();
    records.synchronize();
    //videos.synchronize();
  }
  else if (connectivityResult == ConnectivityResult.wifi) {
    print("Debut de la synchronisation wifi");
    synchronisation.synchronize();
    records.synchronize();
    //videos.synchronize();
  }
}

class PamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'PAM',
      theme: new ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      //home: Home(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/' : (BuildContext context) => SafeArea(child: Home()),
        '/admin' : (BuildContext context) => SafeArea(child: AdminWindows()),
        '/login' : (BuildContext context) => SafeArea(child: PageLogin()),
        '/Acceuil' : (BuildContext context) => SafeArea(child: Acceuil()),
        '/agriculture' : (BuildContext context) => SafeArea(child: AgricultureWindows()),
        '/alimentation' : (BuildContext context) => SafeArea(child: AlimentationWindows()),
      },

    );
  }
}


