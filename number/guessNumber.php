<?php

require_once('includes/_init.php');

$lastTime = isset($_SESSION['lastTime']) ? $_SESSION['lastTime'] : 0;
$time = time();

$guessed = false;

if ($time <= $lastTime) {
	$guessed = false;
	$message = "You may only make one guess per second.";

} else {
	
	$guess = isset($_POST['guess']) ? intval($_POST['guess']) : 0;
	
	if ($guess < 1) {
		$guessed = false;
		$message = "Please guess a number between 1 and 9,223,372,036,854,775,807.";
	
	} else {
		$encryptedGuess = Encryptor::encrypt($guess, SALT);
		$result = $mySQL->sendQuery("SELECT * FROM Number WHERE '$encryptedGuess' = Number.number");
		if (count($result) == 0) {
			$guessResult = $mySQL->sendQuery("SELECT * FROM Guesses WHERE $guess = guess");
			if (count($guessResult) == 0) {
				$date = date("Y-m-d H:i:s");
				$mySQL->sendQuery("INSERT INTO Guesses SET guess=$guess, date_entered='$date'");
				$guessed = false;
				$message = "Sorry, $guess is not the number I'm thinking of.";
			} else {
				$guessed = false;
				$message = "$guess has already been guessed.";
			}
		} else {
			$guessed = true;
			$mySQL->sendQuery("INSERT INTO Guesses SET guess=$guess, date_entered='$date'");
			$mySQL->sendQuery("UPDATE Number SET guessed=1");
			$message = "Congratulations!  You have successfully guessed the number!";
			
			$to = "steve@steveshaddick.com";
			$subject = "Somebody guessed the number";
			$body = "Time: $date\n\r\n\r";
			$body .= "IP: ".$_SERVER['REMOTE_ADDR']."\n\r\n\r";
			$body .= "Guessed: $guess";
			
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
			
		}
	
	}

}

$_SESSION['lastTime'] = $time;


$return = array('guessed'=>$guessed, 'message'=>$message);

echo json_encode($return);


?>