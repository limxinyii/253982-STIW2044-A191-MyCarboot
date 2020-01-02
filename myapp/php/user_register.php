<?php
//error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$sqlinsert = "INSERT INTO User(name,email,password,phone,verify,credit,rating) VALUES ('$name','$email','$password','$phone','0','100')";
if ($conn->query($sqlinsert) === TRUE) {
    $path = '../profile/'.$email.'.jpg';
    file_put_contents($path, $decoded_string);
    sendEmail($email);
    echo "registered";
} else {
    echo "Email Registered! Please try again";
}
function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for Login'; 
    $message = 'http://myondb.com/myapp/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@myapp.com.my' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}
?>