import 'package:mysql1/mysql1.dart';

class Db_mysql {
  //debut de classe
  //connect
  var settings = new ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '',
      db: 'pam'
  );
  //************************les variable
  var conn;
  var results;
  var result;
  //************************les fonctions
  //fonction de connection a la base de donner mysql
  Future<void> connexion () async {
    conn = await MySqlConnection.connect(settings);
    print("connecton etabli");
  }
  //create table

  Future mysqldb() async {
    // Create a table
    await conn.query(
        'CREATE TABLE users (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, name varchar(255), email varchar(255), age int)');
    // Insert some data
    var result = await conn.query(
        'insert into users (name, email, age) values (?, ?, ?)',
        ['Bob', 'bob@bob.com', 25]);
    print('Inserted row id=${result.insertId}');
  }

  //fonction de query
  Future<void> queryId (String id) async {
    results = await conn.query('select name, email from users where id = ?', [id]);
  }
  //Resultat
  /*
  for (var row in results) {
  print('Name: ${row[0]}, email: ${row[1]}');
  });
  */
  //fonction de Insert
  Future<void> insert (String param1, String param2, String param4, String param5, String param6,) async {
    result = await conn.query('insert into users (name, email, age) values (?, ?, ?)', ['Bob', 'bob@bob.com', 25]);
  }

  Future mydb() async {
    // connection (pamdb)
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost', port: 3306, user: 'tab', password: '', db: 'pam2'));

    // requete serveur
    var results = await conn.query('select nom, prenom from personne');
    for (var row in results) {
      print('Nom: ${row[0]}, prenom: ${row[1]}');
    }

    // connection close
    await conn.close();
  }
  //Resultat
  /*
  id
  print("New user's id: ${result.insertId}");
  */
  //fonction de Insert multiple
  /*
  Future<void> insertMultiple (String param1, String param2, String param4, String param5, String param6,) async {
    results = await query.queryMulti(
        'insert into users (name, email, age) values (?, ?, ?)',
        [['Bob', 'bob@bob.com', 25],
          ['Bill', 'bill@bill.com', 26],
          ['Joe', 'joe@joe.com', 37]]);
  }*/
}