<?php
error_reporting(0);
include_once("dbconnect.php");
$itemid = $_POST['itemid'];
$sql     = "DELETE FROM ITEMS WHERE itemid = $itemid";
    if ($conn->query($sql) === TRUE){
        echo "success";
    }else {
        echo "failed";
    }

$conn->close();
?>