<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$temppass = $_POST['temppass'];
$temppasssha = sha1($temppass);
$newpass = $_POST['newpass'];
$newpasssha = sha1($newpass);

$sqls = "SELECT * FROM User WHERE email ='$email' AND password ='$temppasssha' AND verify='1'";
$result = $conn->query($sqls);

if($result->num_rows>0){
    $sql = "UPDATE User SET password='$newpasssha' WHERE email = '$email'";
    if($conn->query($sql) === TRUE){
        echo "Success";
    }
}else{
    echo "Incorrect Password";
}
