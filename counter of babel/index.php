<?php

session_start();
if (!isset($_SESSION['time'])) {
		
	$_SESSION['time'] = time();
}

?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Counter of Babel</title>
<meta name="description" content="The goal of the Counter of Babel is to discover the true number of infinity." />
<meta name="keywords" content="counter of babel, counter, babel, infinity, infinite, steve shaddick" />

<script type="text/javascript">
var numCount = 0; //the periodic counter

var base = 999999999; //the maximum number each cell can hold
var maxCol = 100; //the amount of columns in the database / array
var maxRow = 1000; //the amount of rows per table

var maxChars = 100; //the maximum amount of chars allowed in the output - the database is still updated correctly, the displayed number is simply truncated due to resource limitations
var babel = new Array(); //the array of units

<?php

require_once('_init.php');

// see here: https://www.php.net/manual/en/class.mysqli-result.php#109782
function mysqli_result($res, $row, $field=0) {
	$res->data_seek($row);
	$datarow = $res->fetch_array();
	return $datarow[$field];
}

$add = false;
$time= time();
if ((isset($_POST['add'])) && (($time - $_SESSION['time']) >= 6)){
	$add = ($_POST['add']=="true")? true: false;
	
}
$_SESSION['time'] = $time;

$addTen = false; //if unit numbers need to be turned over

$raw = $mysqli->query("SHOW TABLES");
$countTable = $raw->num_rows;

//retrieves the unit array and passed it to javascript
for ($t=0; $t<$countTable; $t++){
	echo "babel[$t] = new Array();";
	$t_raw = $mysqli->query("SELECT COUNT(*) FROM `$t`");
	$countRow = mysqli_result($t_raw,0);
	
	for ($r=0; $r<$countRow; $r++){
		echo "babel[$t][$r] = new Array();";
		$r_raw = $mysqli->query("SHOW COLUMNS FROM `$t`");
		$countCol = $r_raw->num_rows - 1; //discount the id column
		 
		for ($c=0; $c<$countCol; $c++){
			$c_raw = $mysqli->query("SELECT `$t`.`$c` FROM `$t` WHERE id = $r");
			$num = mysqli_result($c_raw,0);
			
			if (!is_null($num)){
				if (($c==0) && ($add)){
					if (($num + 33) <=999999999){
						$num += 33;
						$add = false;
					} else {
						//turn over unit count
						$num = 33 - (1000000000 - $num);
						$add = false;
						$addTen = true;
					}
					$mysqli->query("UPDATE `$t` SET `$c`=$num WHERE id = $r");
				}
				
				if (($addTen) && (($c>0) || (($c==0) && ($r>0)) || (($c==0) && ($t>0)))){
					if ($num < 999999999){
						$num++;
						$addTen = false;
					} else {
						$num = 0;
					}
					$mysqli->query("UPDATE `$t` SET `$c`=$num WHERE id = $r");
				}
				echo "babel[$t][$r][$c] = $num;";
			$lastc = $c;
			}
		}
	}
}

if ($addTen){
	$t--;
	$r--;
	if ($lastc < ($countCol-1)){
		$c = $lastc + 1;
		$mysqli->query("UPDATE `$t` SET `$c`=1 WHERE id = $r");
		echo "babel[$t][$r][$c] = 1;";
	} else {
		if ($lastc < 1){
			$c = $lastc + 1;
			$mysqli->query("ALTER TABLE `$t` ADD `$c` INT(9) UNSIGNED NULL");
			$mysqli->query("UPDATE `$t` SET `$c`=1 WHERE id = $r");
			echo "babel[$t][$r][$c] = 1;";
		} else {
			$c = 0;
			if ($r<1){
				$r++;
				$mysqli->query("INSERT INTO `$t` (`id`,`0`) VALUES ($r,1)");
				echo "babel[$t][$r] = new Array();";
				echo "babel[$t][$r][0] = 1;";
			} else {
				$r = 0;
				$t++;
				$mysqli->query("CREATE TABLE `$t` (`id` MEDIUMINT( 5 ) UNSIGNED NOT NULL ,`0` INT( 9 ) UNSIGNED NULL ,PRIMARY KEY ( `id` )) ENGINE = MYISAM");
				$mysqli->query("INSERT INTO `$t` (`id`,`0`) VALUES ($r,1)");
				echo "babel[$t] = new Array();";
				echo "babel[$t][0] = new Array();";
				echo "babel[$t][0][0] = 1;";
			}
		}
	}
}

$mysqli->close();
?>

function add(arr,t,r,c){
	
	//add 1 to current count
	if (arr[t][r][c] < base){
		arr[t][r][c]++;
	} else {
		arr[t][r][c]=0;
		if (c < maxCol){
			c++;
			if (arr[t][r][c] != null){
				add(arr,t,r,c);
			} else {	
				arr[t][r][c] = 1;
			}		
		} else {
			c = 0;
			if (r < maxRow){
				r++;
				if (arr[t][r] != null){
					add(arr,t,r,c);
				} else {
					arr[t][r] = new Array();
					arr[t][r][c] = 1;
				}
			} else {
				r=0;
				t++;
				if (arr[t] != null){
					add(arr,t,r,c);
				} else {
					arr[t] = new Array();
					arr[t][r] = new Array();
					arr[t][r][c] = 1;
				}
			}
		}
	}
}

function formString(arr,id){
	//output the array
	
	var strTmp = "";
	var strZeroes = "";
	var widthCount = 0;
	
	document.getElementById(id).innerHTML = "";
	
	var charCount = 0;
	var charMaxed = false;
	
	for (var t=0; t<arr.length; t++){
		for (var r=0; r<arr[t].length; r++){
			for (var c=0; c<arr[t][r].length; c++){
				
				if (arr[t][r][c] != null){
					if (charCount < maxChars){

						var strZeroes = "";
						strTmp = arr[t][r][c].toString();
						
						if (!((c==arr[t][r].length-1) && (r==arr[t].length-1) && (t==arr.length-1))){
							for (var pad=0; pad<(9-strTmp.length); pad++){
								strZeroes += "0";
							}
						}
						widthCount += strZeroes.length + strTmp.length;

						if (widthCount > 100){
							document.getElementById(id).innerHTML = "<br>"+document.getElementById(id).innerHTML;
							widthCount = 0;
						}
						document.getElementById(id).innerHTML = strZeroes + strTmp + document.getElementById(id).innerHTML;
					} else {
						strTmp = arr[t][r][c].toString();
						charMaxed = true;
					}
					charCount ++;
				}
			}
		}
	}

	if (charMaxed){
		document.getElementById(id).innerHTML = strTmp + " ... " + document.getElementById(id).innerHTML;
	}
}

function output(){
	//the recursive function
	formString(babel, "number");
	if (numCount < 33){
		numCount++;
		add(babel,0,0,0);
		setTimeout("output()", 200);
	} else {
		document.frmSender.add.value = "true";
		document.frmSender.submit();
	}
}

</script>


<link href="babel.css" rel="stylesheet" type="text/css" />
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="222" rowspan="2" bgcolor="#C5F4FE"><span class="style1"><img src="images/tower.jpg" alt="tower" width="222" height="471" /></span></td>
    <td width="80%" bgcolor="#F1E0E6"><h1><span class="style3">The Counter of Babel</span></h1></td>
  </tr>
  <tr>
    <td valign="top" bgcolor="#C5F4FE" class="maintext"><h2>by Steve Shaddick </h2>
      <p>No longer shall the concept of the infinite lie beyond tangibility, evading our grasp by begging its own question. No longer shall we bow to those who flippantly dismiss infinity as an impossible destination - indeed, impossible destinations are most often the best destinations of all. The mysteries of infinity need not continue to taunt us behind curtains of presumed invincibility - we must draw them into the open. Perhaps not today, perhaps not tomorrow, but this counter will eventually reach that horizon.      </p>
      <table width="90%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
        <tr>
          <td height="20" class="number" id="number">0</td>
        </tr>
      </table>
    <p>The above counter is counting to infinity. It only counts when someone is on the site, and if there are multiple people on the site at the same time, the numbers will increase faster. Help us break the chains of infinity's tyranny by visiting often and remaining on the site for as long as possible.</p>
    <p>Please read the <a href="babel_faq.html" target="_blank">FAQ</a> for more information. </p></td>
  </tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="#F1E0E6"><p align="right"><a href="https://steveshaddick.com" class="maintext" target="_blank">by Steve</a></p>
    </td>
  </tr>
</table>

<form action="index.php" method='post' name='frmSender'>
<input name='add' type='hidden'>
</form>
<script type="text/javascript">output();</script>
<script type="text/javascript">document.frmSender.add.value = "false";</script>
<script>
    var _gaq=[['_setAccount','UA-2466254-1'],['_trackPageview']];
    (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
    g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
    s.parentNode.insertBefore(g,s)}(document,'script'));
</script>

</body>
</html>
