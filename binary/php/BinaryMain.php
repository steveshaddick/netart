<?php
require_once(dirname(__FILE__) . '/lib/GeneralFunctions.php');

function readBinary($filename) {
	
	$handle = @fopen($filename, "rb");
	if ($handle === false) return false;

	$contents = '';
	while (!feof($handle)) {
	  $contents .= fread($handle, 8192);
	}

	$size = strlen($contents);
	$ret= array(0, 0);

	$ret['all'] = '';
	for($i = 0; $i < $size; $i++)
	{ 
	   // get the current ASCII character representation of the current byte
	   $asciiCharacter = $contents[$i];
	   // get the base 10 value of the current characer
	   $base10value = ord($asciiCharacter);
	   // now convert that byte from base 10 to base 2 (i.e 01001010...)
	   $base2representation = strval(base_convert($base10value, 10, 2));
	   // print the 0s and 1s
	   //echo($base2representation);
	   //echo "<br />";

	  	$ret[0] += (8 - strlen($base2representation));
	   	$ret[1] += substr_count($base2representation, "1");
		$ret[0] += substr_count($base2representation, "0");

		$ret['all'] .= $base2representation;
	}



	fclose($handle);

	return $ret;
}

function returnJSON($ret) {
	header('Content-type: application/json');
	return json_encode($ret);
}

session_start();

$action = isset($_POST['action']) ? $_POST['action'] : 'init';

$ret = array('success'=>'false');
switch ($action) {
	case 'init':
		
		$_SESSION['id'] = randomString(10);
		$ret['success']= true;

		break;

	case 'readLink':

		sleep(1);
		$id = initVariable($_POST['id'], 'a1', 'string');
		if ($id !== $_SESSION['id']) {
			echo returnJSON($ret);
			break;
		}

		if (isset($_SESSION['lastCall'])) {
			if ((time() - $_SESSION['lastCall']) < 1) {
				echo returnJSON($ret);
				break;
			}
		} 

		$_SESSION['lastCall'] = time();

		$url = initVariable($_POST['url'], '', 'string');

		if (strpos($url, 'http') === false) {
			$url = 'http://' . $url;
		}

		$binary = readBinary($url);
		if ($binary === false) {
			$ret['url'] = $url;
			echo returnJSON($ret);
			break;
		}

		$ret['binary'] = $binary;

		$ret['success'] = 'true';
		echo returnJSON($ret);
		break;

}


?>