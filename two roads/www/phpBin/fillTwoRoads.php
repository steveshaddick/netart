<?php

require_once(dirname(__FILE__) . '/_init.php');

mysql_query("DELETE FROM path WHERE path_id>0") or die ("can't delete path");
mysql_query("UPDATE path SET population=0,path_string='start' WHERE path_id=0");
mysql_query("ALTER TABLE `path` PACK_KEYS =0 CHECKSUM =0 DELAY_KEY_WRITE =0 AUTO_INCREMENT =1") or die("can't alter path");

mysql_query("DELETE FROM distance WHERE distance_id>0") or die ("can't delete distance");
mysql_query("UPDATE distance SET travels=0,from_left=0,from_right=0 WHERE distance_id=0");


for ($i=1; $i<500; $i++){
	$pathString = "start";
	for ($j=1; $j<=30; $j++){
		if (rand(1,100) < (2*$j)) break;
		if ($j == 1){
			$pathString = "start";
		} else {
			if ($j == 2){
				$pathString = "";
			}
			if (rand(1,2) == 1){
				$fromdir = "L";
			} else {
				$fromdir= "R";
			}
			$pathString.= $fromdir;
		}
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
			
}
print("$i\n");
}



mysql_close();
?>
