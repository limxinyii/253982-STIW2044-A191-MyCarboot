<?php
$servername = "localhost";
$username 	= "myondbco_myappadmin";
$password 	= "}VZ-KRUFRf0Y";
$dbname 	= "myondbco_myapp";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>