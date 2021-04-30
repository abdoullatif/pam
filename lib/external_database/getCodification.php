<?php
require('connect-db.php');
$db_php = connect_external_db();
$SelectData = "SELECT * FROM codification";
$statement = $db_php->prepare($SelectData);
$statement->execute();
$donnee = array();
while($result = $statement->fetch()){
    array_push(
        $donnee,array(
             "entite" => $result['entite'],
             "id_description" => $result['id_description'],
             "description" => $result['description'],
             "desc_crt" => $result['desc_crt'],
             "categories" => $result['categories']
        )
    );
}
echo json_encode($donnee);
