<?php
require('connect-db.php');
$db_php = connect_external_db();
$SelectData = 'SELECT * FROM users WHERE id = '.$_GET['idcommercant'].'';
$statement = $db_php->prepare($SelectData);
$statement->execute();
$donnee = array();
while($result = $statement->fetch()){
    array_push(
        $donnee,array(
             "id" => $result['id'],
             "name" => $result['name'],
             "Prenom" => $result['Prenom'],
             "privilege" => $result['privilege'],
             "image" => $result['image'],
             "email" => $result['email'],
        )
    );
}
echo json_encode($donnee);