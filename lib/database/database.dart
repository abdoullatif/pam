//package native
import 'dart:async';
//pakage importer pub get
import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';

//Code
class DB{
  static Database _db;
  static int get _version => 1;
  
  static Future<void> init() async{
    if (_db != null) return;
    try{
      String _path = await getDatabasesPath() + 'pamdb';
      print("succes");
      print(_path);
      _db = (await openDatabase(_path, version: _version, onCreate: onCreate)) as Database; //
    } catch (ex){
      print(ex);
    }
  }
  static void onCreate(Database db, int version) async{
    //-------------------------Parametre de la tablette--------------------------
    //table parametre
    await db.execute('''
    CREATE TABLE parametre(
    id INTEGER PRIMARY KEY,
    device TEXT,
    locate TEXT,
    dbname TEXT,
    user TEXT,
    mdp TEXT,
    adresse_server TEXT,
    ip_server TEXT,
    site_commercant TEXT,
    site_pam TEXT,
    langue TEXT)
    ''');
    //table langue
    await db.execute('''
    CREATE TABLE langue(
    id TEXT PRIMARY KEY,
    description TEXT,
    flagtransmis TEXT)
    ''');
    //table Anne Scolaire
    await db.execute('''
    CREATE TABLE annee_scolaire(
    id TEXT PRIMARY KEY,
    description TEXT,
    flagtransmis TEXT)
    ''');
    //table Campagne Scolaire
    await db.execute('''
    CREATE TABLE campagne_agricol(
    id TEXT PRIMARY KEY,
    description TEXT,
    flagtransmis TEXT)
    ''');
    //////////////////////------------Enregitrer une personne------------------------/////
    //table personne
    await db.execute('''
    CREATE TABLE personne(
    id TEXT PRIMARY KEY,
    nom TEXT,
    prenom TEXT,
    date_naissance TEXT,
    idgenre TEXT,
    date_creation TEXT,
    iud TEXT,
    email TEXT,
    mdp TEXT,
    image TEXT,
    flagtransmis TEXT)
    ''');
    //Table Adresse
    await db.execute('''
    CREATE TABLE personne_adresse(
    id TEXT PRIMARY KEY,
    idlocalite TEXT,
    idpersonne TEXT,
    adresse TEXT,
    flagtransmis TEXT)
    ''');
    //Table personne Tel
    await db.execute('''
    CREATE TABLE personne_tel(
    id TEXT PRIMARY KEY,
    idpersonne TEXT,
    numero_tel TEXT,
    flagtransmis TEXT)
    ''');
    //personne fonction
    await db.execute('''
    CREATE TABLE personne_fonction(
    id TEXT PRIMARY KEY,
    idpersonne TEXT,
    idtypefonction TEXT,
    flagtransmis TEXT)
    ''');
    //table localite
    await db.execute('''
    CREATE TABLE localite(
    id INTEGER PRIMARY KEY NOT NULL,
    idlocalite TEXT,
    description TEXT,
    typelocalite TEXT,
    idtypelocalite TEXT,
    longitude TEXT,
    latitude TEXT,
    flagtransmis TEXT)
    ''');
    //table codification
    await db.execute('''
    CREATE TABLE codification(
    id TEXT PRIMARY KEY,
    entite TEXT,
    idcodification TEXT,
    description TEXT,
    desc_crt TEXT,
    categories TEXT,
    flagtransmis TEXT)
    ''');
    //------------------------Enregitrer un eleve------------------------------
    //table Inscription
    await db.execute('''
    CREATE TABLE inscription(
    id TEXT PRIMARY KEY,
    idpersonne TEXT,
    idclasse TEXT,
    idtypeannee TEXT,
    anneeScolaire TEXT,
    flagtransmis TEXT)
    ''');
    //table Classe
    await db.execute('''
    CREATE TABLE classe(
    id TEXT PRIMARY KEY,
    idecole TEXT,
    idtypeniveau TEXT,
    anneeScolaire TEXT,
    flagtransmis TEXT)
    ''');
    //table ecole
    await db.execute('''
    CREATE TABLE ecole(
    id TEXT PRIMARY KEY,
    idlocalite TEXT,
    code_ssp TEXT,
    idpersonne TEXT,
    nom_ecole TEXT,
    flagtransmis TEXT)
    ''');
    //table suivit repas
    await db.execute('''
    CREATE TABLE suivit_repas(
    id TEXT PRIMARY KEY,
    idpersonne TEXT,
    present TEXT,
    manger TEXT,
    nbscan TEXT,
    date TEXT,
    anneeScolaire TEXT,
    flagtransmis TEXT)
    ''');
    //table suivit repas
    await db.execute('''
    CREATE TABLE suivit_poids_eleve(
    id TEXT PRIMARY KEY,
    idpersonne TEXT,
    idecole TEXT,
    datesuivit TEXT,
    poids TEXT,
    taille TEXT,
    anneeScolaire TEXT,
    flagtransmis TEXT)
    ''');
    //-----------------------------table detail bon----------------------
    //table detail bon
    await db.execute('''
    CREATE TABLE detail_bon(
    id TEXT PRIMARY KEY,
    article TEXT,
    quantite TEXT,
    ref TEXT,
    flagtransmis TEXT)
    ''');
    //table bon
    await db.execute('''
    CREATE TABLE bon(
    id TEXT PRIMARY KEY,
    ref TEXT,
    date TEXT,
    idpersonne TEXT,
    description TEXT,
    notify TEXT,
    status TEXT,
    flagtransmis TEXT)
    ''');
    //-------------------Enregitrer un Agriculteur----------------------------
    //table detenteur_plantation
    await db.execute('''
    CREATE TABLE detenteur_plantation(
    id TEXT PRIMARY KEY,
    idplantation TEXT,
    idpersonne TEXT,
    flagtransmis TEXT)
    ''');
    //table plantation
    await db.execute('''
    CREATE TABLE plantation(
    id TEXT PRIMARY KEY,
    description TEXT,
    groupement TEXT,
    longitude TEXT,
    latitude TEXT,
    superficie TEXT,
    idlocalite TEXT,
    nbre_femme TEXT,
    nbre_homme TEXT,
    nbre_membre TEXT,
    observation TEXT,
    agreement TEXT,
    flagtransmis TEXT)
    ''');
    //table detenteur_culture
    await db.execute('''
    CREATE TABLE detenteur_culture(
    id TEXT PRIMARY KEY,
    iddetenteur_plantation TEXT,
    datedebut TEXT,
    datefinprevu TEXT,
    superficie TEXT,
    idtypeculture TEXT,
    Quantiteprevu TEXT,
    QteStock TEXT,
    DateStock TEXT,
    campagneAgricol TEXT,
    flagtransmis TEXT)
    ''');
    //table detenteur_culture
    await db.execute('''
    CREATE TABLE vente(
    id TEXT PRIMARY KEY,
    idagent TEXT,
    iduser TEXT,
    qtevendu TEXT,
    iddetenteur_culture TEXT,
    prixvente TEXT,
    datevente TEXT,
    code_recu TEXT,
    campagneAgricol TEXT,
    flagtransmis TEXT)
    ''');
    //-----------------------Enregitrer une femme enceinte Table---------------
    //table grossesse
    await db.execute('''
    CREATE TABLE grossesse(
    id TEXT PRIMARY KEY,
    idpersonne TEXT,
    status TEXT,
    ordre INTEGER,
    flagtransmis TEXT)
    ''');
    //table suivit grossesse
    await db.execute('''
    CREATE TABLE suivit_grossesse(
    id TEXT PRIMARY KEY,
    idgrossesse TEXT,
    idpersonne TEXT,
    datesuivit TEXT,
    poids TEXT,
    taille TEXT,
    imc TEXT,
    pb TEXT,
    status TEXT,
    flagtransmis TEXT)
    ''');
    //Table enfant
    await db.execute('''
    CREATE TABLE enfant(
    id TEXT PRIMARY KEY,
    nom TEXT,
    prenom TEXT,
    sexe TEXT,
    dateNaissance TEXT,
    idgrossesse TEXT,
    date_limit TEXT,
    flagtransmis TEXT)
    ''');
    //table suivit_enfant
    await db.execute('''
    CREATE TABLE suivit_enfant(
    id TEXT PRIMARY KEY,
    idEnfant TEXT,
    poids TEXT,
    taille TEXT,
    dateSuivit TEXT,
    flagtransmis TEXT)
    ''');
    //-------------------------QUESTIONNAIRE ELEVE -----------------------
    //table QUIZE
    await db.execute('''
    CREATE TABLE quiz_eleve(
    id TEXT PRIMARY KEY,
    idecole TEXT,
    quiz1 TEXT,
    quiz2 TEXT,
    quiz3 TEXT,
    quiz4 TEXT,
    quiz5 TEXT,
    quiz6 TEXT,
    quiz7 TEXT,
    datequiz TEXT,
    typequiz TEXT,
    anneeScolaire TEXT,
    flagtransmis TEXT)
    ''');
    //-------------------------------------------------------------------------------
    //-------------------------QUESTIONNAIRE FEMME ENCEINTE --------------------------
    //table QUIZE
    await db.execute('''
    CREATE TABLE quiz_femmeEnceinte(
    id TEXT PRIMARY KEY,
    idpersonne TEXT,
    quiz1 TEXT,
    quiz2 TEXT,
    quiz3 TEXT,
    quiz4 TEXT,
    quiz5 TEXT,
    quiz6 TEXT,
    quiz7 TEXT,
    quiz8 TEXT,
    datequiz TEXT,
    typequiz TEXT,
    flagtransmis TEXT)
    ''');
    //------------------------Table Media---------------------
    //table media
    await db.execute('''
    CREATE TABLE media(
    id INTEGER PRIMARY KEY,
    media_title TEXT,
    media_lang TEXT,
    media_categorie TEXT,
    media_sous_categorie TEXT,
    media_file TEXT,
    flagtransmis TEXT)
    ''');
    //table categories
    await db.execute('''
    CREATE TABLE categories(
    id TEXT PRIMARY KEY,
    nom_categ TEXT,
    flagtransmis TEXT)
    ''');
    //table categories
    await db.execute('''
    CREATE TABLE sous_categories(
    id TEXT PRIMARY KEY,
    id_categ TEXT,
    nom_sous_categ TEXT,
    flagtransmis TEXT)
    ''');
    //--------------------------------------------Audio
    //table fichier audio
    await db.execute('''
    CREATE TABLE fichier_audio(
    id TEXT PRIMARY KEY,
    iud TEXT,
    nom_audio TEXT,
    date_audio TEXT,
    flagtransmis TEXT)
    ''');
  }

  //-------------------------------------------------------------------------------------------------------------------------------------

  static Future<List<Map<String, dynamic>>> querygro(String idpersonne) async => await _db.rawQuery('SELECT * FROM grossesse WHERE idpersonne = "$idpersonne" ORDER BY ordre DESC LIMIT 1');

  //slect tout from
  static Future<List<Map<String, dynamic>>> querygrosses(String idpersonne) async => await _db.rawQuery('SELECT * FROM grossesse WHERE idpersonne = "$idpersonne"');

  //slect Qte stock from detenteur_culture
  static Future<List<Map<String, dynamic>>> querydetCult(String iddeteCul) async => await _db.rawQuery('SELECT * FROM detenteur_culture WHERE id = "$iddeteCul"');

  static Future<List<Map<String, dynamic>>> queryAll(String table) async => _db.query(table);

  static Future<int> insert(String table, Map<String, dynamic> model) async => await _db.insert(table, model);

  static Future<int> update(String table, Map<String, dynamic> model,int id) async => await _db.update(table, model, where: 'id = ?', whereArgs: [id]);

  //Update culture
  static Future<int> updateCult(String table, Map<String, dynamic> model,String id) async => await _db.update(table, model, where: 'id = ?', whereArgs: [id]);

  //Update personne admin
  static Future<int> updatePersonne(String table, Map<String, dynamic> model,String id) async => await _db.update(table, model, where: 'id = ?', whereArgs: [id]);

  //
  static Future<int> updateGrossesse(String table, Map<String, dynamic> model,String id) async => await _db.update(table, model, where: 'id = ?', whereArgs: [id]);

  //update where idinscription
  static Future<int> updateWhereIdPers(String table, Map<String, dynamic> model,String id) async => await _db.update(table, model, where: 'idpersonne = ?', whereArgs: [id]);

  //Select Were
  static Future<List<Map<String, dynamic>>> queryWhere(String table,String id) async => await _db.query(table, where: 'id = ?', whereArgs: [id]);

  //Select Were
  static Future<List<Map<String, dynamic>>> queryWherelocalite(String table,String id) async => await _db.query(table, where: 'description = ?', whereArgs: [id]);

  //Select Were
  static Future<List<Map<String, dynamic>>> queryWhereidlocalite(String table,String id) async => await _db.query(table, where: 'id = ?', whereArgs: [id]);

  //Select Were id inscription
  static Future<List<Map<String, dynamic>>> queryWhereidInscription(String table,String id) async => await _db.query(table, where: 'idinscription = ?', whereArgs: [id]);

  //Select 2 deux Were inscription repas
  static Future<List<Map<String, dynamic>>> query2WhereidPers(String table, String idinscription, String date) async => await _db.query(table, where: 'idpersonne = ? and date = ?', whereArgs: [idinscription,date]);

  //Select 2 deux Were
  static Future<List<Map<String, dynamic>>> query2Where(String table, String email, String mdp) async => await _db.query(table, where: 'email = ? and mdp = ?', whereArgs: [email,mdp]);

  //Select 2 deux Were
  static Future<List<Map<String, dynamic>>> queryEmail(String table, String email) async => await _db.query(table, where: 'email = ?', whereArgs: [email]);

  //Select 3 trois where
  static Future<List<Map<String, dynamic>>> query3Where(String table, String email, String mdp, String iud) async => await _db.query(table, where: 'email = ? and mdp = ? and iud = ?', whereArgs: [email,mdp,iud]);

  //Select 3 trois where
  static Future<List<Map<String, dynamic>>> queryEmailNfc(String table, String email, String iud) async => await _db.query(table, where: 'email = ? and iud = ?', whereArgs: [email,iud]);

  //Select 1 un Were uid
  static Future<List<Map<String, dynamic>>> queryWhereUid(String table, String uid) async => await _db.query(table, where: 'iud = ?', whereArgs: [uid]);

  //Select Were
  static Future<List<Map<String, dynamic>>> queryCodif(String table,String entite) async => await _db.query(table, where: 'entite = ?', whereArgs: [entite]);

  //Select 2 deux Were codif
  static Future<List<Map<String, dynamic>>> queryCodif2Where(String table, String entite, String param) async => await _db.query(table, where: 'entite = ? and desc_crt = ?', whereArgs: [entite,param]);

  //Select 2 deux Were codif
  static Future<List<Map<String, dynamic>>> queryparam2Where(String table, String param1, String param2) async => await _db.query(table, where: 'entite = ? and categories = ?', whereArgs: [param1,param2]);

  //initial qurey tab
  static Future<List<Map<String, dynamic>>> initTabquery() async => await DB.queryAll("parametre");

  //Query where locate
  static Future<List<Map<String, dynamic>>> queryWherelocate(String table,String locate) async => await _db.query(table, where: 'description = ?', whereArgs: [locate]);

  //les Requet preparer commencemet personne ...

  //Select Were ippersonne
  static Future<List<Map<String, dynamic>>> queryWhereidpersonne(String table,String id) async => await _db.query(table, where: 'idpersonne = ?', whereArgs: [id]);

  //Select in table chef plantation
  static Future<List<Map<String, dynamic>>> queryPersonDetPlantation() async => await _db.rawQuery('SELECT * FROM personne,personne_fonction,detenteur_plantation,plantation WHERE personne.id = detenteur_plantation.idpersonne and detenteur_plantation.idplantation = plantation.id and personne.id = personne_fonction.idpersonne and personne_fonction.idtypefonction = "CA"');

  //Select in table chef and working
  static Future<List<Map<String, dynamic>>> queryPersonAgri(String idloc) async => await _db.rawQuery('SELECT personne.id AS id, personne.nom AS nom, personne.prenom AS prenom, personne.image AS image, plantation.description AS description, personne_fonction.idtypefonction AS fonction FROM personne,personne_fonction,personne_adresse,detenteur_plantation,plantation WHERE personne.id = detenteur_plantation.idpersonne and detenteur_plantation.idplantation = plantation.id and personne.id = personne_fonction.idpersonne and personne.id = personne_adresse.idpersonne and personne_adresse.idlocalite = "$idloc"');

  //Search in
  static Future<List<Map<String, dynamic>>> querySearchAgri(String idloc, String query) async => await _db.rawQuery('SELECT personne.id AS id, personne.nom AS nom, personne.prenom AS prenom, personne.image AS image, plantation.description AS description, personne_fonction.idtypefonction AS fonction FROM personne,personne_fonction,personne_adresse,detenteur_plantation,plantation WHERE personne.id = detenteur_plantation.idpersonne and detenteur_plantation.idplantation = plantation.id and personne.id = personne_fonction.idpersonne and personne.id = personne_adresse.idpersonne and personne_adresse.idlocalite = "$idloc" and (nom Like "%$query%" OR prenom Like "%$query%")');


  //Select User profile info All
  static Future<List<Map<String, dynamic>>> queryUserInfo(String id) async => await _db.rawQuery('SELECT personne.id AS id, personne.nom AS nom, personne.prenom AS prenom, personne.date_naissance AS date_naissance, personne.idgenre AS genre, personne.date_creation AS date_creation, personne.iud AS iud, personne.image AS image, codification.categories AS categories, personne_fonction.idtypefonction AS fonction, localite.description AS localite, personne_tel.numero_tel AS numero, personne_adresse.adresse AS adresse FROM personne,personne_fonction,personne_adresse,personne_tel,localite,codification WHERE personne.id = "$id" and personne.id = personne_fonction.idpersonne and personne.id = personne_adresse.idpersonne and personne.id = personne_tel.idpersonne and personne_adresse.idlocalite = localite.id and codification.idcodification = personne_fonction.idtypefonction');

  //Select User profile info Agriculteur
  static Future<List<Map<String, dynamic>>> queryUserAgri(String id) async => await _db.rawQuery('SELECT personne.id AS id, personne.nom AS nom, personne.prenom AS prenom, personne.date_naissance AS date_naissance, personne.idgenre AS genre, personne.date_creation AS date_creation, personne.iud AS iud, personne.image AS image, codification.categories AS categories, personne_fonction.idtypefonction AS fonction, localite.description AS localite, personne_tel.numero_tel AS numero, personne_adresse.adresse AS adresse, plantation.description AS plantation, plantation.groupement AS groupement, plantation.superficie AS superficie, plantation.nbre_homme AS homme, plantation.nbre_femme AS femme, plantation.nbre_membre AS membre , detenteur_plantation.id AS iddetenteur_plantation FROM personne,personne_fonction,personne_adresse,personne_tel,localite,codification,detenteur_plantation,plantation WHERE personne.id = "$id" and personne.id = personne_fonction.idpersonne and personne.id = personne_adresse.idpersonne and personne.id = personne_tel.idpersonne and personne_adresse.idlocalite = localite.id and codification.idcodification = personne_fonction.idtypefonction and personne.id = detenteur_plantation.idpersonne and detenteur_plantation.idplantation = plantation.id');

  //Select User profile info Femme enceinte
  static Future<List<Map<String, dynamic>>> queryUserFemm(String id) async => await _db.rawQuery('SELECT personne.id AS id, personne.nom AS nom, personne.prenom AS prenom, personne.date_naissance AS date_naissance, personne.idgenre AS genre, personne.date_creation AS date_creation, personne.iud AS iud, personne.image AS image, codification.categories AS categories, personne_fonction.idtypefonction AS fonction, localite.description AS localite, personne_tel.numero_tel AS numero, personne_adresse.adresse AS adresse, grossesse.status AS status, grossesse.id AS idgrossesse FROM personne,personne_fonction,personne_adresse,personne_tel,localite,codification,grossesse WHERE personne.id = "$id" and personne.id = personne_fonction.idpersonne and personne.id = personne_adresse.idpersonne and personne.id = personne_tel.idpersonne and personne_adresse.idlocalite = localite.id and codification.idcodification = personne_fonction.idtypefonction and personne.id = grossesse.idpersonne ORDER BY ordre DESC LIMIT 1');

  ////////////////////////////
  //Query user eleve where uid
  ////////////////////////////
  //Select User profile info Eleve
  static Future<List<Map<String, dynamic>>> queryUserElevUid(String uid) async => await _db.rawQuery('SELECT *,max(inscription.idtypeannee) as derniereAnne, personne.id AS id, personne.nom AS nom, personne.prenom AS prenom, personne.date_naissance AS date_naissance, personne.idgenre AS genre, personne.date_creation AS date_creation, personne.iud AS iud, personne.image AS image, inscription.id AS idInscription, personne_fonction.idtypefonction AS fonction, localite.description AS localite, personne_tel.numero_tel AS numero, personne_adresse.adresse AS adresse, classe.idtypeniveau AS niveau FROM personne,personne_fonction,personne_adresse,personne_tel,localite,inscription,classe WHERE personne.iud = "$uid" and personne.id = personne_fonction.idpersonne and personne.id = personne_adresse.idpersonne and personne.id = personne_tel.idpersonne and personne_adresse.idlocalite = localite.id and personne.id = inscription.idpersonne and inscription.idclasse = classe.id');

  //Select User profile info Eleve
  static Future<List<Map<String, dynamic>>> queryUserElev(String id, String annee, String campagneScolaire) async => await _db.rawQuery('SELECT *,personne.id AS id, personne.nom AS nom, personne.prenom AS prenom, personne.date_naissance AS date_naissance, personne.idgenre AS genre, personne.date_creation AS date_creation, personne.iud AS iud, personne.image AS image, personne_fonction.idtypefonction AS fonction, localite.description AS localite, personne_tel.numero_tel AS numero, personne_adresse.adresse AS adresse, classe.idtypeniveau AS niveau, inscription.id AS idinscription, inscription.anneeScolaire AS session, codification.description as classe FROM personne,personne_fonction,personne_adresse,personne_tel,localite,inscription,classe,codification WHERE personne.id = "$id" and personne.id = personne_fonction.idpersonne and personne.id = personne_adresse.idpersonne and personne.id = personne_tel.idpersonne and personne_adresse.idlocalite = localite.id and personne.id = inscription.idpersonne and inscription.idtypeannee = "$annee" and classe.anneeScolaire = "$campagneScolaire" and inscription.idclasse = classe.id and classe.idtypeniveau = codification.idcodification GROUP BY personne.id');

  //Select in table agriculteur
  static Future<List<Map<String, dynamic>>> queryPersonAgriculteur() async => await _db.rawQuery('SELECT * FROM personne,personne_fonction,detenteur_plantation,plantation WHERE personne.id = detenteur_plantation.idpersonne and detenteur_plantation.idplantation = plantation.id and personne_fonction.idtypefonction = "AG"');

  //Select in table chef agriculteur
  static Future<List<Map<String, dynamic>>> queryPersonChefAgriculteur() async => await _db.rawQuery('SELECT * FROM personne,personne_fonction,detenteur_plantation,plantation WHERE personne.id = detenteur_plantation.idpersonne and detenteur_plantation.idplantation = plantation.id and personne_fonction.idtypefonction = "CA"');

  //Select in table eleve inscrit
  static Future<List<Map<String, dynamic>>> queryPersonEleve(String idloc, String id_dg) async => await _db.rawQuery('select *,max(inscription.idtypeannee) as derniereAnne,classe.id AS idclasse, classe.anneeScolaire,classe.idtypeniveau, personne.id as idpersonne, personne.nom, personne.prenom, inscription.idtypeannee, inscription.anneeScolaire, codification.description as classe FROM personne, classe, ecole, inscription, personne_adresse, localite, codification WHERE personne.id = personne_adresse.idpersonne AND personne_adresse.idlocalite = "$idloc" AND classe.idecole = ecole.id AND ecole.idpersonne = "$id_dg" AND personne.id = inscription.idpersonne AND inscription.idclasse = classe.id and classe.idtypeniveau = codification.idcodification GROUP BY personne.id');

  //Query Searche en fonction de se qui se passe
  static Future<List<Map<String, dynamic>>> querySearch(String idloc, String query, String id_dg) async => await _db.rawQuery('select *,max(inscription.idtypeannee) as derniereAnne,classe.id AS idclasse, classe.anneeScolaire,classe.idtypeniveau, personne.id as idpersonne, personne.nom, personne.prenom, inscription.idtypeannee, inscription.anneeScolaire, codification.description as classe FROM personne, classe, inscription, ecole, personne_adresse, localite, codification WHERE personne.id = personne_adresse.idpersonne AND personne_adresse.idlocalite = "$idloc" AND classe.idecole = ecole.id AND ecole.idpersonne = "$id_dg" AND personne.id = inscription.idpersonne AND inscription.idclasse = classe.id and classe.idtypeniveau = codification.idcodification and (nom Like "%$query%" OR prenom Like "%$query%") GROUP BY personne.id');

  //Select in table Femme allaitante (enfant)
  static Future<List<Map<String, dynamic>>> queryPersonEnfant(String idp) async => await _db.rawQuery('SELECT * FROM grossesse,enfant WHERE grossesse.id = enfant.idgrossesse and grossesse.idpersonne = "$idp" ');

  //Select in table Femme enceinte
  static Future<List<Map<String, dynamic>>> queryPersonFemmeE(String idloc) async => await _db.rawQuery('SELECT *,personne.id AS id FROM personne,personne_fonction,personne_adresse WHERE personne.id = personne_fonction.idpersonne and personne_fonction.idtypefonction = "FE" and personne.id = personne_adresse.idpersonne and personne_adresse.idlocalite = "$idloc"');

  //Search in femme enceinte
  static Future<List<Map<String, dynamic>>> querySearchFem(String idloc, String query) async => await _db.rawQuery('SELECT *,personne.id AS id FROM personne,personne_fonction,personne_adresse WHERE personne.id = personne_fonction.idpersonne and personne_fonction.idtypefonction = "FE" and personne.id = personne_adresse.idpersonne and personne_adresse.idlocalite = "$idloc" and (nom Like "%$query%" OR prenom Like "%$query%")');

  //Select in table Vente and personne
  static Future<List<Map<String, dynamic>>> queryVente(String idagent) async => await _db.rawQuery('SELECT datevente AS Date, personne.nom || " " || personne.prenom AS Agriculteur, prixvente AS Prix,detenteur_culture.idtypeculture AS Culture, qtevendu AS Quantite, vente.code_recu AS Code_recu FROM vente,personne,detenteur_culture WHERE vente.idagent="$idagent" and personne.id = vente.iduser and vente.iddetenteur_culture = detenteur_culture.id');

  //Select in table detenteur_culture
  static Future<List<Map<String, dynamic>>> queryCulture(String iddetenteur_plantation) async => await _db.rawQuery('SELECT id AS id, datedebut AS debut, datefinprevu AS fin, superficie, idtypeculture, quantiteprevu as quantite, QteStock FROM detenteur_culture WHERE detenteur_culture.iddetenteur_plantation="$iddetenteur_plantation"');

  //Select in table Suivitrepas
  static Future<List<Map<String, dynamic>>> querySuiviRepas(String idpersonne) async => await _db.rawQuery('SELECT date,present,manger FROM suivit_repas WHERE idpersonne = "$idpersonne"');

  //Select in table Suivitrepas
  static Future<List<Map<String, dynamic>>> queryNbrScan(String date) async => await _db.rawQuery('SELECT COUNT(date) AS nombre FROM suivit_repas WHERE date="$date"');

  //Select in table datesuivit,poids
  static Future<List<Map<String, dynamic>>> queryPoidsFemme(String idgrossesse, String status) async => await _db.rawQuery('SELECT datesuivit,poids FROM suivit_grossesse WHERE idgrossesse="$idgrossesse" and status ="$status"');

  //Select in table * suivit_femme
  static Future<List<Map<String, dynamic>>> querySuivitFemmeTableau(String idgrossesse, String status) async => await _db.rawQuery('SELECT datesuivit,poids,taille,imc,pb FROM suivit_grossesse WHERE idgrossesse="$idgrossesse" and status ="$status"');

  //Select in table poids
  static Future<List<Map<String, dynamic>>> querySuivitEnfantTab(String idenfant,) async => await _db.rawQuery('SELECT poids,taille,datesuivit FROM suivit_enfant WHERE idenfant="$idenfant"');

  //Select in table poids
  static Future<List<Map<String, dynamic>>> querySuivitEnfant(String idenfant,) async => await _db.rawQuery('SELECT datesuivit,poids FROM suivit_enfant WHERE idenfant="$idenfant"');

  //Select in table poids
  static Future<List<Map<String, dynamic>>> querySuivitEnfantTaille(String idenfant,) async => await _db.rawQuery('SELECT datesuivit,taille FROM suivit_enfant WHERE idenfant="$idenfant"');

  //*************************************************************************************************************************************************
  //|          Media Querie
  //*************************************************************************************************************************************************
  //Select media video presentation max 1
  static Future<List<Map<String, dynamic>>> queryMediaCateg(String categorie, String lang) async => await _db.rawQuery('SELECT * FROM media WHERE media_categorie = "$categorie" and media_lang = "$lang" and media_sous_categorie = "presentation" ORDER BY id DESC LIMIT 1');//ifnull(length(media_sous_categorie), 1) = 1 or ifnull(length(media_sous_categorie), 0) = 0

  //Select Video Sous categories max 6
  static Future<List<Map<String, dynamic>>> queryMediaCategAll(String categorie, String lang) async => await _db.rawQuery('SELECT * FROM media WHERE media_categorie = "$categorie" and media_lang = "$lang" ORDER BY id DESC LIMIT 6');

  //Select Video Sous categories max 6
  static Future<List<Map<String, dynamic>>> queryMediaScateg(String categorie, String scateg, String lang) async => await _db.rawQuery('SELECT * FROM media WHERE media_categorie = "$categorie" and media_sous_categorie = "$scateg" and media_lang = "$lang" ORDER BY id DESC LIMIT 6');

  //Select Video Sous categories max 6
  static Future<List<Map<String, dynamic>>> queryMediaScategAliment(String categorie, String scateg, String lang) async => await _db.rawQuery('SELECT * FROM media WHERE media_categorie = "$categorie" and media_sous_categorie = "$scateg" and media_lang = "$lang" ORDER BY id DESC LIMIT 1');

  //Select Video
  static Future<List<Map<String, dynamic>>> queryMedia(int id) async => await _db.rawQuery('SELECT * FROM media WHERE id = "$id"');

  //*************************************************************************************************************************************************
  //|          Vocale Querie
  //*************************************************************************************************************************************************

  //Select Video
  static Future<List<Map<String, dynamic>>> queryVocal(String nom_audio) async => await _db.rawQuery('SELECT * FROM fichier_audio WHERE nom_audio = "$nom_audio"');


  //------------------------------------------------------------------------------------------------------------------------------------------

  //Recuperation des info dans la Campagne agricole
  static Future<List<Map<String, dynamic>>> queryCampagne() async => await _db.rawQuery('SELECT * FROM campagne_agricol order by id desc limit 1');

  //Recuperation des info de l'annee scolaire
  static Future<List<Map<String, dynamic>>> queryAnneeScolaire() async => await _db.rawQuery('SELECT * FROM annee_scolaire order by id desc limit 1');

//------------------------------------------------------------------------------------------------------------------------------------------

  //Drop or deleted All Table

  //personne
  static Future<List<Map<String, dynamic>>> troncatTable(String table) async => await _db.rawQuery('DELETE from "$table"');


}