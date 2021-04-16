<?php
require('connect-db.php');
$db_php = connect_external_db();
$SelectData = "SELECT * FROM personne_fonction";
$statement = $db_php->prepare($SelectData);
$statement->execute();
$donnee = array();
while($result = $statement->fetch()){
    array_push(
        $donnee,array(
             "idpersonne_fonction" => $result['idpersonne_fonction'],
             "idpersonne" => $result['idpersonne'],
             "idtype_fonction" => $result['idtype_fonction'],
             "flagtransmis" => $result['flagtransmis'],
        )
    );
}
echo json_encode($donnee);