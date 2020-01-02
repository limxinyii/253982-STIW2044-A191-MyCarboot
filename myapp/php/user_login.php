<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
//$password = $_POST['password'];
$passwordsha = sha1($_POST['password']);

$sql = "SELECT * FROM User WHERE email = '$email' AND password = '$passwordsha' AND verify ='1'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "Login Successful,".$row["name"].",".$row["email"].",".$row["phone"].",".$row["credit"];
    }
}else{
    echo "Enter wrong email or password,null,null,null,null";
}