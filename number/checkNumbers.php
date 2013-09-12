<?php

require_once('includes/_init.php');

$lastID = isset($_POST['lastID']) ? intval($_POST['lastID']) : 0;
$page = isset($_POST['page']) ? intval($_POST['page']) : 0;
$offset = $page * 250;

$result = $mySQL->sendQuery("SELECT COUNT(*) as total_count FROM Guesses");
$total = $result[0]['total_count'];

$next = ($total > ($offset + 250)) ? true : false;
$previous = ($page > 0) ? true : false;


if ($page == 0) {
	$result = $mySQL->sendQuery("SELECT * FROM Guesses WHERE guess_id > $lastID ORDER BY guess_id DESC LIMIT 250");
} else {
	$result = $mySQL->sendQuery("SELECT * FROM Guesses ORDER BY guess_id DESC LIMIT $offset, 250");
}


$return = array('next'=>$next, 'previous'=>$previous, 'guesses'=>$result);

echo json_encode($return);

?>