<?php
require('connect-db.php');
$db_php = connect_external_db();
$SelectData = "SELECT * FROM localite";
$statement = $db_php->prepare($SelectData);
$statement->execute();
$donnee = array();
while($result = $statement->fetch()){
    array_push(
        $donnee,array(
            "idLocalite" => $result['IdLocalite'],
             "descLocalite" => $result['DscLocalite'],
             "entiteTypelocalite" => $result['TypeLocalite'],
             "idTypelocalite" => $result['IdTypeLocalite'],
             "flag_transmis" => $result['flagtransmis']
        )
    );
}
echo json_encode($donnee);
