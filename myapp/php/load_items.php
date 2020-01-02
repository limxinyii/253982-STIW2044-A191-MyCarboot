<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];

$sql = "SELECT * FROM ITEMS WHERE ITEMWORKER IS NULL ORDER BY ITEMID DESC";

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
        $itemlist[itemtime] = date_format(date_create($row["ITEMTIME"]), 'd/m/Y h:i:s');
        $itemlist[itemimage] = $row["ITEMIMAGE"];
        $itemlist[itemlatitude] = $row["LATITUDE"];
        $itemlist[itemlongitude] = $row["LONGITUDE"];
        $itemlist[km] = distance($latitude,$longitude,$row["LATITUDE"],$row["LONGITUDE"]);
        $itemlist[itemrating] = $row["RATING"];
        
        array_push($response["items"], $itemlist);    
   }
    echo json_encode($response);
}else{
    echo "nodata";
}

function distance($lat1, $lon1, $lat2, $lon2) {
   $pi80 = M_PI / 180;
    $lat1 *= $pi80;
    $lon1 *= $pi80;
    $lat2 *= $pi80;
    $lon2 *= $pi80;

    $r = 6372.797; // mean radius of Earth in km
    $dlat = $lat2 - $lat1;
    $dlon = $lon2 - $lon1;
    $a = sin($dlat / 2) * sin($dlat / 2) + cos($lat1) * cos($lat2) * sin($dlon / 2) * sin($dlon / 2);
    $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
    $km = $r * $c;

    //echo '<br/>'.$km;
    return $km;
}

?>