<?php
require('connect-db.php');
$db_php = connect_external_db();
$SelectData = "SELECT * FROM personne";
$statement = $db_php->prepare($SelectData);
$statement->execute();
$donnee = array();
while($result = $statement->fetch()){
    array_push(
        $donnee,array(
             "idpersonne" => $result['idpersonne'],
             "nom" => $result['nom'],
             "prenom" => $result['prenom'],
             "date_naissance" => $result['date_naissance'],
             "idgenre" => $result['idgenre'],
             "date_creation" => $result['date_creation'],
             "iud" => $result['iud'],
             "email" => $result['email'],
             "mdp" => $result['mdp'],
             "image" => $result['image'],
             "flagtransmis" => $result['flagtransmis'],
        )
    );
}
echo json_encode($donnee);
