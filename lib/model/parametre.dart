
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Param {
  //Data devise
  static String device;
  static String adresse_server;
  static String dbname;
  static String ip_server;
  static String site_commercant;
  static String site_pam;
  static String user;
  static String mdp;

  //Data Notification
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //{this.device,this.adresse_server,this.dbname,this.ip_server,this.site_commercant,this.site_pam,this.user,this.mdp}
  //: device = device, adresse_server = adresseServer, dbname = dbname, ip_server = ip_server
  //   site_commercant = site_commercant, site_pam = site_pam, user = user, mdp = mdp

  //Param(device, adresseServer, dbname, ip_server, site_commercant, site_pam, user, mdp) ;

}
