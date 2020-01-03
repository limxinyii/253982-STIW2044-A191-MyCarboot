<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];
$sql = "UPDATE User SET verify = '1' WHERE EMAIL = '$email'";
if ($conn->query($sql) === TRUE) {
    echo "Email Verified! You can login to My Carboot now";
} else {
    echo "error";
}
$conn->close();
?>