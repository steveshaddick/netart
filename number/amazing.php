<?php

require_once('includes/_init.php');

$result = $mySQL->sendQuery("SELECT guessed FROM Number");

if ($result[0]['guessed'] == 0) {
	header("location: /guessed.php");
}

$action = isset($_POST['action']) ? $_POST['action'] : '';
$message = '';

if ($action == 'email') {
	$email = isset($_POST['txtEmail']) ? $_POST['txtEmail'] : '';

	$to = "steve@steveshaddick.com";
	$subject = "This person guessed the number";
	$body = "Time: $date\n\r\n\r";
	$body .= "IP: ".$_SERVER['REMOTE_ADDR']."\n\r\n\r";
	$body .= "Email: $email";
	
	$mail = new PHPMailer;
	$mail->IsSMTP();                                      // Set mailer to use SMTP
	$mail->Host = 'smtp.sendgrid.net';  // Specify main and backup server
	$mail->SMTPAuth = true;                               // Enable SMTP authentication
	$mail->Username = SENDGRID_USERNAME;                            // SMTP username
	$mail->Password = SENDGRID_PASSWORD;                           // SMTP password

	$mail->AddAddress($to);  // Add a recipient


	$mail->Subject = $subject;
	$mail->Body    = $body;
	//$mail->AltBody = convert_html_to_text($message);
	$mail->Send();
	
	$message = "Thanks, $email - I'll send you a message soon.";
	
}


?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>You Guessed The Number!</title>
<link href="number.css" rel="stylesheet" type="text/css" />
</head>

<body>
<div id="mainWrapper">

<h1>Unbelievable</h1>
<p>
You have managed to guess the correct number.  I am incredibly impressed.  Please send me your email address, or send me an email at <a href="mailto:steve@steveshaddick.com">steve@steveshaddick.com</a>.
</p>

	<form id="frm" action="?" method="POST">
    <input type="hidden" id="action" name="action" value="email"/>
    <input type="text" name="txtEmail" id="txtEmail" />
    <input type="submit" value="Send" />
    </form>	
<p>
	<?=$message?>
</p>
    
</div>

</body>
</html>