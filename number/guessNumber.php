<?php

require_once('includes/_init.php');

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'includes/PHPMailer/src/Exception.php';
require 'includes/PHPMailer/src/PHPMailer.php';
require 'includes/PHPMailer/src/SMTP.php';

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
			$mail = new PHPMailer();
			$mail->isSMTP();
			$mail->Host       = SMTP_HOST;
			$mail->SMTPAuth   = true;
			$mail->Username   = SMTP_USERNAME;
			$mail->Password   = SMTP_PASSWORD;
			$mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS; // Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` also accepted
			$mail->Port       = SMTP_PORT;

			$mail->setFrom('number@steveshaddick.com', 'Number.SteveShaddick.com');
			$mail->addAddress('steveshaddick@gmail.com', 'Steve Shaddick');

			$mail->Subject = 'Testing this numbers email';
			$mail->Body    = $message;
			//$mail->AltBody = convert_html_to_text($message);
			$mail->send();
		} else {
			$guessed = true;
			$mySQL->sendQuery("INSERT INTO Guesses SET guess=$guess, date_entered='$date'");
			$mySQL->sendQuery("UPDATE Number SET guessed=1");
			$message = "<p>Congratulations!  You have successfully guessed the number! Incredible!</p><p>Would you mind sending an email to steveshaddick@gmail.com to let me know who you are?</p>";
			
			$to = "steveshaddick@gmail.com";
			$subject = "Somebody guessed the number";
			$body = "Time: $date\n\r\n\r";
			$body .= "IP: ".$_SERVER['REMOTE_ADDR']."\n\r\n\r";
			$body .= "Guessed: $guess";
			
			$mail = new PHPMailer();
			try {
				$mail->isSMTP();
				$mail->Host       = SMTP_HOST;
				$mail->SMTPAuth   = true;
				$mail->Username   = SMTP_USERNAME;
				$mail->Password   = SMTP_PASSWORD;
				$mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS; // Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` also accepted
				$mail->Port       = SMTP_PORT;

				$mail->setFrom('number@steveshaddick.com', 'Number.SteveShaddick.com');
				$mail->addAddress('steveshaddick@gmail.com', 'Steve Shaddick');

				$mail->Subject = $subject;
				$mail->Body    = $body;
				//$mail->AltBody = convert_html_to_text($message);
				$mail->send();
			} catch (Exception $e) {
				// fail silent
			}
			
		}
	
	}

}

$_SESSION['lastTime'] = $time;


$return = array('guessed'=>$guessed, 'message'=>$message);

echo json_encode($return);


?>