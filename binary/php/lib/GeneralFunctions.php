<?php

/**
 * @title 	General functions
 * @author	Steve Shaddick
 *
 * @description 	A collection of general-use functions					
 * @tags security, utility 
 *
 *
 */



/**********************
 * @function	initVariable
 * @version 	1.0
 * @description 	checks a variable, sets it to a default value or forces it into a type, and cleans it if necessary
 * @input	$var (variable) : the variable in question (usually $_POST['someting'])
			$default (mixed) : the default value. DEFAULT null.
			$type (string) : the variable type, according to php.  DEFAULT string.
			$mySQL (MySQLUtility) : a MySQLUtility instance for cleaning strings.  DEFAULT null.
	
 * @output the value
			
 */
function initVariable($var, $default = NULL, $type='string', $mySQL = NULL)
{
	if (isset($var)) {
		$ret = $var;
		settype($ret, $type);
		if (($type == '$string') && (!is_null($mySQL))) {
			$ret = $mySQL->cleanString($ret);
		}
		return $ret;
	} else {
		return $default;
	}
}



/**********************
 * @function	returnMessage
 * @version 	1.0
 * @description 	used for sending XML return messages, probably to Flash
 * @input	$isGood (boolean) : if the return is good or not. DEFAULT true.
 			$arr (array) : an associative array of name/value pairs. DEFAULT null.
				
 * @output an XML-formatted string, with <ret> indicating success
			
 */
function returnMessage($isGood = true, $arr = NULL)
{
	$str = '<?xml version="1.0" encoding="utf-8"?>';
	$ret .= '<data>';
	if ($isGood) {
		$ret .= '<ret>true</ret>';
	} else {
		$ret .= '<ret>false</ret>';
	}
	
	if (!is_null($arr)) {
		foreach ($arr as $key=>$value)
		{
			$ret .= "<$key>$value</$key>";
		}
	}
	
	$ret .= '</data>';
	
	return $ret;
}



/**********************
 * @function	deleteAllFiles
 * @version 	1.1
 * @description 	deletes all files from a folder
 * @input	$folder (string) : the folder from which to delete all files
 			$deleteFolder (boolean) : whether or not to delete the folder itself. DEFAULT false.
				
 * @output true on success, false on failure
			
 */
function deleteAllFiles($folder, $deleteFolder = false)
{
	if ($handle = opendir($folder)) {
		while (false !== ($file = readdir($handle))) {
			if (($file != '.') && ($file != '..')) {
				unlink("$folder/$file");
			}
		}
		closedir($handle);
		
		if ($deleteFolder) {
			rmdir($folder);
		}
		return true;
	} else {
		trigger_error("Could not open $folder.", E_USER_ERROR);
		return false;
	}
}


/**********************
 * @function	randomString
 * @version 	1.1
 * @description 	generates a random alpha-numeric string.  NOT A UID, but acceptable in a lot of scenarios.
 * @input	$length (integer) : the length of the resulting string.  DEFAULT 8.
				
 * @output 	an alpha-numberic string,
 			or false on error
			
 */
function randomString($length = 8)
{
	if ($length < 1) {
		trigger_error("randomString length must be at least 1.", E_USER_ERROR);
		return false;
	}
	
	$str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	$total = strlen($str) - 1;
	
	$rand = "";
	for ($i = 0; $i < $length; $i++){
		$rand .= substr($str, rand(0, $total), 1);
	}
	
	return $rand;
}

?>