<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$itemtitle = $_POST['itemname'];
$itemdesc = $_POST['itemdesc'];
$itemprice = $_POST['itemprice'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$encoded_string = $_POST["encoded_string"];
$credit = $_POST['credit'];
$rating = $_POST['rating'];
$decoded_string = base64_decode($encoded_string);
$mydate =  date('dmYhis');
$imagename = $mydate.'-'.$email;

$sqlinsert = "INSERT INTO ITEMS(ITEMNAME,ITEMOWNER,ITEMDESC,ITEMPRICE,ITEMIMAGE,LATITUDE,LONGITUDE,RATING) VALUES ('$itemname','$email','$itemdesc','$itemprice','$imagename','$latitude','$longitude','$rating')";

if ($credit>0){
    if ($conn->query($sqlinsert) === TRUE) {
        $path = '../images/'.$imagename.'.jpg';
        file_put_contents($path, $decoded_string);
        $newcredit = $credit - 1;
        $sqlcredit = "UPDATE User SET credit = '$newcredit' WHERE email = '$email'";
        $conn->query($sqlcredit);
        echo "success";
    } else {
        echo "failed";
    }
}else{
    echo "low credit";
}

?>