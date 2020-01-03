<?php
error_reporting(0);
include_once("dbconnect.php");
$itemid = $_POST['itemid'];
$email = $_POST['email'];
$credit = $_POST['credit'];
$itemprice = $_POST['itemprice'];

$sql = "UPDATE ITEMS SET ITEMWORKER = '$email'  WHERE ITEMID = '$itemid'";
if ($conn->query($sql) === TRUE) {
    $newcredit = $credit - $itemprice;
    $sqlcredit = "UPDATE User SET credit = '$newcredit' WHERE email = '$email'";
    $conn->query($sqlcredit);
    echo "success";
} else {
    echo "error";
}

$conn->close();
?>
