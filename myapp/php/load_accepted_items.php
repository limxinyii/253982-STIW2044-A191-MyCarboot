<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM ITEMS WHERE ITEMWORKER = '$email' ORDER BY ITEMID DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["items"] = array();
    while ($row = $result ->fetch_assoc()){
        $itemlist = array();
        $itemlist[itemid] = $row["ITEMID"];
        $itemlist[itemname] = $row["ITEMNAME"];
        $itemlist[itemowner] = $row["ITEMOWNER"];
        $itemlist[itemprice] = $row["ITEMPRICE"];
        $itemlist[itemdesc] = $row["ITEMDESC"];
        $itemlist[itemtime] = date_format(date_create($row["pITEMTIME"]), 'd/m/Y h:i:s');
        $itemlist[itemimage] = $row["ITEMIMAGE"];
        $itemlist[itemlatitude] = $row["LATITUDE"];
        $itemlist[itemlongitude] = $row["LONGITUDE"];
        $itemlist[itemrating] = $row["RATING"];
        array_push($response["items"], $itemlist);    
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>