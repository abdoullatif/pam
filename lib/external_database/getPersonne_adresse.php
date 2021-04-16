<?php
require('connect-db.php');
$db_php = connect_external_db();
$SelectData = "SELECT * FROM personne_adresse";
$statement = $db_php->prepare($SelectData);
$statement->execute();
$donnee = array();
while($result = $statement->fetch()){
    array_push(
        $donnee,array(
             "idpersonne_adresse" => $result['idpersonne_adresse'],
             "idlocalite" => $result['idlocalite'],
             "idpersonne" => $result['idpersonne'],
             "adresse" => $result['adresse'],
             "flagtransmis" => $result['flagtransmis'],
        )
    );
}
echo json_encode($donnee);