// JavaScript Document
var page = 0;
var isWaiting = false;
var lastID = 0;
var lastTime = 0;

function nextPage()
{
	page ++;
	checkNumbers(true);
}
function previousPage()
{
	page --;
	checkNumbers(true);
}

function checkNumbers(forceCheck)
{
	if (forceCheck == null) {
		forceCheck = false;
	}
	
	if (isWaiting) return;
	if ((page > 0) && (!forceCheck)) return;
	if (forceCheck) {
		$('#guessedNumbers').html('loading...');
		window.scroll(0,0);
	}
	
	$.ajax({
		  url: 'checkNumbers.php',
		  data: ({
					page: page,
					lastID: lastID
					}),
		  type:"POST",
		  dataType: 'json',
		  success: showGuessed
		});
}
function showGuessed(data)
{
	isWaiting = false;
	
	if (data.guesses.length == 0) return;
	
	var html = '';
	lastID = data.guesses[0]['guess_id'];
	for (var i=0; i < data.guesses.length; i++)
	{
		html += data.guesses[i]['guess'] + '<br />';
	}
	
	if ($('#guessedNumbers').html() == 'loading...') {
		$('#guessedNumbers').html('');
	}
	
	$('#guessedNumbers').html(html + $('#guessedNumbers').html() );
	
	if (data.next) {
		$('#nextPage').css('visibility', 'visible');
	} else {
		 $('#nextPage').css('visibility', 'hidden');
	}
	
	if (data.previous) {
		$('#previousPage').css('visibility', 'visible');
	} else {
		 $('#previousPage').css('visibility', 'hidden');
	}
	
	if (page > 0) {
		lastID = 0;
	}
}
function guessNumber()
{
	var time = new Date().getTime();
	time = parseInt(time/1000);
	
	if (time <= lastTime) {
		alert('You may only make one guess per second.');
		return;
	}
	
	var str = $('#txtGuess').val();
	str = str.replace(/[^0-9]+/g , '');
	$('#txtGuess').val(str);
	
	if ($('#txtGuess').val() == '') return;
	
	$('#guessStatus').html("Checking...");
	
	isWaiting = true;

	setTimeout(sendGuess, 2000);
	
}

function sendGuess()
{
	$.ajax({
		  url: 'guessNumber.php',
		  data: ({
					guess: $('#txtGuess').val()
					}),
		  type:"POST",
		  dataType: 'json',
		  success: guessResult
		});
}

function guessResult(data)
{
	isWaiting = false;

	if (data.guessed) {
		alert('This is amazing!  You have guessed the number!');
		window.location = "amazing.php";
		return;
	}
	
	$('#txtGuess').val('');
	$('#guessStatus').html(data.message);
	
}

//disables enter key from sending form data
function disableEnterKey(e)
{
     var key;      
     if(window.event)
          key = window.event.keyCode; //IE
     else
          key = e.which; //firefox  
     
	 if (key == 13) {
		 guessNumber();
	 }

     return (key != 13);
}

function filter(e)
{
	 var key;      
     if(window.event)
          key = window.event.keyCode; //IE
     else
          key = e.which; //firefox      

	var ret = ((key <32) || ((key>=48) && (key<=57)) || (key ==127))? true : false;	
	
     return ret;
}