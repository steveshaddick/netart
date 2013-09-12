<?php

require_once('includes/_init.php');

$result = $mySQL->sendQuery("SELECT guessed FROM Number");

if ($result[0]['guessed'] == 0) {
	header("location: /");
}


?>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>The number was guessed!</title>
<link href="number.css" rel="stylesheet" type="text/css" />
</head>

<body>
<div id="mainWrapper">

<h1>The Number Has Been Guessed</h1>
<p>
...possibly.  I'm in the process of validating the guess.  Check back in a few days to see if it's true or not.
</p>

    
</div>

</body>
</html>