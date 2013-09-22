<?php

require_once(dirname(__FILE__) . '/_init.php');

$pathString = $_POST['pathString'];
$fromdir = $_POST['fromdir'];



if ($pathString != "start"){
	$distance = strlen($pathString);
	switch ($fromdir){
		case "L":
		$fromColumn = "from_left";
		break;
		
		case "R":
		$fromColumn = "from_right";
		break;
	}
	
} else {
	$distance = 0;
	/*$dp = fopen("datehold.txt","rb+");
	$oldate = fread($dp,1024);
	$today = getdate();
	if ($today[yday] != trim($oldate)){
		$insert = mysql_query("UPDATE distance SET travels=travels-1, $fromColumn=$fromColumn+1 WHERE distance_id=$distance");
		fseek($dp,0);
		fwrite($dp,$today[yday]."\n");
		fclose($dp);
	}*/

	
	if (rand(1,2) == 2){
		$fromColumn = "from_left";
	} else {
		$fromColumn = "from_right";
	}
}

//stupid mysql version 3
if (mysql_num_rows(mysql_query("SELECT distance_id FROM distance WHERE distance_id=$distance"))==0){
	$insert = mysql_query("INSERT INTO distance(distance_id, travels, $fromColumn) VALUES ($distance,1,1)");
} else {
	$insert= mysql_query("UPDATE distance SET travels=travels+1, $fromColumn=$fromColumn+1 WHERE distance_id=$distance");
}

if (mysql_num_rows(mysql_query("SELECT path_string FROM path WHERE path_string='$pathString'"))==0){
	$insert = mysql_query("INSERT INTO path(path_string, population) VALUES ('$pathString',1)");
} else {
	$insert= mysql_query("UPDATE path SET population=population+1 WHERE path_string='$pathString'");
}



$path = mysql_fetch_array(mysql_query("SELECT population FROM path WHERE path_string='$pathString'")) or die ("error='getting population'");

$distance = mysql_fetch_array(mysql_query("SELECT travels,from_left,from_right FROM distance WHERE distance_id=$distance")) or die ("error='getting distance'");



print("population=".$path['population']."&travels=".$distance['travels']."&fromleft=".$distance['from_left']."&fromright=".$distance['from_right']);

mysql_close();
?>
