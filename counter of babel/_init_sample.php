<?php

$mysqli = new mysqli("localhost", "[USER]", "[PASSWORD]", "babel");

/* check connection */
if ($mysqli->connect_errno) {
    printf("I cannot connect to the database.");
    exit();
}

?>
