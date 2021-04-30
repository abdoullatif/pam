<?php
require('connect-db.php');
$db_php = connect_external_db();
$SelectData = "SELECT * FROM ecole";
$statement = $db_php->prepare($SelectData);
$statement->execute();
$donnee = array();
while($result = $statement->fetch()){
    array_push(
        $donnee,array(
             "id" => $result['id'],
             "idlocalite" => $result['idlocalite'],
             "idpersonne" => $result['idpersonne'],
             "nom_ecole" => $result['nom_ecole'],
             "flagtransmis" => $result['flagtransmis'],
        )
    );
}
echo json_encode($donnee);