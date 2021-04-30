import 'package:flutter/material.dart';

class UserControl{
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

  UserControl(this.idpersonne, this.nom, this.prenom, this.date_naissance, this.idgenre, this.date_creation, this.iud, this.email, this.mdp, this.image);

  @override
  String toString() {
    return '{${this.idpersonne}, ${this.nom}, ${this.prenom}, ${this.date_naissance}, ${this.idgenre}, ${this.date_creation}, ${this.iud}, ${this.email}, ${this.mdp}, ${this.image}}';
  }
}