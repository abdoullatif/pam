<?php
require('connect-db.php');
$db_php = connect_external_db();
$SelectData = 'SELECT * FROM stock WHERE idproduit = '.$_GET['idproduit'].'';
$statement = $db_php->prepare($SelectData);
$statement->execute();
$donnee = array();
while($result = $statement->fetch()){
    array_push(
        $donnee,array(
             "id" => $result['id'],
             "idcommercant" => $result['idcommercant'],
             "idproduit" => $result['idproduit'],
             "quantite" => $result['quantite'],
        )
    );
}
echo json_encode($donnee);