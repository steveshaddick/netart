<?php

require_once('php/BinaryMain.php');

?><!doctype html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
  <meta charset="utf-8">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

  <title>ww n01se</title>
  <meta name="description" content="Web pages as digital essence, as zeroes and ones, as black and white.">

  <meta name="viewport" content="width=device-width">

  <link rel="stylesheet" href="css/style.css">

</head>
<body>
  <!-- Prompt IE 6 users to install Chrome Frame. Remove this if you support IE 6.
       chromium.org/developers/how-tos/chrome-frame-getting-started -->
  <!--[if lt IE 7]><p class=chromeframe>Your browser is <em>ancient!</em> <a href="http://browsehappy.com/">Upgrade to a different browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">install Google Chrome Frame</a> to experience this site.</p><![endif]-->

  <div id="mainWrapper">
    <h1>ww n01se</h1>
    <p>Web pages as digital essence, as zeroes and ones, as black and white.</p>
    <form id="frmLink" action="#" method="POST">
    	<label for="txtLink">enter url:</label>
    	<input type="text" id="txtLink" class="" name="txtLink" maxlength="255" /> <img id="spinner" class="spinner disabled" src="images/spinner.png" alt="" /> <span id="urlError" class="urlError disabled">Cannot read url.</span>
    </form>


    <div id="outputArea">
     <div id="resultsHeader"><span id="urlResponse">&nbsp;</span></div>
    </div>
    <div id="bits"><canvas id="canvas">There's more here, but your browser can't see it.</canvas></div>
  </div>


  <!-- JavaScript at the bottom for fast page loading: http://developer.yahoo.com/performance/rules.html#js_bottom -->

  <!-- Grab Google CDN's jQuery, with a protocol relative URL; fall back to local if offline -->
  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  <script>window.jQuery || document.write('<script src="js/vendor/jquery-1.7.2.min.js"><\/script>')</script>

  <!-- scripts concatenated and minified via build script -->
  <script src="js/main.js"></script>
  <script>
  	$(document).ready(function() { Main.init({id: '<?php echo $_SESSION['id']; ?>'}); });
  </script>

  <script>
        var _gaq=[['_setAccount','UA-2466254-1'],['_trackPageview']];
        (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
        g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
        s.parentNode.insertBefore(g,s)}(document,'script'));
    </script>

</body>
</html>
