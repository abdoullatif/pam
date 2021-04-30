import 'package:flutter/material.dart';
import 'package:pam/database/database.dart';

class UserControl{
  //personne
  String idpersonne;
  String nom;
  String prenom;
  String date_naissance;
  String idgenre;
  String date_creation;
  String iud;
  String email;
  String mdp;
  String image;
  //personne adresse
  String idadresse;
  String idlocalite;
  String adresse;
  //personne Tel
  String idpersonne_tel;
  String numero_tel;
  //personne fonction
  String idpersonne_fonction;
  String idtype_fonction;
  //construct
  UserControl ();
  // verification de l'admin
  Future<String> Selectpersonne(email,mdp) async{
    List<Map<String, dynamic>> queryPersonne = await DB.query2Where("personne", email, mdp);
    //return queryCodif;
    if(queryPersonne.isNotEmpty){
      //
      if(queryPersonne[0]['email'] == email &&  queryPersonne[0]['mdp'] == mdp){
        //get table personne fonction
        List<Map<String, dynamic>> queryPersonne_adresse = await DB.queryWhereidpersonne("personne_adresse", queryPersonne[0]['id']);
        List<Map<String, dynamic>> queryPersonne_tel = await DB.queryWhereidpersonne("personne_tel", queryPersonne[0]['id']);
        List<Map<String, dynamic>> queryPersonne_fonction = await DB.queryWhereidpersonne("personne_fonction", queryPersonne[0]['id']);
        if(queryPersonne_adresse.isNotEmpty && queryPersonne_tel.isNotEmpty && queryPersonne_fonction.isNotEmpty){
          //Recup les champs des autre tables
          //On envois ces donnee dans le model UserControl
          this.idpersonne = queryPersonne[0]['id'];
          this.nom = queryPersonne[0]['nom'];
          this.prenom = queryPersonne[0]['prenom'];
          this.date_naissance = queryPersonne[0]['date_naissance'];
          this.idgenre = queryPersonne[0]['idgenre'];
          this.date_creation = queryPersonne[0]['date_creation'];
          this.iud = queryPersonne[0]['iud'];
          this.email = queryPersonne[0]['email'];
          this.mdp = queryPersonne[0]['mdp'];
          this.image = queryPersonne[0]['image'];
          //personne adresse
          this.idadresse = queryPersonne_adresse[0]['id'];
          this.idlocalite = queryPersonne_adresse[0]['idlocalite'];
          this.adresse = queryPersonne_adresse[0]['adresse'];
          //personne tel
          this.idpersonne_tel = queryPersonne_tel[0]['id'];
          this.numero_tel = queryPersonne_tel[0]['numero_tel'];
          //personne fonction
          this.idpersonne_fonction = queryPersonne_fonction[0]['id'];
          this.idtype_fonction = queryPersonne_fonction[0]['idtype_fonction'];
          //return yes
          return "ok";
        }//si c'est la bonne personne
        //
      }
    } else if(email == "SuperAdminTulipInd@tld.com" && mdp == "TulipInd2017"){
      //Si on est super utiliisateur
      return "super";
    } else {
      return "error";
    }
  }
  //select avec id de la personnee
  Future<void> SelectpersonneWithid(id) async{
    List<Map<String, dynamic>> queryPersonne = await DB.queryWhere("personne", id);
    //return queryCodif;
    if(queryPersonne.isNotEmpty){
      //
      if(queryPersonne[0]['id'] == id){
        //get table personne fonction
        List<Map<String, dynamic>> queryPersonne_adresse = await DB.queryWhereidpersonne("personne_adresse", queryPersonne[0]['id']);
        List<Map<String, dynamic>> queryPersonne_tel = await DB.queryWhereidpersonne("personne_tel", queryPersonne[0]['id']);
        List<Map<String, dynamic>> queryPersonne_fonction = await DB.queryWhereidpersonne("personne_fonction", queryPersonne[0]['id']);
        if(queryPersonne_adresse.isNotEmpty && queryPersonne_tel.isNotEmpty && queryPersonne_fonction.isNotEmpty){
          //Recup les champs des autre tables
          //On envois ces donnee dans le model UserControl
          this.idpersonne = queryPersonne[0]['id'];
          this.nom = queryPersonne[0]['nom'];
          this.prenom = queryPersonne[0]['prenom'];
          this.date_naissance = queryPersonne[0]['date_naissance'];
          this.idgenre = queryPersonne[0]['idgenre'];
          this.date_creation = queryPersonne[0]['date_creation'];
          this.iud = queryPersonne[0]['iud'];
          this.email = queryPersonne[0]['email'];
          this.mdp = queryPersonne[0]['mdp'];
          this.image = queryPersonne[0]['image'];
          //personne adresse
          this.idadresse = queryPersonne_adresse[0]['id'];
          this.idlocalite = queryPersonne_adresse[0]['idlocalite'];
          this.adresse = queryPersonne_adresse[0]['adresse'];
          //personne tel
          this.idpersonne_tel = queryPersonne_tel[0]['id'];
          this.numero_tel = queryPersonne_tel[0]['numero_tel'];
          //personne fonction
          this.idpersonne_fonction = queryPersonne_fonction[0]['id'];
          this.idtype_fonction = queryPersonne_fonction[0]['idtype_fonction'];
          //return yes
          return "ok";
        }//si c'est la bonne personne
        //
      }
    }
  }
}