//package native
import 'dart:io';
import 'dart:async';
//pakage importer pub get
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//Code
class DatabaseHelper {
  //les variable private global
  static final _dbname = 'pam_db.db';
  static final _dbVersion = 1;
  static final _tableName = 'Personnage';
  //les colonnes de table
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnTel = 'tel';
  static final columnZone = 'zone';
  static final columnGenre = 'genre';
  static final columnStock = 'stock';
  //Une classe unique no repeat
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  //One class
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initiateDatabase();
    return _database;
  }
  //initiation de la base de donner
  _initiateDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbname);
    await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }
  //Creation de table
  Future _onCreate(Database db,int version) {
    db.execute(
      ''' 
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT,
      $columnTel TEXT,
      $columnZone TEXT,
      $columnGenre TEXT,
      $columnStock TEXT)
      '''
    );
  }
  /*
  {
    "_id": 12,
    "name": "prince"
  }
  */
  //insert des donne dans la base de donnee
  Future<int> insert(Map<String, dynamic> row) async{
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }
  // Select dans la base de donnee
  Future<List<Map<String, dynamic>>> queryAll() async{
    Database db = await instance.database;
    return await db.query(_tableName);
  }
  //Une mise a jour dans la base de donnee
  Future<int> update(Map<String, dynamic> row) async{
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }
  //Delectein the database for every moment
  Future<int> delete(int id) async{
    Database db = await instance.database;
    return await db.delete(_tableName,where: '$columnId = ?',whereArgs: [id]);
  }
}