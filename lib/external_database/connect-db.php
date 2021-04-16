<?php
function connect_external_db (){
    try{
        $dB_php = new PDO("mysql:host=localhost;dbname=pam", "root", "");
        $dB_php->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
        //echo "Connection etablie avec succes";
    } catch (Exception $e){
        die('Erreur lors de la connection a la base de donnnee :'.$e->getMessage());
    }
    return $dB_php;
}
?>