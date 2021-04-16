import 'package:flutter/material.dart';

class UserIn{
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

  UserIn({this.idpersonne, this.nom, this.prenom, this.date_naissance, this.idgenre, this.date_creation, this.iud, this.email, this.mdp, this.image, this.idadresse, this.idlocalite, this.adresse, this.idpersonne_tel, this.numero_tel, this.idpersonne_fonction, this.idtype_fonction,});
}

/*final userControl = UserControl(
            idpersonne: queryPersonne[0]['id'],
            nom: queryPersonne[0]['nom'],
            prenom: queryPersonne[0]['prenom'],
            date_naissance: queryPersonne[0]['date_naissance'],
            idgenre: queryPersonne[0]['idgenre'],
            date_creation: queryPersonne[0]['date_creation'],
            iud: queryPersonne[0]['iud'],
            email: queryPersonne[0]['email'],
            mdp: queryPersonne[0]['mdp'],
            image: queryPersonne[0]['image'],
            //personne adresse
            idadresse: queryPersonne_adresse[0]['id'],
            idlocalite: queryPersonne_adresse[0]['idlocalite'],
            adresse: queryPersonne_adresse[0]['adresse'],
            //personne tel
            idpersonne_tel: queryPersonne_tel[0]['id'],
            numero_tel: queryPersonne_tel[0]['numero_tel'],
            //personne fonction
            idpersonne_fonction: queryPersonne_fonction[0]['id'],
            idtype_fonction: queryPersonne_fonction[0]['idtype_fonction'],
          );*/