<?php

require_once('includes/_init.php');

$result = $mySQL->sendQuery("SELECT guessed FROM Number");

if ($result[0]['guessed'] == 1) {
	header("location: /guessed.php");
}


?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="title" content="I am thinking of a number between 1 and 9,223,372,036,854,775,807" />
<meta name="description" content="I am thinking of a number between 1 and 9,223,372,036,854,775,807.  Try to guess what it is!" />
<meta name="keywords" content="Number, guess, ridiculous, steve shaddick" />

<title>I am thinking of a number between 1 and 9,223,372,036,854,775,807</title>
<link href="number.css" rel="stylesheet" type="text/css" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>
<script type="text/javascript" src="js/number.js"></script>

</head>

<body onkeypress="return disableEnterKey(event);">
<div id="mainWrapper">
    
    
    <h1>I am thinking of a number between 1 and 9,223,372,036,854,775,807</h1>
    <p>Try to guess what it is:</p>
    <form id="frm">
    <input type="text" maxlength="19" style="width:250px;" name="txtGuess" id="txtGuess" onkeypress="return filter(event);"/>
    <input type="button" onclick="guessNumber();" value="Guess" />
    </form>
    <div id="guessStatus">
    </div>
    <br />
    <br />
    <h2>Guessed Numbers</h2>
    <hr />
    <div id="guessedNumbers">
    </div>
    <hr />
    <div id="pagination" >
    	<div id="previousPage"><a href="#" onclick="previousPage(); return false;">< previous</a></div>
        <div id="nextPage"><a href="#" onclick="nextPage(); return false;">next ></a></div>
    </div>
    <br />
    <br clear="all" />
    <div id="footer">by <a href="http://www.steveshaddick.com" target="_blank">Steve Shaddick</a></div>
</div>

<script type="text/javascript">
<!--

checkNumbers();
setInterval(function() { checkNumbers(false); },3000);

-->
</script>
<script>
    var _gaq=[['_setAccount','UA-2466254-1'],['_trackPageview']];
    (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
    g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
    s.parentNode.insertBefore(g,s)}(document,'script'));
</script>
</body>
</html>