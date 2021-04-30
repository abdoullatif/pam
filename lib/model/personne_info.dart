//package native
import 'package:flutter/material.dart';


class Personne_info {

  String id;
  String nom;
  String prenom;
  String description;
  String images;


  Personne_info(
      {this.id, this.nom, this.prenom, this.description, this.images});

  factory Personne_info.fromJson(Map<String, dynamic> json){
    return Personne_info(
      id: json["id"] as String,
      nom: json["nom"] as String,
      prenom: json["prenom"] as String,
      description: json["description"] as String,
      images: json["images"] as String,
    );
  }


}