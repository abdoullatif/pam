<?php
require('connect-db.php');
$db_php = connect_external_db();
$SelectData = "SELECT * FROM personne_tel";
$statement = $db_php->prepare($SelectData);
$statement->execute();
$donnee = array();
while($result = $statement->fetch()){
    array_push(
        $donnee,array(
             "idpersonne_tel" => $result['idpersonne_tel'],
             "idpersonne" => $result['idpersonne'],
             "numero_tel" => $result['numero_tel'],
             "flagtransmis" => $result['flagtransmis'],
        )
    );
}
echo json_encode($donnee);