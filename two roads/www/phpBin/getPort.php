<?php

require_once(dirname(__FILE__) . '/_init.php');

$result = mysql_query('SHOW VARIABLES', $link);
while ($row = mysql_fetch_assoc($result)) {
   echo $row['Variable_name'] . ' = ' . $row['Value']."\n"."_________________ ";
}
mysql_close();
?>
