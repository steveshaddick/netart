<?php

require_once('includes/MySQLUtility.php');
require_once('includes/Encryptor.php');

define('DB_USER','[USER]');
define('DB_PASSWORD','[PASSWORD]');
define('DB_LOCATION','localhost');
define('DB_NAME','number');

define('SMTP_HOST','[HOST]');
define('SMTP_USERNAME','[USERNAME]');
define('SMTP_PASSWORD','[PASSWORD]');
define('SMTP_PORT',587);
define('SALT','[SALT]');

$mySQL = new MySQLUtility(DB_USER, DB_PASSWORD, DB_LOCATION, DB_NAME);
$date = date("Y-m-d H:i:s");

session_start();


?>