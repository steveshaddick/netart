<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Ulysses Today by Steve Shaddick</title>
<meta name="description" content="James Joyce's Ulysses typed out over the course of 24 hours, every 24 hours" />

<style type="text/css">
	
	div {
		display:inline;
	} 
	
	#divTop {
		display:block;
	}
</style>

<?php

date_default_timezone_set('America/Toronto');
$now = getdate();

$percentage = (($now['hours'] * 3600) + ($now['minutes'] * 60) + $now['seconds']) / 86400;

//$percentage = ((23 * 3600) + (59 * 60) + 0) / 86400;

$charAmount = intval($percentage * 1716193);


$charCount = 0;
$lastCharCount = 0;
$charLine = 0;
$charSpeed = 19.861145833333333333333333333333;

$chapters = array();

for ($i=1; $i<=18; $i++)
{
	$filename = "$i.txt";
	$fd = fopen($filename, "r");
	$newLineChars = array("\r","\n","\n\r");
	$chapters[$i-1] = array();
	
	while(!feof($fd)) 
	{ 
		$str = str_replace($newLineChars,'',fgets($fd));
		if ($str != "") {
			$chapters[$i-1][]= utf8_encode($str) ; 
		}
	} 
	
	fclose($fd);
}

?>

<script type="text/javascript">
	var lineIndex = 0;
	var charIndex = 0;
	var chapterIndex = 0;
	var chapters = [];
	var div;
	var charSpeed = 1;
	var chars = '';
	var myHeight = 0;
	var check = 0;
	var currentCharacter = 0;
	var lastSeconds = 0;
	var totalSeconds = 0;
	
	var i = 0;
	<?php
	foreach ($chapters as $chapter)
	{
		?>
		chapters[i] = [];
		<?php
		foreach ($chapter as $line)
		{
			?>
			chapters[i].push("<?=$line?>");
			<?php
		}
		?>
		i++;
		<?php
	}
	?>
	

	  
	  if( typeof( window.innerWidth ) == 'number' ) {
		//Non-IE
		//myWidth = window.innerWidth;
		myHeight = window.innerHeight;
	  } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
		//IE 6+ in 'standards compliant mode'
		//myWidth = document.documentElement.clientWidth;
		myHeight = document.documentElement.clientHeight;
	  } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
		//IE 4 compatible
		//myWidth = document.body.clientWidth;
		myHeight = document.body.clientHeight;
	  }
	  //window.alert( 'Width = ' + myWidth );
	  //window.alert( 'Height = ' + myHeight );

	var isEnd = false;
	var speed = 51;
	var lastMillisecond = 0;
	var m=0;
	var fps = 0;
	function outputCharacter()
	{
		chars = '';
		output = '';
		needChars = 1;
		
		
		//divTop.innerHTML = speed+'    '+fps;
		/*m = now.getMilliseconds();
		if (m < lastMillisecond) {
			fps = (1000-lastMillisecond) + m;
		} else {
			fps = m - lastMillisecond;
		}
			
		lastMillisecond = m;*/
		now = new Date();
		totalSeconds = (now.getHours() * 3600) + (now.getMinutes() * 60) + (now.getSeconds());
		//divTop.innerHTML = totalSeconds;
		if (totalSeconds == 86399) {
			needChars = totalCharacters;
		} else if (day != now.getDate()) {
			for (i=0; i<totalDivs; i++)
			{
				document.getElementById('text'+i).innerHTML = '';
				
			}
			day = now.getDate();
			chapterIndex = 0;
			lineIndex = 0;
			charIndex = 0;
			lineCount = 0;
			divIndex = 0;
			currentCharacter = 0;
			div = document.getElementById('text'+divIndex);
			isEnd = false;
		} else {
			if (check > 20){			
				check = 0;
				
				percentage = totalSeconds / 86400;
				characterPosition = percentage * totalCharacters;
				needChars = parseInt(characterPosition - currentCharacter);
				
				///divTop.innerHTML = percentage+'</br/>';
				//divTop.innerHTML += needChars;
				if (needChars < 0) {
					needChars = 0;
					if (speed < 250) {
						speed ++;
					}
				} else {
					speed = 51;
				}
				if (document.body.scrollHeight > 0) {
					document.body.scrollTop  = document.body.scrollHeight;
				}
				if (document.documentElement.scrollHeight > 0) {
					document.documentElement.scrollTop = document.documentElement.scrollHeight;
				}
				
			} else {
				check ++;
			}
		}
		
		
		//divTop.innerHTML = currentCharacter;
		
		adjust = 0;
		if (!isEnd) {
			while ((chars.length < needChars) && (adjust < 5000) && (!isEnd)) {

				chars += chapters[chapterIndex][lineIndex].charAt(charIndex);
				output += chapters[chapterIndex][lineIndex].charAt(charIndex);
				currentCharacter++;
				charIndex ++;
				if (charIndex >=chapters[chapterIndex][lineIndex].length) {
					lineIndex ++;
					charIndex = 0;
					output += '<br />';
					
					if (chapterIndex < 17) {
						if (lineCount < 10) {
							lineCount ++;
						} else {
							lineCount = 0;
							divIndex ++;
							div = document.getElementById('text'+divIndex);
						}
					} else {
						lineCount = 0;
						divIndex ++;
						div = document.getElementById('text'+divIndex);
					}
					
					if (lineIndex >= chapters[chapterIndex].length) {
						lineIndex = 0;
						chapterIndex ++;
						output += '<br />';
						if (chapterIndex >= chapters.length) {
							isEnd = true;
							divIndex --;
							div = document.getElementById('text'+divIndex);
						}
					}
				}
				adjust ++;
			}
		}

		div.innerHTML += output;
		if (isEnd) {
			if (document.body.scrollHeight > 0) {
				document.body.scrollTop  = document.body.scrollHeight;
			}
			if (document.documentElement.scrollHeight > 0) {
				document.documentElement.scrollTop = document.documentElement.scrollHeight;
			}
		}
		
			
		//document.body.scrollTop = document.body.scrollHeight;
		//divTop.innerHTML += 'setting:' +document.body.scrollHeight+'     '+document.body.scrollTop;
		setTimeout(outputCharacter, speed);
	}
	
	
</script>
</head>

<body >

<div id="top">
</div>

	<?php
	$lineIndex = 0;
	$chapterIndex = 0;
	$isBreak = false;
	$divIndex = 0;
	$divCount = 0;
	$lineCount =0;
	$needClose = false;
	$totalCharacters = 0;
	foreach ($chapters as $chapter)
	{
		?>
			<?php
            
			
			foreach ($chapter as $line)
			{
				$totalCharacters += strlen($line);
				if ($chapter < 17) {
					if ($lineCount == 0) {
						echo '<div id="text'.$divCount.'">';
						if (!$isBreak) {
							$divIndex = $divCount;
						}
						$divCount++;
						$needClose = true;
					}
				} else {
					echo '<div id="text'.$divCount.'">';
					if (!$isBreak) {
						$divIndex = $divCount;
					}
					$divCount++;
					$needClose = true;
				}
				
				if (!$isBreak) {
					$charCount += strlen($line);
					
					if ($charCount <= $charAmount) {
						echo $line;
						$lineIndex ++;
						echo '<br />';
						$lastCharCount = $charCount;
					} else {
						$charLine = $charAmount-$lastCharCount;
						$lastLine = substr($line,0, $charLine);
						$lastCharCount += strlen($lastLine);
						echo $lastLine;
						$isBreak = true;
					}
					
				}
				if ($chapter < 17) {
					if ($lineCount < 10) {
						$lineCount ++;
					} else {
						echo '</div>';
						$lineCount = 0;
						$needClose = false;
					}
				} else {
					echo '</div>';
					$lineCount = 0;
					$needClose = false;
				}
			}
			if (!$isBreak) {
				$lineIndex = 0;
				$chapterIndex ++;
				//echo "add chapter";
			}
				
	}
	
	if($needClose) {
		?>
        </div>
        <?php
	}
	?>


<script type="text/javascript">
	chapterIndex = <?=$chapterIndex?>;
	lineIndex = <?=$lineIndex?>;
	charIndex = <?=$charLine?>;
	currentCharacter = <?=$lastCharCount?>;
	var lineCount = <?=$lineCount?>;
	var divIndex = <?=$divIndex?>;
	var totalDivs = <?=$divCount?>;
	var day = <?=$now['mday']?>;
	var totalCharacters = <?=$totalCharacters?>;
	
	div = document.getElementById('text'+divIndex);
	var divTop = document.getElementById('top');
	
	//divTop.innerHTML = '<?=$now['hours'].' '.$now['minutes'].' '.$now['seconds']?>';
	
	setTimeout(outputCharacter, 49);
	document.body.scrollTop = document.body.scrollHeight;
	document.documentElement.scrollTop = document.documentElement.scrollHeight;
</script>
<script>
    var _gaq=[['_setAccount','UA-2466254-1'],['_trackPageview']];
    (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
    g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
    s.parentNode.insertBefore(g,s)}(document,'script'));
  </script>
</body>
</html>