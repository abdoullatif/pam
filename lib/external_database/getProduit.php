<?php
require('connect-db.php');
$db_php = connect_external_db();
$SelectData = "SELECT * FROM produits";
$statement = $db_php->prepare($SelectData);
$statement->execute();
$donnee = array();
while($result = $statement->fetch()){
    array_push(
        $donnee,array(
             "id" => $result['id'],
             "idproduit" => $result['idproduit'],
             "designation" => $result['designation'],
             "pu" => $result['pu'],
             "image" => $result['image'],
        )
    );
}
echo json_encode($donnee);