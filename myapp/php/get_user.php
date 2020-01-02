<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM User WHERE email = '$email'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success,".$row["name"].",".$row["email"].",".$row["phone"].",".$row["credit"].",".$row["date"];
    }
}else{
    echo "failed,null,null,null,null,null";
}